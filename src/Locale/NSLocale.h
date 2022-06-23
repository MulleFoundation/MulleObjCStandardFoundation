//
//  NSLocale.h
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
#import "import.h"

@class NSArray;
@class NSString;
@class NSDictionary;



@interface NSLocale : NSObject <NSCopying, MulleObjCImmutable>
{
   NSString   *_identifier;
   void       *_xlocale;
   void       *_iculocale;
   id         _keyValues;
}

+ (instancetype) localeWithLocaleIdentifier:(NSString *) s;
+ (instancetype) autoupdatingCurrentLocale;
- (NSString *) displayNameForKey:(id) key
                           value:(id) value;


// these are currently hard cached on +intitialize
+ (instancetype) systemLocale;
+ (instancetype) currentLocale;

- (NSString *) localeIdentifier;
- (NSString *) languageCode;
- (NSString *) scriptCode;
- (NSString *) variantCode;
- (NSString *) collationIdentifier;
- (NSString *) currencyCode;
- (NSString *) calendarIdentifier;


- (NSString *) localizedStringForLocaleIdentifier:(NSString *)localeIdentifier;
- (NSString *) localizedStringForCountryCode:(NSString *) countryCode;
- (NSString *) localizedStringForLanguageCode:(NSString *) languageCode;
- (NSString *) localizedStringForScriptCode:(NSString *) scriptCode;
- (NSString *) localizedStringForVariantCode:(NSString *) variantCode;
- (NSString *) localizedStringForCollationIdentifier:(NSString *) collationIdentifier;
- (NSString *) localizedStringForCollatorIdentifier:(NSString *) collatorIdentifier;
- (NSString *) localizedStringForCurrencyCode:(NSString *) currencyCode;
- (NSString *) localizedStringForCalendarIdentifier:(NSString *) calendarIdentifier;

@end


@interface NSLocale( Future)

+ (instancetype) _systemLocale;
+ (instancetype) _currentLocale;

+ (NSArray *) availableLocaleIdentifiers;
+ (NSArray *) ISOLanguageCodes;
+ (NSArray *) ISOCountryCodes;
+ (NSArray *) ISOCurrencyCodes;

+ (NSDictionary *) componentsFromLocaleIdentifier:(NSString *) string;
+ (NSString *) localeIdentifierFromComponents:(NSDictionary *) dict;

+ (NSString *) canonicalLocaleIdentifierFromString:(NSString *) string;
+ (NSString *) canonicalLanguageIdentifierFromString:(NSString *) string;

- (id) :(id) key;
- (id) objectForKey:(id) key;

- (BOOL) isEqualToLocale:(NSLocale *) other;

- (instancetype) initWithLocaleIdentifier:(NSString *) s;

@end


MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleAlternateQuotationBeginDelimiterKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleAlternateQuotationEndDelimiterKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleCalendar;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleCollationIdentifier;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleCollatorIdentifier;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleCountryCode;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleCurrencyCode;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleCurrencySymbol;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleDecimalSeparator;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleExemplarCharacterSet;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleGroupingSeparator;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleIdentifier;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleLanguageCode;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleMeasurementSystem;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleQuotationBeginDelimiterKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleQuotationEndDelimiterKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleScriptCode;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleUsesMetricSystem;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocaleVariantCode;


MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSAMPMDesignation;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSDateFormatString;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSDateTimeOrdering;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSEarlierTimeDesignations;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSHourNameDesignations;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLaterTimeDesignations;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSMonthNameArray;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSNextDayDesignations;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSNextNextDayDesignations;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSPriorDayDesignations;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSShortDateFormatString;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSShortMonthNameArray;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSShortTimeDateFormatString;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSShortWeekDayNameArray;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSThisDayDesignations;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSTimeDateFormatString;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSTimeFormatString;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSWeekDayNameArray;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSYearMonthWeekDesignations;

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSCurrencySymbol;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSDecimalDigits; // ?? check with macos
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSDecimalSeparator;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSInternationalCurrencyString;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSNegativeCurrencyFormatString;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSPositiveCurrencyFormatString;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSThousandsSeparator;
