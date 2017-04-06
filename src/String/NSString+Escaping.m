//
//  NSString+Escaping.m
//  MulleObjCFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#import "NSString+Escaping.h"

// other files in this library
#import "NSCharacterSet.h"
#import "NSString+NSData.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"

// std-c and dependencies

// what's the point of this warning, anyway ?
#pragma clang diagnostic ignored "-Wint-to-void-pointer-cast"


@implementation NSString (Escaping)


#pragma mark -
#pragma mark escape

static inline mulle_utf8_t   hex( mulle_utf8_t c)
{
   assert( c >= 0 && c <= 0xf);
   return( c >= 0xa ? c + 'a' - 0xa : c + '0');
}


- (NSString *) stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *) allowedCharacters
{
   IMP            characterIsMemberIMP;
   NSUInteger     dst_length;
   NSUInteger     length;
   SEL            characterIsMemberSEL;
   mulle_utf8_t   *buf;
   mulle_utf8_t   *dst_buf;
   mulle_utf8_t   *p;
   mulle_utf8_t   *s;
   mulle_utf8_t   *sentinel;
   mulle_utf8_t   c;

   length = [self _UTF8StringLength];
   if( ! length)
      return( self);

   buf = (mulle_utf8_t *) [[NSMutableData dataWithLength:length] mutableBytes];
   [self _getUTF8Characters:buf
                 maxLength:length];

   characterIsMemberSEL = @selector( characterIsMember:);
   characterIsMemberIMP = [allowedCharacters methodForSelector:characterIsMemberSEL];;

   dst_buf  = NULL;
   p        = dst_buf;
   s        = buf;
   sentinel = &s[ length];

   while( s < sentinel)
   {
      c = *s++;
      if( (*characterIsMemberIMP)( allowedCharacters, characterIsMemberSEL, (void *) c))
      {
         if( p)
            *p++ = c;
         continue;
      }

      if( ! p)
      {
         dst_buf    = [[NSMutableData dataWithLength:length * 3] mutableBytes];
         dst_length = s - buf - 1;
         memcpy( dst_buf, buf, dst_length);
         p          = &dst_buf[ dst_length];
      }

      *p++ = '%';
      *p++ = hex( c >> 4);
      *p++ = hex( c & 0xF);
   }

   if( ! dst_buf)
      return( self);

   return( [NSString _stringWithUTF8Characters:dst_buf
                                        length:p - dst_buf]);
}


- (NSString *) stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding) encoding
{
   NSCharacterSet   *characterSet;

   NSAssert( encoding == NSUTF8StringEncoding, @"only suppports NSUTF8StringEncoding");
   characterSet = [NSCharacterSet nonPercentEscapeCharacterSet];
   return( [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet]);
}


#pragma mark -
#pragma mark unescape


static id   always_no( id obj, SEL sel, void *param)
{
   return( (id) NO);
}


static inline int   dehex( mulle_utf8_t c)
{
   if( c >= '0' && c <= '9')
      return( c - '0');

   if( c >= 'A' && c <= 'Z')
      return( c - 'a' + 10);

   if( c >= 'a' && c <= 'z')
      return( c - 'a' + 10);

   return( -1);  // two wrongs will make a "right"
}


- (NSString *) stringByReplacingPercentEscapesWithDisallowedCharacters:(NSCharacterSet *) disallowedCharacters
{
   IMP            characterIsMemberIMP;
   NSUInteger     dst_length;
   NSUInteger     length;
   SEL            characterIsMemberSEL;
   mulle_utf8_t   *buf;
   mulle_utf8_t   *dst_buf;
   mulle_utf8_t   *p;
   mulle_utf8_t   *s;
   mulle_utf8_t   *sentinel;
   mulle_utf8_t   c;
   int            hi, lo;

   length = [self _UTF8StringLength];
   if( ! length)
      return( self);

   buf = (mulle_utf8_t *) [[NSMutableData dataWithLength:length] mutableBytes];
   [self _getUTF8Characters:buf
                 maxLength:length];

   characterIsMemberSEL = @selector( characterIsMember:);
   if( disallowedCharacters)
      characterIsMemberIMP = [disallowedCharacters methodForSelector:characterIsMemberSEL];
   else
      characterIsMemberIMP = (IMP) always_no;

   dst_buf  = NULL;
   p        = dst_buf;
   s        = buf;
   sentinel = &s[ length];

   while( s < sentinel)
   {
      c = *s++;
      if( c != '%')
      {
         if( p)
            *p++ = c;
         continue;
      }

      if( &s[ 2] >= sentinel)
         return( nil);

      hi = dehex( s[ 0]);
      lo = dehex( s[ 1]);

      if( hi < 0 || lo < 0)
         return( nil);
      c = (mulle_utf8_t) (hi << 4 | lo);
      if( ! c)
         return( nil);

      if( (*characterIsMemberIMP)( disallowedCharacters, characterIsMemberSEL, (void *) c))
         return( nil);

      if( ! p)
      {
         dst_buf    = [[NSMutableData dataWithLength:length] mutableBytes];
         dst_length = s - buf - 1;
         memcpy( dst_buf, buf, dst_length);
         p          = &dst_buf[ dst_length];
      }

      *p++ = c;
      s   += 2;
   }

   if( ! dst_buf)
      return( self);

   return( [NSString _stringWithUTF8Characters:dst_buf
                                        length:p - dst_buf]);
}


- (NSString *) stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding) encoding
{
   NSCharacterSet   *characterSet;

   NSAssert( encoding == NSUTF8StringEncoding, @"only suppports NSUTF8StringEncoding");
   characterSet = [NSCharacterSet nonPercentEscapeCharacterSet];
   return( [self stringByReplacingPercentEscapesWithDisallowedCharacters:characterSet]);
}

- (NSString *) stringByRemovingPercentEncoding
{
   return( [self stringByReplacingPercentEscapesWithDisallowedCharacters:nil]);
}


@end
