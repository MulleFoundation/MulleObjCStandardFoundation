//
//  NSLocale.h
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
#import <MulleObjC/MulleObjC.h>

@class NSArray;
@class NSString;
@class NSDictionary;



@interface NSLocale : NSObject <NSCopying>
{
   NSString   *_identifier;
   void       *_xlocale;
   void       *_iculocale;
   id         _keyValues;
}

- (NSString *) displayNameForKey:(id) key
                           value:(id) value;

@end


@interface NSLocale( Future)

+ (id) systemLocale;
+ (id) currentLocale;

+ (NSArray *) availableLocaleIdentifiers;
+ (NSArray *) ISOLanguageCodes;
+ (NSArray *) ISOCountryCodes;
+ (NSArray *) ISOCurrencyCodes;

+ (NSDictionary *) componentsFromLocaleIdentifier:(NSString *) string;
+ (NSString *) localeIdentifierFromComponents:(NSDictionary *) dict;

+ (NSString *) canonicalLocaleIdentifierFromString:(NSString *) string;
+ (NSString *) canonicalLanguageIdentifierFromString:(NSString *) string;

- (id) initWithLocaleIdentifier:(NSString *) string;
- (NSString *) localeIdentifier;
- (id) objectForKey:(id) key;

@end


extern NSString   *NSLocaleAlternateQuotationBeginDelimiterKey;
extern NSString   *NSLocaleAlternateQuotationEndDelimiterKey;
extern NSString   *NSLocaleCalendar;
extern NSString   *NSLocaleCollationIdentifier;
extern NSString   *NSLocaleCollatorIdentifier;
extern NSString   *NSLocaleCountryCode;
extern NSString   *NSLocaleCurrencyCode;
extern NSString   *NSLocaleCurrencySymbol;
extern NSString   *NSLocaleDecimalSeparator;
extern NSString   *NSLocaleExemplarCharacterSet;
extern NSString   *NSLocaleGroupingSeparator;
extern NSString   *NSLocaleIdentifier;
extern NSString   *NSLocaleLanguageCode;
extern NSString   *NSLocaleMeasurementSystem;
extern NSString   *NSLocaleQuotationBeginDelimiterKey;
extern NSString   *NSLocaleQuotationEndDelimiterKey;
extern NSString   *NSLocaleScriptCode;
extern NSString   *NSLocaleUsesMetricSystem;
extern NSString   *NSLocaleVariantCode;


extern NSString   *NSAMPMDesignation;
extern NSString   *NSDateFormatString;
extern NSString   *NSDateTimeOrdering;
extern NSString   *NSEarlierTimeDesignations;
extern NSString   *NSHourNameDesignations;
extern NSString   *NSLaterTimeDesignations;
extern NSString   *NSMonthNameArray;
extern NSString   *NSNextDayDesignations;
extern NSString   *NSNextNextDayDesignations;
extern NSString   *NSPriorDayDesignations;
extern NSString   *NSShortDateFormatString;
extern NSString   *NSShortMonthNameArray;
extern NSString   *NSShortTimeDateFormatString;
extern NSString   *NSShortWeekDayNameArray;
extern NSString   *NSThisDayDesignations;
extern NSString   *NSTimeDateFormatString;
extern NSString   *NSTimeFormatString;
extern NSString   *NSWeekDayNameArray;
extern NSString   *NSYearMonthWeekDesignations;
