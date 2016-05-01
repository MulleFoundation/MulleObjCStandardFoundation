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


@interface NSLocale : NSObject <NSCopying>
{
   void      *_locale;
   NSString  *_identifier;
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

