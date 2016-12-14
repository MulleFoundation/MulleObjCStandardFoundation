//
//  NSCharacterSet.m
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

#import "NSCharacterSet.h"

// other files in this library
#import "_MulleObjCConcreteCharacterSet.h"
#import "_MulleObjCConcreteBitmapCharacterSet.h"
#import "_MulleObjCConcreteRangeCharacterSet.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationData.h"

// std-c and dependencies


@implementation NSCharacterSet

+ (NSCharacterSet *) alphanumericCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_alphanumeric
                                                   planeFunction:mulle_utf_is_alphanumericplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) capitalizedLetterCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_capitalized
                                                   planeFunction:mulle_utf_is_capitalizedplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) controlCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_control
                                                   planeFunction:mulle_utf_is_controlplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) decimalDigitCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_decimaldigit
                                                   planeFunction:mulle_utf_is_decimaldigitplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) decomposableCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_decomposable
                                                   planeFunction:mulle_utf_is_decomposableplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) letterCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_letter
                                                   planeFunction:mulle_utf_is_letterplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) lowercaseLetterCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_lowercase
                                                   planeFunction:mulle_utf_is_lowercaseplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) nonBaseCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_nonbase
                                                   planeFunction:mulle_utf_is_nonbaseplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) punctuationCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_punctuation
                                                   planeFunction:mulle_utf_is_punctuationplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) symbolCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_symbol
                                                   planeFunction:mulle_utf_is_symbolplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) uppercaseLetterCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_uppercase
                                                   planeFunction:mulle_utf_is_uppercaseplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) whitespaceAndNewlineCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_whitespaceornewline
                                                   planeFunction:mulle_utf_is_whitespaceornewlineplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) whitespaceCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_whitespace
                                                   planeFunction:mulle_utf_is_whitespaceplane
                                                          invert:NO] autorelease]);
}



+ (NSCharacterSet *) URLFragmentAllowedCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlfragment
                                                   planeFunction:mulle_utf_is_validurlfragmentplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) URLHostAllowedCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlhost
                                                   planeFunction:mulle_utf_is_validurlhostplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) URLPasswordAllowedCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlpassword
                                                   planeFunction:mulle_utf_is_validurlpasswordplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) URLPathAllowedCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlpath
                                                   planeFunction:mulle_utf_is_validurlpathplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) URLQueryAllowedCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlquery
                                                    planeFunction:mulle_utf_is_validurlqueryplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) URLSchemeAllowedCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlscheme
                                                    planeFunction:mulle_utf_is_validurlschemeplane
                                                          invert:NO] autorelease]);
}


+ (NSCharacterSet *) URLUserAllowedCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurluser
                                                    planeFunction:mulle_utf_is_validurluserplane
                                                          invert:NO] autorelease]);
}



+ (NSCharacterSet *) nonPercentEscapeCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_nonpercentescape
                                                   planeFunction:mulle_utf_is_nonpercentescapeplane
                                                          invert:NO] autorelease]);
}



- (BOOL) isSupersetOfSet:(NSCharacterSet *) set
{
   unsigned int   i;
   long           c;
   
   // trivial check
   if( self == set)
      return( YES);

   if( ! set)
      return( YES);  // i guess
   
   // simplistic easy check
   for( i = 0; i <= 0x10; i++)
      if( [set hasMemberInPlane:i] && ! [self hasMemberInPlane:i])
         return( NO);
   
   // ultra layme
   
   for( c = 0; c <= mulle_utf32_max; c++)
      if( [self longCharacterIsMember:c] != [set longCharacterIsMember:c])
         return( NO);

   return( YES);
}


- (BOOL) longCharacterIsMember:(long) c
{
   return( [self characterIsMember:(unichar) c]);
}


- (void) getBitmapBytes:(unsigned char *) bytes
                  plane:(unsigned int) plane
{
   long   c;
   long   end;
   
   c   = plane * 0x10000;
   end = c + 0x10000;
   for( ; c < end; c += 8)
   {
      *bytes++ = (unsigned char)
      (([self longCharacterIsMember:c] << 0) |
       ([self longCharacterIsMember:c + 1] << 1) |
       ([self longCharacterIsMember:c + 2] << 2) |
       ([self longCharacterIsMember:c + 3] << 3) |
       ([self longCharacterIsMember:c + 4] << 4) |
       ([self longCharacterIsMember:c + 5] << 5) |
       ([self longCharacterIsMember:c + 6] << 6) |
       ([self longCharacterIsMember:c + 7] << 7));
   }
}


- (id) initWithBitmapRepresentation:(NSData *) data
{
   NSUInteger   size;
   NSUInteger   n_planes;
   void         *bytes;
   
   [self release];

   size     = [data length];
   n_planes = 1 + (size - 8192) / 8193;
   if( 8192 + (n_planes - 1) * 8193 != size)
      return( nil);
   
   data  = [[data copy] autorelease];
   bytes = [data bytes];
   
   return( [_MulleObjCConcreteBitmapCharacterSet newWithBitmapPlanes:bytes
                    invert:NO
                 allocator:NULL
                     owner:data]);
}


- (NSData *) bitmapRepresentation
{
   unsigned char   planes[ 0x11];
   unsigned int    i;
   unsigned int    extra;
   NSMutableData   *data;
   unsigned char   *p;
   
   extra = 0;
   for( i = 1; i <= 0x10; i++)
      if( planes[ i] = [self hasMemberInPlane:i])
         ++extra;

   data  = [NSMutableData dataWithLength:8192 + extra * 8193];
   p     = [data mutableBytes];
   
   [self getBitmapBytes:p
                  plane:0];
   p = &p[ 8192];
   
   for( i = 1; i <= 0x10; i++)
   {
      if( ! planes[ i])
         continue;

      *p++ = planes[ i];

      [self getBitmapBytes:p
                     plane:i];
      p = &p[ 8192];
   }
   
   return( data);
}

@end
