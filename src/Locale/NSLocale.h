/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSLocale.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
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
