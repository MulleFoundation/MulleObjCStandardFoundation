//
//  NSLocale.m
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
#import "NSLocale.h"

// other files in this library

// other libraries of MulleObjCPosixFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies


NSString   *NSLocaleCollationIdentifier                 = @"collation";
NSString   *NSLocaleIdentifier                          = @"identifier";
NSString   *NSLocaleLanguageCode                        = @"languageCode";
NSString   *NSLocaleScriptCode                          = @"scriptCode";
NSString   *NSLocaleVariantCode                         = @"variantCode";

NSString   *NSLocaleCalendar                            = @"calendar";
NSString   *NSLocaleCountryCode                         = @"countryCode";
NSString   *NSLocaleCurrencyCode                        = @"currencyCode";
NSString   *NSLocaleCurrencySymbol                      = @"currencySymbol";
NSString   *NSLocaleDecimalSeparator                    = @"decimalSeparator";
NSString   *NSLocaleExemplarCharacterSet                = @"exemplarCharacterSet";
NSString   *NSLocaleGroupingSeparator                   = @"groupingSeparator";
NSString   *NSLocaleMeasurementSystem                   = @"measurementSystem";
NSString   *NSLocaleUsesMetricSystem                    = @"usesMetricSystem";

// 10.6 stuff
NSString   *NSLocaleAlternateQuotationBeginDelimiterKey = @"alternateQuotationBeginDelimiter";
NSString   *NSLocaleAlternateQuotationEndDelimiterKey   = @"alternateQuotationEndDelimiter";
NSString   *NSLocaleCollatorIdentifier                  = @"collator";
NSString   *NSLocaleQuotationBeginDelimiterKey          = @"quotationBeginDelimiter";
NSString   *NSLocaleQuotationEndDelimiterKey            = @"quotationEndDelimiter";


// NSCalendarDate stuff

NSString   *NSAMPMDesignation           = @"NSAMPMDesignation";
NSString   *NSDateFormatString          = @"NSDateFormatString";
NSString   *NSDateTimeOrdering          = @"NSDateTimeOrdering";
NSString   *NSEarlierTimeDesignations   = @"NSEarlierTimeDesignations";
NSString   *NSHourNameDesignations      = @"NSHourNameDesignations";
NSString   *NSLaterTimeDesignations     = @"NSLaterTimeDesignations";
NSString   *NSMonthNameArray            = @"NSMonthNameArray";
NSString   *NSNextDayDesignations       = @"NSNextDayDesignations";
NSString   *NSNextNextDayDesignations   = @"NSNextNextDayDesignations";
NSString   *NSPriorDayDesignations      = @"NSPriorDayDesignations";
NSString   *NSShortDateFormatString     = @"NSShortDateFormatString";
NSString   *NSShortMonthNameArray       = @"NSShortMonthNameArray";
NSString   *NSShortTimeDateFormatString = @"NSShortTimeDateFormatString";
NSString   *NSShortWeekDayNameArray     = @"NSShortWeekDayNameArray";
NSString   *NSThisDayDesignations       = @"NSThisDayDesignations";
NSString   *NSTimeDateFormatString      = @"NSTimeDateFormatString";
NSString   *NSTimeFormatString          = @"NSTimeFormatString";
NSString   *NSWeekDayNameArray          = @"NSWeekDayNameArray";
NSString   *NSYearMonthWeekDesignations = @"NSYearMonthWeekDesignations";


// most of the code is OS Specific, so not much here

@implementation NSObject( _NSLocale)

- (BOOL) __isNSLocale
{
   return( NO);
}

@end


@implementation NSLocale

- (BOOL) __isNSLocale
{
   return( YES);
}


- (NSString *) localeIdentifier
{
   return( _identifier);
}


- (id) :(id) key;
{
   return( [_keyValues :key]);
}


- (id) objectForKey:(id) key;
{
   return( [_keyValues objectForKey:key]);
}


- (NSString *) displayNameForKey:(id) key
                           value:(id) value
{
   return( [NSString stringWithFormat:@"%@ = %@", key, value]);
}

- (id) copy
{
   return( [self retain]);
}


#pragma mark - hash and equality

- (NSUInteger) hash
{
   return( [self->_identifier hash]);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSLocale])
      return( NO);
   return( [self isEqualToLocale:other]);
}


- (BOOL) isEqualToLocale:(NSLocale *) other
{
   return( [self->_identifier isEqualToString:[other localeIdentifier]]);
}

@end
