//
//  NSCharacterSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 04.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
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
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_alphanumeric
                                                   planeFunction:mulle_utf_is_alphanumericplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) capitalizedLetterCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_capitalized
                                                   planeFunction:mulle_utf_is_capitalizedplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) controlCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_control
                                                   planeFunction:mulle_utf_is_controlplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) decimalDigitCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_decimaldigit
                                                   planeFunction:mulle_utf_is_decimaldigitplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) decomposableCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_decomposable
                                                   planeFunction:mulle_utf_is_decomposableplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) letterCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_letter
                                                   planeFunction:mulle_utf_is_letterplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) lowercaseLetterCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_lowercase
                                                   planeFunction:mulle_utf_is_lowercaseplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) nonBaseCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_nonbase
                                                   planeFunction:mulle_utf_is_nonbaseplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) punctuationCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_punctuation
                                                   planeFunction:mulle_utf_is_punctuationplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) symbolCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_symbol
                                                   planeFunction:mulle_utf_is_symbolplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) uppercaseLetterCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_uppercase
                                                   planeFunction:mulle_utf_is_uppercaseplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) whitespaceAndNewlineCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_whitespaceornewline
                                                   planeFunction:mulle_utf_is_whitespaceornewlineplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) whitespaceCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_whitespace
                                                   planeFunction:mulle_utf_is_whitespaceplane
                                                          invert:NO]);
}



+ (NSCharacterSet *) URLFragmentAllowedCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlfragment
                                                   planeFunction:mulle_utf_is_validurlfragmentplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) URLHostAllowedCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlhost
                                                   planeFunction:mulle_utf_is_validurlhostplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) URLPasswordAllowedCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlpassword
                                                   planeFunction:mulle_utf_is_validurlpasswordplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) URLPathAllowedCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlpath
                                                   planeFunction:mulle_utf_is_validurlpathplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) URLQueryAllowedCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurlquery
                                                   planeFunction:mulle_utf_is_validurlqueryplane
                                                          invert:NO]);
}


+ (NSCharacterSet *) URLUserAllowedCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_validurluser
                                                   planeFunction:mulle_utf_is_validurluserplane
                                                          invert:NO]);
}



+ (NSCharacterSet *) nonPercentEscapeCharacterSet
{
   [self release];
   return( [_MulleObjCConcreteCharacterSet newWithMemberFunction:mulle_utf32_is_nonpercentescape
                                                   planeFunction:mulle_utf_is_nonpercentescapeplane
                                                          invert:NO]);
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
