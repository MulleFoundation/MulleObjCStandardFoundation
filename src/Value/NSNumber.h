//
//  NSNumber.h
//  MulleObjCFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "NSValue.h"


typedef struct
{
#ifdef __LITTLE_ENDIAN__
   uint64_t   lo;
   int64_t    hi;
#else
   int64_t    hi;
   uint64_t   lo;
#endif
} _ns_superquad;


static inline int   _ns_superquad_compare( _ns_superquad a, _ns_superquad b)
{
   if( a.hi != b.hi)
      return( a.hi < b.hi ? NSOrderedAscending : NSOrderedDescending);

   if( a.lo == b.lo)
      return( NSOrderedSame);

    return( a.lo < b.lo ? NSOrderedAscending : NSOrderedDescending);
}


@interface NSNumber : NSValue < NSCopying, MulleObjCClassCluster>
{
}


+ (id) numberWithChar:(char) value;
+ (id) numberWithUnsignedChar:(unsigned char) value;
+ (id) numberWithShort:(short) value;
+ (id) numberWithUnsignedShort:(unsigned short) value;
+ (id) numberWithInt:(int) value;
+ (id) numberWithUnsignedInt:(unsigned int) value;
+ (id) numberWithInteger:(NSInteger) value;
+ (id) numberWithUnsignedInteger:(NSUInteger) value;
+ (id) numberWithLong:(long) value;
+ (id) numberWithUnsignedLong:(unsigned long) value;
+ (id) numberWithLongLong:(long long) value;
+ (id) numberWithUnsignedLongLong:(unsigned long long) value;
+ (id) numberWithFloat:(float) value;
+ (id) numberWithDouble:(double) value;
+ (id) numberWithLongDouble:(long double) value;
+ (id) numberWithBool:(BOOL) value;

- (NSComparisonResult) compare:(id) other;
- (BOOL) isEqualToNumber:(id) other;
- (BOOL) isEqual:(id) other;
- (NSUInteger) hash;

- (id) initWithChar:(char) value;
- (id) initWithUnsignedChar:(unsigned char) value;
- (id) initWithShort:(short) value;
- (id) initWithUnsignedShort:(unsigned short) value;
- (id) initWithInt:(int) value;
- (id) initWithUnsignedInt:(unsigned int) value;
- (id) initWithInteger:(NSInteger) value;
- (id) initWithUnsignedInteger:(NSUInteger) value;
- (id) initWithLong:(long) value;
- (id) initWithUnsignedLong:(unsigned long) value;
- (id) initWithLongLong:(long long) value;
- (id) initWithUnsignedLongLong:(unsigned long long) value;
- (id) initWithFloat:(float) value;
- (id) initWithDouble:(double) value;
- (id) initWithLongDouble:(long double) value;
- (id) initWithBool:(BOOL) value;

- (BOOL) boolValue;
- (NSUInteger) unsignedIntegerValue;
- (char) charValue;
- (unsigned char) unsignedCharValue;
- (short) shortValue;
- (unsigned short) unsignedShortValue;
- (int) intValue;
- (unsigned int) unsignedIntValue;
- (long) longValue;
- (unsigned long) unsignedLongValue;
- (float) floatValue;
- (unsigned long long) unsignedLongLongValue;


// need this for comparison until I get smarter
- (_ns_superquad) _superquadValue;

@end


@interface NSNumber ( Subclasses)

- (NSInteger) integerValue;
- (double) doubleValue;
- (long double) longDoubleValue;
- (long long) longLongValue;

@end
