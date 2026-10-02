//
//  NSLocale.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
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



// The direction a language runs in. The values are Apple's. This library only
// distinguishes left-to-right from right-to-left (and "unknown"): the vertical
// values exist for completeness but are never answered, because a vertical
// writing direction is a property of a script/layout, not of a language.
// The enum is spelled as NSUInteger to match how this library declares its
// other enums (NSNumberFormatterStyle for instance).
enum
{
   NSLocaleLanguageDirectionUnknown     = 0,
   NSLocaleLanguageDirectionLeftToRight = 1,
   NSLocaleLanguageDirectionRightToLeft = 2,
   NSLocaleLanguageDirectionTopToBottom = 3,
   NSLocaleLanguageDirectionBottomToTop = 4
};
typedef NSUInteger   NSLocaleLanguageDirection;



@interface NSLocale : NSObject < MulleObjCImmutableProtocols >
{
   NSString   *_identifier;
   void       *_xlocale;
   id         _keyValues;
   NSLock     *_lock;         // protects the lazy _keyValues cache
   id         _derivedValues; // immutable, filled in -init, read without _lock
}

+ (instancetype) localeWithLocaleIdentifier:(NSString *) s;
+ (instancetype) autoupdatingCurrentLocale;

// The languages the user prefers, most wanted first. Unlike macOS this does
// not read an "AppleLanguages" user default (this layer cannot reach
// NSUserDefaults); it uses the environment instead and is never empty, so
// calling code can rely on the first element being a usable language code.
+ (NSArray *) preferredLanguages;

// RightToLeft for the languages written right to left, LeftToRight for the
// others, Unknown for nil and for a string that is not an ISO language code we
// know. Both answer the same, see the implementation for why.
+ (NSLocaleLanguageDirection) characterDirectionForLanguage:(NSString *) language;
+ (NSLocaleLanguageDirection) lineDirectionForLanguage:(NSString *) language;

// Names the languageCode, countryCode, scriptCode or variantCode "value" in
// the receiver's language. We only have English names, so a receiver that is
// not English answers the English name as well; a code with no name, and every
// key without a name table (the identifier, a currency code, the calendar, the
// collation/collator identifiers), comes back as "value" unchanged.
- (NSString *) displayNameForKey:(id) key
                           value:(id) value;


// these are currently hard cached on +intitialize
+ (instancetype) systemLocale;
+ (instancetype) currentLocale;

- (NSString *) localeIdentifier;
- (NSString *) languageCode;
- (NSString *) countryCode;
- (NSString *) scriptCode;
- (NSString *) variantCode;
- (NSString *) collationIdentifier;
- (NSString *) collatorIdentifier;
- (NSString *) currencyCode;
- (NSString *) calendarIdentifier;
- (NSString *) measurementSystem;
- (BOOL) usesMetricSystem;


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


@interface NSLocale( Future) < MulleObjCFuture>

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
- (id) objectForKey:(id) key   MULLE_OBJC_THREADSAFE_METHOD;

// Compares the *canonical* identifiers, so "en_US", "en-US" and
// "en_US.UTF-8" are equal (and hash equally). -localeIdentifier still answers
// what the receiver was created with, so it is not canonical itself.
- (BOOL) isEqualToLocale:(NSLocale *) other;

// The platform specific part of a locale, answered by the platform category
// (NSLocale( Posix), NSLocale( Windows) ...). NSLocale itself answers nil, so
// a platform that has no backend still serves the platform agnostic keys.
- (id) _localeInfoForKey:(id) key;

// Key values that follow from -localeIdentifier alone. They are the same on
// every platform, so they are answered here and not by a platform category.
// This reparses the identifier, so it is only a fallback: -init calls
// -_setupDerivedLocaleValues: which asks for all of them at once.
- (id) _derivedLocaleInfoForKey:(id) key;

// Parses -localeIdentifier once and stores every key that
// -_derivedLocaleInfoForKey: can answer in the immutable _derivedValues
// dictionary, so -objectForKey: can serve them without taking _lock and
// without reparsing. A key that has no value for this locale is stored as
// NSNull, which is also its answer. auxiliaryInfo (the locale's data file,
// nil when there is none - see +auxiliaryLocaleInfoForIdentifier:) is merged
// on top and therefore keeps winning over the derived value.
- (void) _setupDerivedLocaleValues:(NSDictionary *) auxiliaryInfo;

// Splits "language[_script][_country][.codeset][@modifier]" into components.
// "-" works as separator as well (BCP-47). A four letter *alphabetic*
// component after the language is a script ("Hans"); a four digit component
// ("1901") or an all-uppercase token ("POSIX", "VALENCIA") is a variant. A
// BCP-47 extension sequence ("-u-...", "-x-...") is not a locale component
// and stops the parse. Components the identifier does not have come back nil.
+ (void) _parseLocaleIdentifier:(NSString *) identifier
                       language:(NSString **) language
                         script:(NSString **) script
                        country:(NSString **) country
                        variant:(NSString **) variant
                       modifier:(NSString **) modifier;

- (instancetype) initWithLocaleIdentifier:(NSString *) s;

@end


// Two of the keys below are deliberately never answered by this library, they
// come back nil:
//
//   NSLocaleCalendar             expects an NSCalendar *object*. NSCalendar
//                                lives in MulleObjCCalendarFoundation, which is
//                                built on top of this library, so answering it
//                                here would invert the dependency. That layer
//                                is the place for it. -calendarIdentifier
//                                (the string) *is* answered here, it follows
//                                from the identifier alone.
//   NSLocaleExemplarCharacterSet expects the CLDR exemplar character set of
//                                the locale. That is thousands of code points
//                                per locale and we deliberately have no ICU
//                                dependency, so it stays nil.
//
// The four quotation delimiter keys are answered below, from a small
// hand-rolled table of the CLDR values.
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
