//
//  NSNumber.h
//  MulleObjCStandardFoundation
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


+ (instancetype) numberWithChar:(char) value;
+ (instancetype) numberWithUnsignedChar:(unsigned char) value;
+ (instancetype) numberWithShort:(short) value;
+ (instancetype) numberWithUnsignedShort:(unsigned short) value;
+ (instancetype) numberWithInt:(int) value;
+ (instancetype) numberWithUnsignedInt:(unsigned int) value;
+ (instancetype) numberWithInteger:(NSInteger) value;
+ (instancetype) numberWithUnsignedInteger:(NSUInteger) value;
+ (instancetype) numberWithLong:(long) value;
+ (instancetype) numberWithUnsignedLong:(unsigned long) value;
+ (instancetype) numberWithLongLong:(long long) value;
+ (instancetype) numberWithUnsignedLongLong:(unsigned long long) value;
+ (instancetype) numberWithFloat:(float) value;
+ (instancetype) numberWithDouble:(double) value;
+ (instancetype) numberWithLongDouble:(long double) value;
+ (instancetype) numberWithBool:(BOOL) value;

- (NSComparisonResult) compare:(id) other;
- (BOOL) isEqualToNumber:(id) other;

- (instancetype) initWithChar:(char) value;
- (instancetype) initWithUnsignedChar:(unsigned char) value;
- (instancetype) initWithShort:(short) value;
- (instancetype) initWithUnsignedShort:(unsigned short) value;
- (instancetype) initWithInt:(int) value;
- (instancetype) initWithUnsignedInt:(unsigned int) value;
- (instancetype) initWithInteger:(NSInteger) value;
- (instancetype) initWithUnsignedInteger:(NSUInteger) value;
- (instancetype) initWithLong:(long) value;
- (instancetype) initWithUnsignedLong:(unsigned long) value;
- (instancetype) initWithLongLong:(long long) value;
- (instancetype) initWithUnsignedLongLong:(unsigned long long) value;
- (instancetype) initWithFloat:(float) value;
- (instancetype) initWithDouble:(double) value;
- (instancetype) initWithLongDouble:(long double) value;
- (instancetype) initWithBool:(BOOL) value;

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


//
// If you use initWithBOOL: then you get a MulleObjCBoolNumber
// this can be useful when you want to serialize into true/false for JSON
// when you add a -JSONdescription or some such method
//
@interface MulleObjCBoolNumber : NSNumber
{
   BOOL   _value;
}

+ (instancetype) newWithBOOL:(BOOL) value;

@end
