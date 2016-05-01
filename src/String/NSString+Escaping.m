//
//  NSString+Escaping.m
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString+Escaping.h"

// other files in this library
#import "NSCharacterSet.h"
#import "NSString+NSData.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"

// std-c and dependencies


@implementation NSString (Escaping)


static inline mulle_utf8_t   hex( mulle_utf8_t c)
{
   assert( c >= 0 && c <= 0xf);
   return( c >= 0xa ? c + 'a' - 0xa : c + '0');
}


- (NSString *) stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *) allowedCharacters
{
   mulle_utf8_t      *s;
   mulle_utf8_t      *p;
   mulle_utf8_t      *buf;
   mulle_utf8_t      *sentinel;
   NSUInteger        length;
   mulle_utf8_t      *dst_buf;
   NSUInteger        dst_length;
   mulle_utf8_t      c;
   SEL               characterIsMemberSEL;
   IMP               characterIsMemberIMP;
   
   length = [self _UTF8StringLength];
   if( ! length)
      return( self);
   
   buf = (mulle_utf8_t *) [[NSMutableData dataWithLength:length] mutableBytes];
   [self getUTF8Characters:buf
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
   
   return( [NSString stringWithUTF8Characters:dst_buf
                                       length:p - dst_buf]);
}


- (NSString *) stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding) encoding
{
   NSAssert( encoding != NSUTF8StringEncoding, @"only suppports NSUTF8StringEncoding");
   return( [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet nonPercentEscapeCharacterSet]]);
}

@end
