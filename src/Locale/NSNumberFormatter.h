//
//  NSNumberFormatter.h
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
#import "NSFormatter.h"


@class NSNumber;
@class NSString;
@class NSLocale;


enum
{
    NSNumberFormatterBehaviorDefault = 0,
    NSNumberFormatterBehavior10_0    = 1000,
    NSNumberFormatterBehavior10_4    = 1040  // defined but do not have
};
typedef NSUInteger NSNumberFormatterBehavior;


@interface NSNumberFormatter : NSFormatter
{
   id         _roundingBehavior;
   struct
   {
      unsigned    allowsFloats:1;
      unsigned    generatesDecimalNumbers:1;
      unsigned    hasThousandSeparators:1;
      unsigned    localizesFormat:1;
      unsigned    isLenient:1;
      unsigned    unused:11;
   } _flags;
}

@property( assign) NSNumberFormatterBehavior  formatterBehavior;

@property( retain) NSLocale   *locale;
@property( copy, nonnull) NSString     *format;
@property( copy) NSString     *negativeFormat;
@property( copy) NSString     *positiveFormat;
@property( copy) NSString     *decimalSeparator;
@property( copy) NSString     *thousandSeparator;
@property( retain) NSNumber   *minimum;
@property( retain) NSNumber   *maximum;


+ (NSNumberFormatterBehavior) defaultFormatterBehavior;
+ (void) setDefaultFormatterBehavior:(NSNumberFormatterBehavior) behavior;

- (BOOL) allowsFloats;
- (BOOL) generatesDecimalNumbers;
- (BOOL) hasThousandSeparators;
- (BOOL) isLenient;
- (void) setAllowsFloats:(BOOL) flag;
- (void) setGeneratesDecimalNumbers:(BOOL) flag;
- (void) setHasThousandSeparators:(BOOL) flag;
- (void) setLenient:(BOOL) flag;

- (NSNumber *) numberFromString:(NSString *) string;
- (NSString *) stringFromNumber:(NSNumber *) number;

@end


@interface NSNumberFormatter (Localization)

- (BOOL) localizesFormat;
- (void) setLocalizesFormat:(BOOL)flag;

@end
