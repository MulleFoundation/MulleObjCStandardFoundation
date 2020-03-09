//
//  NSMutableCharacterSet.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2019 Nat! - Mulle kybernetiK.
//  Copyright (c) 2019 Codeon GmbH.
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
#import "NSMutableCharacterSet.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardFoundationException.h"

// std-c and dependencies


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation NSCharacterSet( MutableCopy)

- (id) mutableCopy
{
   NSMutableCharacterSet   *set;

   set = [NSMutableCharacterSet new];
   [set formUnionWithCharacterSet:self];
   return( set);
}

@end


@implementation NSMutableCharacterSet

// as we are "breaking out" of the class cluster, use standard
// allocation

+ (instancetype) alloc
{
   return( NSAllocateObject( self, 0, NULL));
}


+ (instancetype) allocWithZone:(NSZone *) zone
{
   return( NSAllocateObject( self, 0, NULL));
}


- (instancetype) initWithBitmapRepresentation:(NSData *) data
{
   MulleObjCCharacterBitmapInitWithBitmapRepresentation( &self->_bitmap,data,
                                                         MulleObjCInstanceGetAllocator( self));
   return( self);
}


- (void) dealloc
{
   MulleObjCCharacterBitmapFreePlanes( &self->_bitmap,
                                       MulleObjCInstanceGetAllocator( self));
   NSDeallocateObject( self);
}


- (id) copy
{
   NSCharacterSet   *set;
   NSData           *data;

   data = [self bitmapRepresentation];
   set  = [[NSCharacterSet alloc] initWithBitmapRepresentation:data];
   return( set);
}


/* sucks so much to reimplement all this */

+ (instancetype) characterSetWithCharactersInString:(NSString *) s
{
   NSMutableCharacterSet   *set;

   set = [[self new] autorelease];
   MulleObjCCharacterBitmapSetBitsWithString( &set->_bitmap,
                                              s,
                                              MulleObjCInstanceGetAllocator( set));
   return( set);
}


static id   construct( SEL _cmd)
{
   return( [[[NSCharacterSet performSelector:_cmd] mutableCopy] autorelease]);
}



+ (instancetype) alphanumericCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) capitalizedLetterCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) controlCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) decimalDigitCharacterSet
{
   return( construct( _cmd));

}


+ (instancetype) decomposableCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) illegalCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) letterCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) lowercaseLetterCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) nonBaseCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) punctuationCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) symbolCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) uppercaseLetterCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) whitespaceAndNewlineCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) whitespaceCharacterSet
{
   return( construct( _cmd));
}

 // move this to INetFoundtion

+ (instancetype) URLFragmentAllowedCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) URLHostAllowedCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) URLPasswordAllowedCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) URLPathAllowedCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) URLQueryAllowedCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) URLUserAllowedCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) mulleNonPercentEscapeCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) mulleURLAllowedCharacterSet
{
   return( construct( _cmd));
}


+ (instancetype) mulleURLSchemeAllowedCharacterSet
{
   return( construct( _cmd));
}




- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   if( plane >= 0x11)
      return( NO);
   return( _bitmap.planes[ plane] != NULL ? ! _invert : _invert);
}


- (BOOL) characterIsMember:(unichar) c
{
   return( MulleObjCCharacterBitmapGetBit( &_bitmap, c) ? ! _invert : _invert);
}


static int   mulle_meminvert_8( uint8_t *buf, size_t length)
{
   uint8_t   *p;
   uint8_t   *sentinel;
   uint8_t   bits;

   bits     = 0;
   p        = buf;
   sentinel = &p[ length];
   while( p < sentinel)
   {
      bits |= (*p = ~*p);
      ++p;
   }

   return( (int) bits);
}


- (void) mulleGetBitmapBytes:(unsigned char *) bytes
                       plane:(NSUInteger) plane
{
   if( ! bytes)
      MulleObjCThrowInvalidArgumentException( @"empty bytes");
   if( plane >= 0x11)
      MulleObjCThrowInvalidArgumentException( @"excessive plane index");

   if( _bitmap.planes[ plane])
   {
      memcpy( bytes, _bitmap.planes[ plane], 8192);
      if( _invert)
         mulle_meminvert_8( bytes, 8192);
   }
   else
      memset( bytes, _invert ? 0xFF: 0x0, 8192);
}


- (void) addCharactersInRange:(NSRange) range
{
   range = MulleObjCValidateRangeAgainstLength( range, 0x110000);

   if( ! _invert)
      MulleObjCCharacterBitmapSetBitsInRange( &_bitmap, range, MulleObjCInstanceGetAllocator( self));
   else
      MulleObjCCharacterBitmapClearBitsInRange( &_bitmap, range, MulleObjCInstanceGetAllocator( self));
}


- (void) removeCharactersInRange:(NSRange) range
{
   range = MulleObjCValidateRangeAgainstLength( range, 0x110000);

   if( ! _invert)
      MulleObjCCharacterBitmapClearBitsInRange( &_bitmap, range, MulleObjCInstanceGetAllocator( self));
   else
      MulleObjCCharacterBitmapSetBitsInRange( &_bitmap, range, MulleObjCInstanceGetAllocator( self));
}


- (void) addCharactersInString:(NSString *) s
{
   if( ! _invert)
      MulleObjCCharacterBitmapSetBitsWithString( &_bitmap, s, MulleObjCInstanceGetAllocator( self));
   else
      MulleObjCCharacterBitmapClearBitsWithString( &_bitmap, s, MulleObjCInstanceGetAllocator( self));
}


- (void) removeCharactersInString:(NSString *) s
{
   if( ! _invert)
      MulleObjCCharacterBitmapClearBitsWithString( &_bitmap, s, MulleObjCInstanceGetAllocator( self));
   else
      MulleObjCCharacterBitmapSetBitsWithString( &_bitmap, s, MulleObjCInstanceGetAllocator( self));
}


- (void) formIntersectionWithCharacterSet:(NSCharacterSet *) other
{
   struct MulleObjCCharacterBitmap   tmp;
   NSData                            *data;
   struct mulle_allocator            *allocator;

   data      = [other bitmapRepresentation];
   allocator = MulleObjCInstanceGetAllocator( self);
   MulleObjCCharacterBitmapInitWithBitmapRepresentation( &tmp, data, allocator);

   if( ! _invert)
      MulleObjCCharacterBitmapLogicOperation( &_bitmap, &tmp, MulleObjCCharacterBitmapAND, allocator);
   else
      MulleObjCCharacterBitmapLogicOperation( &_bitmap, &tmp, MulleObjCCharacterBitmapNAND, allocator);

   MulleObjCCharacterBitmapFreePlanes( &tmp, allocator);
}


- (void) formUnionWithCharacterSet:(NSCharacterSet *) other
{
   struct MulleObjCCharacterBitmap   tmp;
   NSData                            *data;
   struct mulle_allocator            *allocator;

   data      = [other bitmapRepresentation];
   allocator = MulleObjCInstanceGetAllocator( self);
   MulleObjCCharacterBitmapInitWithBitmapRepresentation( &tmp, data, allocator);

   if( ! _invert)
      MulleObjCCharacterBitmapLogicOperation( &_bitmap, &tmp, MulleObjCCharacterBitmapOR, allocator);
   else
      MulleObjCCharacterBitmapLogicOperation( &_bitmap, &tmp, MulleObjCCharacterBitmapNOR, allocator);

   MulleObjCCharacterBitmapFreePlanes( &tmp, allocator);
}


- (void) invert
{
   _invert = ! _invert;
}

@end


