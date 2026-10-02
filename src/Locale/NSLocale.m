//
//  NSLocale.m
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
#import "NSLocale.h"

// other files in this library

// other libraries of MulleObjCPosixFoundation
#import "MulleObjCStandardValueFoundation.h"

// std-c and dependencies
#import "import-private.h"

#include <string.h>
#include <stdlib.h>


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


// https://developer.apple.com/documentation/foundation/nsdecimalseparator
NSString   *NSDecimalSeparator = @".";
NSString   *NSCurrencySymbol = @"$";
NSString   *NSThousandsSeparator = @",";
NSString   *NSDecimalDigits = @"0123456789"; // ?? check with macos
NSString   *NSInternationalCurrencyString = @"USD";
NSString   *NSNegativeCurrencyFormatString = @"-$9,999.00";
NSString   *NSPositiveCurrencyFormatString = @"$9,999.00";

// most of the code is OS Specific, so not much here

@implementation NSObject( _NSLocale)

- (BOOL) __isNSLocale
{
   return( NO);
}

@end


// the very few countries that still use US customary units
static BOOL   mulle_locale_country_uses_metric_system( NSString *country)
{
   if( [country isEqualToString:@"US"])
      return( NO);
   if( [country isEqualToString:@"LR"])
      return( NO);
   if( [country isEqualToString:@"MM"])
      return( NO);
   return( YES);
}


// The ISO code lists are filled from the locales the platform reports, so they
// only ever contain codes this host can actually serve. These shape filters
// (2-3 letter language, 2 letter country, 3 letter currency) drop the "C" and
// "POSIX" pseudo locales and anything that is not ISO shaped.
static BOOL   mulle_is_iso_code( NSString *s, NSUInteger min, NSUInteger max, BOOL uppercase)
{
   unichar    c;
   NSUInteger i;
   NSUInteger n;

   if( ! [s isKindOfClass:[NSString class]])
      return( NO);

   n = [s length];
   if( n < min || n > max)
      return( NO);

   for( i = 0; i < n; i++)
   {
      c = [s characterAtIndex:i];
      if( uppercase)
      {
         if( c < 'A' || c > 'Z')
            return( NO);
      }
      else
      {
         if( c < 'a' || c > 'z')
            return( NO);
      }
   }
   return( YES);
}


// Returns the value of "key=value" in a POSIX "@modifier" tail. The modifier
// is a semicolon separated keyword list (ICU style, "@collation=phonebook").
// A bare modifier ("@euro") has no keys and yields nil.
static NSString   *mulle_locale_keyword_value( NSString *modifier, NSString *keyword)
{
   NSArray      *keywords;
   NSString     *s;
   NSRange      range;
   NSUInteger   i;
   NSUInteger   n;

   if( ! modifier)
      return( nil);

   keywords = [modifier componentsSeparatedByString:@";"];
   n        = [keywords count];
   for( i = 0; i < n; i++)
   {
      s     = [keywords objectAtIndex:i];
      range = [s rangeOfString:@"="];
      if( range.length == 0)
         continue;
      if( ! [[s substringToIndex:range.location] isEqualToString:keyword])
         continue;
      return( [s substringFromIndex:NSMaxRange( range)]);
   }
   return( nil);
}


// A locale identifier is made of components chosen from three shapes. A script
// is four alphabetic characters ("Hans", "Latn"). A country is two letters or
// three digits (UN M.49, "US"/"419"). A variant is four digits ("1901") or an
// all-uppercase token ("POSIX", "VALENCIA"). A lone lowercase letter does not
// shape-match anything: it opens a BCP-47 extension sequence ("u", "t", "x")
// and everything after it is not a locale component.
static BOOL   mulle_locale_is_script_component( NSString *component)
{
   unichar    c;
   NSUInteger i;

   if( [component length] != 4)
      return( NO);

   for( i = 0; i < 4; i++)
   {
      c = [component characterAtIndex:i];
      if( (c < 'A' || c > 'Z') && (c < 'a' || c > 'z'))
         return( NO);
   }
   return( YES);
}


static BOOL   mulle_locale_is_variant_component( NSString *component)
{
   unichar    c;
   NSUInteger i;
   NSUInteger n;

   n = [component length];
   // two and three letter components can still be a country
   if( n < 4)
      return( NO);
   // four alphabetic letters are a script, not a variant
   if( mulle_locale_is_script_component( component))
      return( NO);
   // a variant is uppercase or numeric; a lowercase token ("euro") is an
   // "@modifier" and is handled separately
   for( i = 0; i < n; i++)
   {
      c = [component characterAtIndex:i];
      if( c >= 'a' && c <= 'z')
         return( NO);
   }
   return( YES);
}


static BOOL   mulle_locale_is_country_component( NSString *component)
{
   unichar    c;
   NSUInteger i;
   NSUInteger n;

   n = [component length];
   if( n == 2)
   {
      for( i = 0; i < n; i++)
      {
         c = [component characterAtIndex:i];
         if( (c < 'A' || c > 'Z') && (c < 'a' || c > 'z'))
            return( NO);
      }
      return( YES);
   }

   if( n == 3)
   {
      for( i = 0; i < n; i++)
      {
         c = [component characterAtIndex:i];
         if( c < '0' || c > '9')
            return( NO);
      }
      return( YES);
   }

   return( NO);
}


// A variant that was written as a base component ("en_US_POSIX") goes back to
// "_", the "@modifier" spelling ("de_DE@euro") stays "@". A modifier is
// lowercase or a "key=value" list, a base variant is uppercase or numeric.
static BOOL   mulle_locale_variant_is_modifier( NSString *variant)
{
   unichar    c;
   NSUInteger i;
   NSUInteger n;

   n = [variant length];
   for( i = 0; i < n; i++)
   {
      c = [variant characterAtIndex:i];
      if( (c >= 'a' && c <= 'z') || c == '=')
         return( YES);
   }
   return( NO);
}


// The quotation marks of a language, as U+ code points. Hand-rolled from the
// CLDR data (dumped with ICU at development time; ICU itself is deliberately
// not a dependency, see LOCALE_README.md): a language that is not listed uses
// the English ones, and there are many of them - es, pt, da, tr, hi, th, ko,
// zh, vi, ... all use the English quotes. Only the languages that differ are
// in the table. Every delimiter is a single code point, so the source stays
// pure ASCII and no encoding can be got wrong.
enum
{
   MULLE_LOCALE_QUOTATION_BEGIN           = 0,
   MULLE_LOCALE_QUOTATION_END             = 1,
   MULLE_LOCALE_QUOTATION_ALTERNATE_BEGIN = 2,
   MULLE_LOCALE_QUOTATION_ALTERNATE_END   = 3
};


static struct
{
   char      *language;
   unichar   characters[ 4];
}
   mulle_locale_quotations[] =
{
   { "de", { 0x201E, 0x201C, 0x201A, 0x2018 }},
   { "is", { 0x201E, 0x201C, 0x201A, 0x2018 }},
   { "cs", { 0x201E, 0x201C, 0x201A, 0x2018 }},
   { "sk", { 0x201E, 0x201C, 0x201A, 0x2018 }},
   { "hr", { 0x201E, 0x201C, 0x201A, 0x2018 }},
   { "sl", { 0x201E, 0x201C, 0x201A, 0x2018 }},
   { "mk", { 0x201E, 0x201C, 0x201A, 0x2018 }},
   { "et", { 0x201E, 0x201C, 0x201A, 0x2018 }},
   { "lt", { 0x201E, 0x201C, 0x201E, 0x201C }},
   { "bg", { 0x201E, 0x201C, 0x201E, 0x201C }},
   { "ka", { 0x201E, 0x201C, 0x00AB, 0x00BB }},
   { "fr", { 0x00AB, 0x00BB, 0x00AB, 0x00BB }},
   { "hy", { 0x00AB, 0x00BB, 0x00AB, 0x00BB }},
   { "it", { 0x00AB, 0x00BB, 0x201C, 0x201D }},
   { "el", { 0x00AB, 0x00BB, 0x201C, 0x201D }},
   { "ca", { 0x00AB, 0x00BB, 0x201C, 0x201D }},
   { "eu", { 0x00AB, 0x00BB, 0x201C, 0x201D }},
   { "br", { 0x00AB, 0x00BB, 0x201C, 0x201D }},
   { "kk", { 0x00AB, 0x00BB, 0x201C, 0x201D }},
   { "no", { 0x00AB, 0x00BB, 0x2018, 0x2019 }},
   { "nb", { 0x00AB, 0x00BB, 0x2018, 0x2019 }},
   { "nn", { 0x00AB, 0x00BB, 0x2018, 0x2019 }},
   { "fi", { 0x201D, 0x201D, 0x2019, 0x2019 }},
   { "sv", { 0x201D, 0x201D, 0x2019, 0x2019 }},
   { "he", { 0x201D, 0x201D, 0x2019, 0x2019 }},
   { "ar", { 0x201D, 0x201C, 0x2019, 0x2018 }},
   { "nl", { 0x2018, 0x2019, 0x2018, 0x2019 }},
   { "pl", { 0x201E, 0x201D, 0x00AB, 0x00BB }},
   { "hu", { 0x201E, 0x201D, 0x00BB, 0x00AB }},
   { "ro", { 0x201E, 0x201D, 0x00AB, 0x00BB }},
   { "sr", { 0x201E, 0x201D, 0x2019, 0x2019 }},
   { "bs", { 0x201E, 0x201D, 0x2018, 0x2019 }},
   { "ru", { 0x00AB, 0x00BB, 0x201E, 0x201C }},
   { "uk", { 0x00AB, 0x00BB, 0x201E, 0x201C }},
   { "be", { 0x00AB, 0x00BB, 0x201E, 0x201C }},
   { "fa", { 0x00AB, 0x00BB, 0x2039, 0x203A }},
   { "am", { 0x00AB, 0x00BB, 0x2039, 0x203A }},
   { "ja", { 0x300C, 0x300D, 0x300E, 0x300F }},
   { "uz", { 0x201C, 0x201D, 0x2019, 0x2018 }}
};


// "\u201C", "\u201D", "\u2018", "\u2019" - the English/neutral ones
static unichar   mulle_locale_quotation_character( NSString *language, int which)
{
   static unichar   defaults[ 4] = { 0x201C, 0x201D, 0x2018, 0x2019 };
   char             *s;
   NSUInteger       i;
   NSUInteger       n;

   if( language)
   {
      s = [language UTF8String];
      if( s)
      {
         n = sizeof( mulle_locale_quotations) / sizeof( mulle_locale_quotations[ 0]);
         for( i = 0; i < n; i++)
            if( ! strcmp( s, mulle_locale_quotations[ i].language))
               return( mulle_locale_quotations[ i].characters[ which]);
      }
   }
   return( defaults[ which]);
}


static NSString   *mulle_locale_quotation_delimiter( NSString *language, int which)
{
   unichar   c;

   c = mulle_locale_quotation_character( [language lowercaseString], which);
   return( [NSString stringWithCharacters:&c
                                   length:1]);
}


// CLDR's *default* calendar for a locale. It is gregorian everywhere but in
// Iran and Afghanistan (persian) and Thailand (buddhist); for Thai, Persian
// and Pashto the language alone decides it. Also hand-rolled from the CLDR
// data, no ICU. Apple answers "gregorian" for ar_SA as well - the islamic
// calendar has to be asked for explicitly there too.
static NSString   *mulle_locale_calendar_identifier( NSString *language, NSString *country)
{
   if( country)
   {
      country = [country uppercaseString];
      if( [country isEqualToString:@"TH"])
         return( @"buddhist");
      if( [country isEqualToString:@"IR"] || [country isEqualToString:@"AF"])
         return( @"persian");
   }

   if( language)
   {
      language = [language lowercaseString];
      if( [language isEqualToString:@"th"])
         return( @"buddhist");
      if( [language isEqualToString:@"fa"] || [language isEqualToString:@"ps"])
         return( @"persian");
   }
   return( @"gregorian");
}


// The value of a key that follows from the identifier alone, given the
// components of that identifier. Factored out of -_derivedLocaleInfoForKey:
// so the components can be parsed once and then be asked for all these keys
// (see -_setupDerivedLocaleValues:) instead of once per key.
static id   mulle_locale_derived_value_for_key( id key,
                                                NSString *identifier,
                                                NSString *language,
                                                NSString *script,
                                                NSString *country,
                                                NSString *variant,
                                                NSString *modifier)
{
   // The identifier itself needs no OS: it is what the receiver was created
   // with. A backend that answers it (Posix IDENTIFIER_INFO) is consulted
   // first, this is the fallback that gives Windows the same answer.
   if( [key isEqualToString:NSLocaleIdentifier])
      return( identifier);

   // Windows has no source for this and used to answer nil. The language is
   // simply the first component of the identifier.
   if( [key isEqualToString:NSLocaleLanguageCode])
      return( language);

   if( [key isEqualToString:NSLocaleCountryCode])
      return( country);

   if( [key isEqualToString:NSLocaleScriptCode])
      return( script);

   // A base variant ("en_US_POSIX", "de_DE_1901") is more specific than the
   // "@modifier" ("de_DE@euro"); either one is the variant.
   if( [key isEqualToString:NSLocaleVariantCode])
      return( variant ? variant : modifier);

   // Apple's NSLocaleCollationIdentifier is the value of the "@collation=..."
   // keyword, not an OS collation: a plain locale, or one whose modifier is a
   // POSIX "@euro", has none. Deriving it here makes every backend agree.
   if( [key isEqualToString:NSLocaleCollationIdentifier])
      return( mulle_locale_keyword_value( modifier, @"collation"));

   if( [key isEqualToString:NSLocaleCollatorIdentifier])
   {
      if( ! language)
         return( country);
      if( ! country)
         return( language);
      return( [language stringByAppendingString:[@"_" stringByAppendingString:country]]);
   }

   if( [key isEqualToString:NSLocaleMeasurementSystem])
      return( mulle_locale_country_uses_metric_system( country) ? @"Metric" : @"U.S.");

   if( [key isEqualToString:NSLocaleUsesMetricSystem])
      return( [NSNumber numberWithBool:mulle_locale_country_uses_metric_system( country)]);

   // The quotation marks are a property of the language, not of the country
   // ("de_CH" quotes the german way, "fr_CA" the french way).
   if( [key isEqualToString:NSLocaleQuotationBeginDelimiterKey])
      return( mulle_locale_quotation_delimiter( language, MULLE_LOCALE_QUOTATION_BEGIN));

   if( [key isEqualToString:NSLocaleQuotationEndDelimiterKey])
      return( mulle_locale_quotation_delimiter( language, MULLE_LOCALE_QUOTATION_END));

   if( [key isEqualToString:NSLocaleAlternateQuotationBeginDelimiterKey])
      return( mulle_locale_quotation_delimiter( language, MULLE_LOCALE_QUOTATION_ALTERNATE_BEGIN));

   if( [key isEqualToString:NSLocaleAlternateQuotationEndDelimiterKey])
      return( mulle_locale_quotation_delimiter( language, MULLE_LOCALE_QUOTATION_ALTERNATE_END));

   return( nil);
}


// ----------------------------------------------------------------------------
// Display names
//
// Apple returns the name of a language, country, script or variant *in the
// language of the receiver*. We only have English names, so every receiver
// answers the English name - which is still a name, and much better than the
// bare code. The tables are sorted by code and hold the CLDR English names
// (dumped with ICU at development time, ICU is not a dependency of the
// product).
//
// A code that is not in a table makes -displayNameForKey:value: hand the value
// back unchanged. That is deliberate and load bearing: NSBundle builds a
// "<name>.lproj" directory out of localizedStringForLanguageCode:, so an
// unknown language has to come back as the code, never as nil.
struct mulle_locale_display_name
{
   char   *code;
   char   *name;
};


#define MULLE_LOCALE_DISPLAY_NAME_COUNT( table)   (sizeof( table) / sizeof( (table)[ 0]))


static struct mulle_locale_display_name   mulle_locale_language_names[] =
{
   { "aa", "Afar" },
   { "ab", "Abkhazian" },
   { "ae", "Avestan" },
   { "af", "Afrikaans" },
   { "ak", "Akan" },
   { "am", "Amharic" },
   { "an", "Aragonese" },
   { "ar", "Arabic" },
   { "as", "Assamese" },
   { "av", "Avaric" },
   { "ay", "Aymara" },
   { "az", "Azerbaijani" },
   { "ba", "Bashkir" },
   { "be", "Belarusian" },
   { "bg", "Bulgarian" },
   { "bi", "Bislama" },
   { "bm", "Bambara" },
   { "bn", "Bangla" },
   { "bo", "Tibetan" },
   { "br", "Breton" },
   { "bs", "Bosnian" },
   { "ca", "Catalan" },
   { "ce", "Chechen" },
   { "ch", "Chamorro" },
   { "co", "Corsican" },
   { "cr", "Cree" },
   { "cs", "Czech" },
   { "cu", "Church Slavic" },
   { "cv", "Chuvash" },
   { "cy", "Welsh" },
   { "da", "Danish" },
   { "de", "German" },
   { "dv", "Divehi" },
   { "dz", "Dzongkha" },
   { "ee", "Ewe" },
   { "el", "Greek" },
   { "en", "English" },
   { "eo", "Esperanto" },
   { "es", "Spanish" },
   { "et", "Estonian" },
   { "eu", "Basque" },
   { "fa", "Persian" },
   { "ff", "Fula" },
   { "fi", "Finnish" },
   { "fj", "Fijian" },
   { "fo", "Faroese" },
   { "fr", "French" },
   { "fy", "Western Frisian" },
   { "ga", "Irish" },
   { "gd", "Scottish Gaelic" },
   { "gl", "Galician" },
   { "gn", "Guarani" },
   { "gu", "Gujarati" },
   { "gv", "Manx" },
   { "ha", "Hausa" },
   { "he", "Hebrew" },
   { "hi", "Hindi" },
   { "ho", "Hiri Motu" },
   { "hr", "Croatian" },
   { "ht", "Haitian Creole" },
   { "hu", "Hungarian" },
   { "hy", "Armenian" },
   { "hz", "Herero" },
   { "ia", "Interlingua" },
   { "id", "Indonesian" },
   { "ie", "Interlingue" },
   { "ig", "Igbo" },
   { "ii", "Sichuan Yi" },
   { "ik", "Inupiaq" },
   { "io", "Ido" },
   { "is", "Icelandic" },
   { "it", "Italian" },
   { "iu", "Inuktitut" },
   { "ja", "Japanese" },
   { "jv", "Javanese" },
   { "ka", "Georgian" },
   { "kg", "Kongo" },
   { "ki", "Kikuyu" },
   { "kj", "Kuanyama" },
   { "kk", "Kazakh" },
   { "kl", "Kalaallisut" },
   { "km", "Khmer" },
   { "kn", "Kannada" },
   { "ko", "Korean" },
   { "kr", "Kanuri" },
   { "ks", "Kashmiri" },
   { "ku", "Kurdish" },
   { "kv", "Komi" },
   { "kw", "Cornish" },
   { "ky", "Kyrgyz" },
   { "la", "Latin" },
   { "lb", "Luxembourgish" },
   { "lg", "Ganda" },
   { "li", "Limburgish" },
   { "ln", "Lingala" },
   { "lo", "Lao" },
   { "lt", "Lithuanian" },
   { "lu", "Luba-Katanga" },
   { "lv", "Latvian" },
   { "mg", "Malagasy" },
   { "mh", "Marshallese" },
   { "mi", "M\u0101ori" },
   { "mk", "Macedonian" },
   { "ml", "Malayalam" },
   { "mn", "Mongolian" },
   { "mr", "Marathi" },
   { "ms", "Malay" },
   { "mt", "Maltese" },
   { "my", "Burmese" },
   { "na", "Nauru" },
   { "nb", "Norwegian Bokm\u00E5l" },
   { "nd", "North Ndebele" },
   { "ne", "Nepali" },
   { "ng", "Ndonga" },
   { "nl", "Dutch" },
   { "nn", "Norwegian Nynorsk" },
   { "no", "Norwegian" },
   { "nr", "South Ndebele" },
   { "nv", "Navajo" },
   { "ny", "Nyanja" },
   { "oc", "Occitan" },
   { "oj", "Ojibwa" },
   { "om", "Oromo" },
   { "or", "Odia" },
   { "os", "Ossetic" },
   { "pa", "Punjabi" },
   { "pi", "Pali" },
   { "pl", "Polish" },
   { "ps", "Pashto" },
   { "pt", "Portuguese" },
   { "qu", "Quechua" },
   { "rm", "Romansh" },
   { "rn", "Rundi" },
   { "ro", "Romanian" },
   { "ru", "Russian" },
   { "rw", "Kinyarwanda" },
   { "sa", "Sanskrit" },
   { "sc", "Sardinian" },
   { "sd", "Sindhi" },
   { "se", "Northern Sami" },
   { "sg", "Sango" },
   { "si", "Sinhala" },
   { "sk", "Slovak" },
   { "sl", "Slovenian" },
   { "sm", "Samoan" },
   { "sn", "Shona" },
   { "so", "Somali" },
   { "sq", "Albanian" },
   { "sr", "Serbian" },
   { "ss", "Swati" },
   { "st", "Southern Sotho" },
   { "su", "Sundanese" },
   { "sv", "Swedish" },
   { "sw", "Swahili" },
   { "ta", "Tamil" },
   { "te", "Telugu" },
   { "tg", "Tajik" },
   { "th", "Thai" },
   { "ti", "Tigrinya" },
   { "tk", "Turkmen" },
   { "tn", "Tswana" },
   { "to", "Tongan" },
   { "tr", "Turkish" },
   { "ts", "Tsonga" },
   { "tt", "Tatar" },
   { "tw", "Twi" },
   { "ty", "Tahitian" },
   { "ug", "Uyghur" },
   { "uk", "Ukrainian" },
   { "ur", "Urdu" },
   { "uz", "Uzbek" },
   { "ve", "Venda" },
   { "vi", "Vietnamese" },
   { "vo", "Volap\u00FCk" },
   { "wa", "Walloon" },
   { "wo", "Wolof" },
   { "xh", "Xhosa" },
   { "yi", "Yiddish" },
   { "yo", "Yoruba" },
   { "za", "Zhuang" },
   { "zh", "Chinese" },
   { "zu", "Zulu" }
};


static struct mulle_locale_display_name   mulle_locale_country_names[] =
{
   { "AD", "Andorra" },
   { "AE", "United Arab Emirates" },
   { "AF", "Afghanistan" },
   { "AG", "Antigua & Barbuda" },
   { "AI", "Anguilla" },
   { "AL", "Albania" },
   { "AM", "Armenia" },
   { "AO", "Angola" },
   { "AR", "Argentina" },
   { "AS", "American Samoa" },
   { "AT", "Austria" },
   { "AU", "Australia" },
   { "AW", "Aruba" },
   { "AX", "\u00C5land Islands" },
   { "AZ", "Azerbaijan" },
   { "BA", "Bosnia & Herzegovina" },
   { "BB", "Barbados" },
   { "BD", "Bangladesh" },
   { "BE", "Belgium" },
   { "BF", "Burkina Faso" },
   { "BG", "Bulgaria" },
   { "BH", "Bahrain" },
   { "BI", "Burundi" },
   { "BJ", "Benin" },
   { "BL", "St. Barth\u00E9lemy" },
   { "BM", "Bermuda" },
   { "BN", "Brunei" },
   { "BO", "Bolivia" },
   { "BQ", "Caribbean Netherlands" },
   { "BR", "Brazil" },
   { "BS", "Bahamas" },
   { "BT", "Bhutan" },
   { "BW", "Botswana" },
   { "BY", "Belarus" },
   { "BZ", "Belize" },
   { "CA", "Canada" },
   { "CC", "Cocos (Keeling) Islands" },
   { "CD", "Congo - Kinshasa" },
   { "CF", "Central African Republic" },
   { "CG", "Congo - Brazzaville" },
   { "CH", "Switzerland" },
   { "CI", "C\u00F4te d\u2019Ivoire" },
   { "CK", "Cook Islands" },
   { "CL", "Chile" },
   { "CM", "Cameroon" },
   { "CN", "China" },
   { "CO", "Colombia" },
   { "CR", "Costa Rica" },
   { "CU", "Cuba" },
   { "CV", "Cape Verde" },
   { "CW", "Cura\u00E7ao" },
   { "CX", "Christmas Island" },
   { "CY", "Cyprus" },
   { "CZ", "Czechia" },
   { "DE", "Germany" },
   { "DG", "Diego Garcia" },
   { "DJ", "Djibouti" },
   { "DK", "Denmark" },
   { "DM", "Dominica" },
   { "DO", "Dominican Republic" },
   { "DZ", "Algeria" },
   { "EA", "Ceuta & Melilla" },
   { "EC", "Ecuador" },
   { "EE", "Estonia" },
   { "EG", "Egypt" },
   { "EH", "Western Sahara" },
   { "ER", "Eritrea" },
   { "ES", "Spain" },
   { "ET", "Ethiopia" },
   { "FI", "Finland" },
   { "FJ", "Fiji" },
   { "FK", "Falkland Islands" },
   { "FM", "Micronesia" },
   { "FO", "Faroe Islands" },
   { "FR", "France" },
   { "GA", "Gabon" },
   { "GB", "United Kingdom" },
   { "GD", "Grenada" },
   { "GE", "Georgia" },
   { "GF", "French Guiana" },
   { "GG", "Guernsey" },
   { "GH", "Ghana" },
   { "GI", "Gibraltar" },
   { "GL", "Greenland" },
   { "GM", "Gambia" },
   { "GN", "Guinea" },
   { "GP", "Guadeloupe" },
   { "GQ", "Equatorial Guinea" },
   { "GR", "Greece" },
   { "GS", "South Georgia & South Sandwich Islands" },
   { "GT", "Guatemala" },
   { "GU", "Guam" },
   { "GW", "Guinea-Bissau" },
   { "GY", "Guyana" },
   { "HK", "Hong Kong SAR China" },
   { "HN", "Honduras" },
   { "HR", "Croatia" },
   { "HT", "Haiti" },
   { "HU", "Hungary" },
   { "IC", "Canary Islands" },
   { "ID", "Indonesia" },
   { "IE", "Ireland" },
   { "IL", "Israel" },
   { "IM", "Isle of Man" },
   { "IN", "India" },
   { "IO", "British Indian Ocean Territory" },
   { "IQ", "Iraq" },
   { "IR", "Iran" },
   { "IS", "Iceland" },
   { "IT", "Italy" },
   { "JE", "Jersey" },
   { "JM", "Jamaica" },
   { "JO", "Jordan" },
   { "JP", "Japan" },
   { "KE", "Kenya" },
   { "KG", "Kyrgyzstan" },
   { "KH", "Cambodia" },
   { "KI", "Kiribati" },
   { "KM", "Comoros" },
   { "KN", "St. Kitts & Nevis" },
   { "KP", "North Korea" },
   { "KR", "South Korea" },
   { "KW", "Kuwait" },
   { "KY", "Cayman Islands" },
   { "KZ", "Kazakhstan" },
   { "LA", "Laos" },
   { "LB", "Lebanon" },
   { "LC", "St. Lucia" },
   { "LI", "Liechtenstein" },
   { "LK", "Sri Lanka" },
   { "LR", "Liberia" },
   { "LS", "Lesotho" },
   { "LT", "Lithuania" },
   { "LU", "Luxembourg" },
   { "LV", "Latvia" },
   { "LY", "Libya" },
   { "MA", "Morocco" },
   { "MC", "Monaco" },
   { "MD", "Moldova" },
   { "ME", "Montenegro" },
   { "MF", "St. Martin" },
   { "MG", "Madagascar" },
   { "MH", "Marshall Islands" },
   { "MK", "North Macedonia" },
   { "ML", "Mali" },
   { "MM", "Myanmar (Burma)" },
   { "MN", "Mongolia" },
   { "MO", "Macao SAR China" },
   { "MP", "Northern Mariana Islands" },
   { "MQ", "Martinique" },
   { "MR", "Mauritania" },
   { "MS", "Montserrat" },
   { "MT", "Malta" },
   { "MU", "Mauritius" },
   { "MV", "Maldives" },
   { "MW", "Malawi" },
   { "MX", "Mexico" },
   { "MY", "Malaysia" },
   { "MZ", "Mozambique" },
   { "NA", "Namibia" },
   { "NC", "New Caledonia" },
   { "NE", "Niger" },
   { "NF", "Norfolk Island" },
   { "NG", "Nigeria" },
   { "NI", "Nicaragua" },
   { "NL", "Netherlands" },
   { "NO", "Norway" },
   { "NP", "Nepal" },
   { "NR", "Nauru" },
   { "NU", "Niue" },
   { "NZ", "New Zealand" },
   { "OM", "Oman" },
   { "PA", "Panama" },
   { "PE", "Peru" },
   { "PF", "French Polynesia" },
   { "PG", "Papua New Guinea" },
   { "PH", "Philippines" },
   { "PK", "Pakistan" },
   { "PL", "Poland" },
   { "PM", "St. Pierre & Miquelon" },
   { "PN", "Pitcairn Islands" },
   { "PR", "Puerto Rico" },
   { "PS", "Palestinian Territories" },
   { "PT", "Portugal" },
   { "PW", "Palau" },
   { "PY", "Paraguay" },
   { "QA", "Qatar" },
   { "RE", "R\u00E9union" },
   { "RO", "Romania" },
   { "RS", "Serbia" },
   { "RU", "Russia" },
   { "RW", "Rwanda" },
   { "SA", "Saudi Arabia" },
   { "SB", "Solomon Islands" },
   { "SC", "Seychelles" },
   { "SD", "Sudan" },
   { "SE", "Sweden" },
   { "SG", "Singapore" },
   { "SH", "St. Helena" },
   { "SI", "Slovenia" },
   { "SJ", "Svalbard & Jan Mayen" },
   { "SK", "Slovakia" },
   { "SL", "Sierra Leone" },
   { "SM", "San Marino" },
   { "SN", "Senegal" },
   { "SO", "Somalia" },
   { "SR", "Suriname" },
   { "SS", "South Sudan" },
   { "ST", "S\u00E3o Tom\u00E9 & Pr\u00EDncipe" },
   { "SV", "El Salvador" },
   { "SX", "Sint Maarten" },
   { "SY", "Syria" },
   { "SZ", "Eswatini" },
   { "TC", "Turks & Caicos Islands" },
   { "TD", "Chad" },
   { "TG", "Togo" },
   { "TH", "Thailand" },
   { "TJ", "Tajikistan" },
   { "TK", "Tokelau" },
   { "TL", "Timor-Leste" },
   { "TM", "Turkmenistan" },
   { "TN", "Tunisia" },
   { "TO", "Tonga" },
   { "TR", "T\u00FCrkiye" },
   { "TT", "Trinidad & Tobago" },
   { "TV", "Tuvalu" },
   { "TW", "Taiwan" },
   { "TZ", "Tanzania" },
   { "UA", "Ukraine" },
   { "UG", "Uganda" },
   { "UM", "U.S. Outlying Islands" },
   { "US", "United States" },
   { "UY", "Uruguay" },
   { "UZ", "Uzbekistan" },
   { "VA", "Vatican City" },
   { "VC", "St. Vincent & Grenadines" },
   { "VE", "Venezuela" },
   { "VG", "British Virgin Islands" },
   { "VI", "U.S. Virgin Islands" },
   { "VN", "Vietnam" },
   { "VU", "Vanuatu" },
   { "WF", "Wallis & Futuna" },
   { "WS", "Samoa" },
   { "XK", "Kosovo" },
   { "YE", "Yemen" },
   { "YT", "Mayotte" },
   { "ZA", "South Africa" },
   { "ZM", "Zambia" },
   { "ZW", "Zimbabwe" }
};


static struct mulle_locale_display_name   mulle_locale_script_names[] =
{
   { "Adlm", "Adlam" },
   { "Arab", "Arabic" },
   { "Armn", "Armenian" },
   { "Beng", "Bangla" },
   { "Bopo", "Bopomofo" },
   { "Brai", "Braille" },
   { "Cans", "Unified Canadian Aboriginal Syllabics" },
   { "Cher", "Cherokee" },
   { "Cyrl", "Cyrillic" },
   { "Deva", "Devanagari" },
   { "Ethi", "Ethiopic" },
   { "Geor", "Georgian" },
   { "Grek", "Greek" },
   { "Gujr", "Gujarati" },
   { "Guru", "Gurmukhi" },
   { "Hang", "Hangul" },
   { "Hani", "Han" },
   { "Hano", "Hanunoo" },
   { "Hans", "Simplified Han" },
   { "Hant", "Traditional Han" },
   { "Hebr", "Hebrew" },
   { "Hira", "Hiragana" },
   { "Jpan", "Japanese" },
   { "Kana", "Katakana" },
   { "Khmr", "Khmer" },
   { "Knda", "Kannada" },
   { "Kore", "Korean" },
   { "Laoo", "Lao" },
   { "Latn", "Latin" },
   { "Mlym", "Malayalam" },
   { "Mong", "Mongolian" },
   { "Mymr", "Myanmar" },
   { "Orya", "Odia" },
   { "Sinh", "Sinhala" },
   { "Taml", "Tamil" },
   { "Telu", "Telugu" },
   { "Thaa", "Thaana" },
   { "Thai", "Thai" },
   { "Tibt", "Tibetan" },
   { "Vaii", "Vai" },
   { "Yiii", "Yi" }
};


static struct mulle_locale_display_name   mulle_locale_variant_names[] =
{
   { "1901", "Traditional German orthography" },
   { "1996", "German orthography of 1996" },
   { "ALALC97", "ALA-LC Romanization, 1997 edition" },
   { "AREVELA", "Eastern Armenian" },
   { "AREVMDA", "Western Armenian" },
   { "NEDIS", "Natisone dialect" },
   { "OXENDICT", "Oxford English Dictionary spelling" },
   { "POSIX", "Computer" },
   { "REVISED", "Revised Orthography" },
   { "SCOTLAND", "Scottish Standard English" },
   { "VALENCIA", "Valencian" }
};


// Binary search. The tables are sorted by code and every code is plain ASCII,
// so the comparison can happen on the UTF-8 bytes. The name is put through
// stringWithUTF8String: - if the compiler had a non UTF-8 execution character
// set the \uXXXX escapes would not decode and the (nil) answer degrades to
// "hand back the code", which is what happens for an unknown code anyway.
static NSString   *mulle_locale_display_name( struct mulle_locale_display_name *table,
                                              NSUInteger count,
                                              NSString *code)
{
   char         *s;
   NSUInteger   lo;
   NSUInteger   hi;
   NSUInteger   mid;
   int          r;

   if( ! [code length])
      return( nil);

   s = [code UTF8String];
   if( ! s)
      return( nil);

   lo = 0;
   hi = count;
   while( lo < hi)
   {
      mid = lo + (hi - lo) / 2;
      r   = strcmp( s, table[ mid].code);
      if( ! r)
         return( [NSString stringWithUTF8String:table[ mid].name]);
      if( r < 0)
         hi = mid;
      else
         lo = mid + 1;
   }
   return( nil);
}


// Languages written right to left. This is a *language* list (which is what
// characterDirectionForLanguage: asks about), not a script list: a language
// that can be written in an Arabic script but defaults to a Latin one (az, ku,
// ms, ...) is deliberately left out, the same way Apple treats it. The legacy
// ISO 639-1 aliases iw (he) and ji (yi) are listed as well so that an older
// identifier still answers RightToLeft.
static char   *const   mulle_locale_rtl_languages[] =
{
   "ar", "arc", "bal", "bgn", "ckb", "dv", "fa", "he", "iw",
   "ji", "ks", "mzn", "nqo", "pnb", "prs", "ps", "sd", "syr",
   "ug", "ur", "yi"
};


// The direction of a language. A language we cannot name is not one we know,
// so it answers Unknown (which matches Apple for a nonsense code). Otherwise
// it is RightToLeft when the language is in the small list above and
// LeftToRight otherwise.
//
// -characterDirectionForLanguage: and -lineDirectionForLanguage: both answer
// this. For running text the direction of the characters and the direction of
// the lines are the same, and the vertical directions are a layout property
// that this library does not model.
static NSLocaleLanguageDirection   mulle_locale_language_direction( NSString *language)
{
   char         *s;
   NSUInteger   i;
   NSUInteger   n;

   if( ! [language isKindOfClass:[NSString class]])
      return( NSLocaleLanguageDirectionUnknown);

   language = [language lowercaseString];
   if( ! mulle_is_iso_code( language, 2, 3, NO))
      return( NSLocaleLanguageDirectionUnknown);

   // The RTL list is checked first: ckb, bal, syr ... run right to left but
   // have no entry in the (ISO 639-1) language name table.
   s = [language UTF8String];
   n = sizeof( mulle_locale_rtl_languages) / sizeof( mulle_locale_rtl_languages[ 0]);
   for( i = 0; i < n; i++)
      if( ! strcmp( s, mulle_locale_rtl_languages[ i]))
         return( NSLocaleLanguageDirectionRightToLeft);

   if( ! mulle_locale_display_name( mulle_locale_language_names,
                                    MULLE_LOCALE_DISPLAY_NAME_COUNT( mulle_locale_language_names),
                                    language))
      return( NSLocaleLanguageDirectionUnknown);

   return( NSLocaleLanguageDirectionLeftToRight);
}


// "de_DE.UTF-8@euro" -> "de_DE". A codeset (".UTF-8") and a modifier ("@euro")
// are not part of a language identifier, so they are cut off.
static NSString   *mulle_locale_language_identifier( NSString *identifier)
{
   NSArray    *components;
   NSString   *base;

   components = [identifier componentsSeparatedByString:@"@"];
   base       = [components objectAtIndex:0];
   components = [base componentsSeparatedByString:@"."];
   return( [components objectAtIndex:0]);
}


// "zh-Hans", "en_US.UTF-8" and "de@euro" all name the same language as their
// first component does. displayNameForKey:value: wants a code, not an
// identifier, but tolerating the extra parts costs nothing.
static NSString   *mulle_locale_display_name_code( NSString *value)
{
   unichar      c;
   NSUInteger   i;
   NSUInteger   n;

   n = [value length];
   for( i = 0; i < n; i++)
   {
      c = [value characterAtIndex:i];
      if( c == '-' || c == '_' || c == '.' || c == '@')
         return( [value substringToIndex:i]);
   }
   return( value);
}


@implementation NSLocale

static struct
{
   BOOL                   _initialized;
   mulle_thread_mutex_t   _lock;
   NSLocale               *_systemLocale;
   NSLocale               *_currentLocale;

   // +availableLocaleIdentifiers can be expensive (it enumerates the locales
   // the platform installed) and never changes for the lifetime of a process,
   // so the three ISO code lists derived from it are computed at most once and
   // cached here.
   NSArray                *_languageCodes;
   NSArray                *_countryCodes;
   NSArray                *_currencyCodes;
} Self;


static inline void   SelfLock( void)
{
   mulle_thread_mutex_lock( &Self._lock);
}


static inline void   SelfUnlock( void)
{
   mulle_thread_mutex_unlock( &Self._lock);
}


// Returns the cached code list if there is one. Otherwise stores "computed"
// and returns that. The returned array is autoreleased, the cache keeps its
// own reference. Racing threads may both compute a list; the first one to
// take the lock wins and the other's list is simply discarded (it is
// autoreleased by the caller).
static NSArray   *mulle_locale_cached_code_list( NSArray **cache_p, NSArray *computed)
{
   NSArray   *codes;

   SelfLock();
   {
      if( ! *cache_p && computed)
      {
         // Store an immutable snapshot: the list is handed to every thread
         // that asks, and the mutable array built by the caller carries the
         // affinity of whichever thread built it. Mark it thread-safe so a
         // locale queried from any thread may share it.
         codes = [computed copy];
         [codes mulleSetThreadSafe:YES];
         *cache_p = codes;
      }
      codes = [[*cache_p retain] autorelease];
   }
   SelfUnlock();
   return( codes);
}


// scheme breaks down if categories aren't loaded yet and some one
// calls the first NSLocale method
+ (void) initialize
{
   if( Self._initialized)
      return;
   Self._initialized = YES;

   if( mulle_thread_mutex_init( &Self._lock))
   {
      mulle_fprintf( stderr, "%s could not get a mutex\n", __FUNCTION__);
      abort();
   }

   if( [self respondsToSelector:@selector( _systemLocale)])
      Self._systemLocale  = [[self _systemLocale] retain];
   if( [self respondsToSelector:@selector( _currentLocale)])
      Self._currentLocale = [[self _currentLocale] retain];

   // These are created before the MulleObjCThreadSafe mixin +initialize
   // has run (the class's own +initialize runs first), so they would
   // otherwise carry TAO affinity to this thread despite NSLocale being
   // declared thread-safe.
   [Self._systemLocale mulleSetThreadSafe:YES];
   [Self._currentLocale mulleSetThreadSafe:YES];
}


+ (void) deinitialize
{
   NSArray   *codes;

   [Self._systemLocale release];
   Self._systemLocale = nil;
   [Self._currentLocale release];
   Self._currentLocale = nil;

   codes = Self._languageCodes; Self._languageCodes = nil; [codes release];
   codes = Self._countryCodes;  Self._countryCodes  = nil; [codes release];
   codes = Self._currencyCodes; Self._currencyCodes = nil; [codes release];

   mulle_thread_mutex_done( &Self._lock);
   Self._initialized = NO;
}


+ (instancetype) systemLocale
{
   return( Self._systemLocale ? Self._systemLocale : [self _systemLocale]);
}


+ (instancetype) currentLocale
{
   return( Self._currentLocale ? Self._currentLocale : [self _currentLocale]);
}


// The languages the user prefers, most wanted first. macOS reads an
// "AppleLanguages" user default; this layer cannot reach NSUserDefaults (that
// is a higher layer), so it uses the environment: "LANGUAGE" (a ':' separated
// preference list, the only variable that can name more than one language),
// else the single locale of LC_ALL / LC_CTYPE / LANG. A codeset and a modifier
// are not part of a language identifier and are dropped (see above).
//
// The list is never empty. When the environment names no language it is the
// language of +currentLocale, or "en" if even that has none, so a caller can
// rely on the first element being a usable language code.
+ (NSArray *) preferredLanguages
{
   NSMutableArray   *languages;
   NSMutableSet     *seen;
   NSArray          *tokens;
   NSString         *token;
   NSString         *identifier;
   NSString         *language;
   char             *s;
   NSUInteger       i;
   NSUInteger       n;

   languages = [NSMutableArray array];
   seen      = [NSMutableSet set];

   // "LANGUAGE" is a glibc/BSD extension and simply unset elsewhere
   s = getenv( "LANGUAGE");
   if( s && *s)
      tokens = [[NSString stringWithUTF8String:s] componentsSeparatedByString:@":"];
   else
   {
      s = getenv( "LC_ALL");
      if( ! s || ! *s)
         s = getenv( "LC_CTYPE");
      if( ! s || ! *s)
         s = getenv( "LANG");
      tokens = (s && *s) ? @[ [NSString stringWithUTF8String:s]] : nil;
   }

   n = [tokens count];
   for( i = 0; i < n; i++)
   {
      token      = [tokens objectAtIndex:i];
      token      = [token stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      identifier = mulle_locale_language_identifier( token);
      if( ! [identifier length])
         continue;
      if( [seen containsObject:identifier])
         continue;
      [seen addObject:identifier];
      [languages addObject:identifier];
   }

   if( ! [languages count])
   {
      language = [[self currentLocale] languageCode];
      [languages addObject:language ? language : @"en"];
   }
   return( languages);
}


+ (NSLocaleLanguageDirection) characterDirectionForLanguage:(NSString *) language
{
   return( mulle_locale_language_direction( language));
}


+ (NSLocaleLanguageDirection) lineDirectionForLanguage:(NSString *) language
{
   return( mulle_locale_language_direction( language));
}


// A platform category (NSLocale( Posix), NSLocale( Windows) ...) overrides
// this with a real OS enumeration ("locale -a", EnumSystemLocalesEx ...).
// The default exists so that the method declared in NSLocale.h can never be
// an unknown method: a platform that has no such backend still serves a
// usable, if minimal, list instead of crashing the universe.
+ (NSArray *) availableLocaleIdentifiers
{
   return( @[ @"C", @"POSIX"]);
}


// Derived from +availableLocaleIdentifiers, filtered to ISO 639 shaped codes.
// The result is cached in Self, it costs a system call to build.
+ (NSArray *) ISOLanguageCodes
{
   NSArray          *codes;
   NSMutableArray   *result;
   NSMutableSet     *seen;
   NSArray          *identifiers;
   NSString         *identifier;
   NSString         *language;
   NSString         *script;
   NSString         *country;
   NSString         *variant;
   NSString         *modifier;
   NSString         *code;
   NSUInteger       i;
   NSUInteger       n;

   codes = mulle_locale_cached_code_list( &Self._languageCodes, nil);
   if( codes)
      return( codes);

   result      = [NSMutableArray array];
   seen        = [NSMutableSet set];
   identifiers = [self availableLocaleIdentifiers];
   n           = [identifiers count];
   for( i = 0; i < n; i++)
   {
      identifier = [identifiers objectAtIndex:i];
      [self _parseLocaleIdentifier:identifier
                          language:&language
                            script:&script
                           country:&country
                           variant:&variant
                          modifier:&modifier];

      code = [language lowercaseString];
      if( ! mulle_is_iso_code( code, 2, 3, NO))
         continue;
      if( [seen containsObject:code])
         continue;
      [seen addObject:code];
      [result addObject:code];
   }
   return( mulle_locale_cached_code_list( &Self._languageCodes, result));
}


// Derived from +availableLocaleIdentifiers, filtered to ISO 3166 shaped codes.
// The result is cached in Self, it costs a system call to build.
+ (NSArray *) ISOCountryCodes
{
   NSArray          *codes;
   NSMutableArray   *result;
   NSMutableSet     *seen;
   NSArray          *identifiers;
   NSString         *identifier;
   NSString         *language;
   NSString         *script;
   NSString         *country;
   NSString         *variant;
   NSString         *modifier;
   NSString         *code;
   NSUInteger       i;
   NSUInteger       n;

   codes = mulle_locale_cached_code_list( &Self._countryCodes, nil);
   if( codes)
      return( codes);

   result      = [NSMutableArray array];
   seen        = [NSMutableSet set];
   identifiers = [self availableLocaleIdentifiers];
   n           = [identifiers count];
   for( i = 0; i < n; i++)
   {
      identifier = [identifiers objectAtIndex:i];
      [self _parseLocaleIdentifier:identifier
                          language:&language
                            script:&script
                           country:&country
                           variant:&variant
                          modifier:&modifier];

      code = [country uppercaseString];
      if( ! mulle_is_iso_code( code, 2, 2, YES))
         continue;
      if( [seen containsObject:code])
         continue;
      [seen addObject:code];
      [result addObject:code];
   }
   return( mulle_locale_cached_code_list( &Self._countryCodes, result));
}


// Derived from the currency of every available locale, filtered to ISO 4217
// shaped codes. This does ask each locale for its currency code, which is why
// it needs a working backend, not just the platform agnostic part. A locale
// whose monetary data can not be turned into a string (a legacy encoded locale
// like zh_CN.eucCN for instance) simply contributes no code.
+ (NSArray *) ISOCurrencyCodes
{
   NSArray          *codes;
   NSMutableArray   *result;
   NSMutableSet     *seen;
   NSArray          *identifiers;
   NSLocale         *locale;
   NSString         *identifier;
   NSString         *code;
   NSUInteger       i;
   NSUInteger       n;

   codes = mulle_locale_cached_code_list( &Self._currencyCodes, nil);
   if( codes)
      return( codes);

   result      = [NSMutableArray array];
   seen        = [NSMutableSet set];
   identifiers = [self availableLocaleIdentifiers];
   n           = [identifiers count];
   for( i = 0; i < n; i++)
   {
      identifier = [identifiers objectAtIndex:i];
      locale     = [self localeWithLocaleIdentifier:identifier];
      code       = [[locale currencyCode] uppercaseString];

      if( ! mulle_is_iso_code( code, 3, 3, YES))
         continue;
      if( [seen containsObject:code])
         continue;
      [seen addObject:code];
      [result addObject:code];
   }
   return( mulle_locale_cached_code_list( &Self._currencyCodes, result));
}


// "language[_script][_country][.codeset][@modifier]" -> components. The codeset
// is not a locale component and is dropped. nil input stays nil, an identifier
// without any components yields an empty dictionary.
+ (NSDictionary *) componentsFromLocaleIdentifier:(NSString *) identifier
{
   NSMutableDictionary   *components;
   NSString              *language;
   NSString              *script;
   NSString              *country;
   NSString              *variant;
   NSString              *modifier;

   if( ! identifier)
      return( nil);

   [self _parseLocaleIdentifier:identifier
                       language:&language
                         script:&script
                        country:&country
                        variant:&variant
                       modifier:&modifier];

   components = [NSMutableDictionary dictionary];
   if( language)
      [components setObject:language forKey:NSLocaleLanguageCode];
   if( script)
      [components setObject:script forKey:NSLocaleScriptCode];
   if( country)
      [components setObject:country forKey:NSLocaleCountryCode];

   // Apple has one variant component for both spellings. A base variant is
   // more specific than the "@modifier", so it wins when both are present.
   if( variant)
      [components setObject:variant forKey:NSLocaleVariantCode];
   else
      if( modifier)
         [components setObject:modifier forKey:NSLocaleVariantCode];
   return( components);
}


+ (NSString *) localeIdentifierFromComponents:(NSDictionary *) components
{
   NSMutableString   *identifier;
   NSString          *s;
   BOOL              has;

   if( ! components)
      return( nil);

   identifier = [NSMutableString string];
   has        = NO;

   s = [components objectForKey:NSLocaleLanguageCode];
   if( [s length])
   {
      [identifier appendString:s];
      has = YES;
   }

   s = [components objectForKey:NSLocaleScriptCode];
   if( [s length])
   {
      if( has)
         [identifier appendString:@"_"];
      [identifier appendString:s];
      has = YES;
   }

   s = [components objectForKey:NSLocaleCountryCode];
   if( [s length])
   {
      if( has)
         [identifier appendString:@"_"];
      [identifier appendString:s];
      has = YES;
   }

   s = [components objectForKey:NSLocaleVariantCode];
   if( [s length])
   {
      if( has)
         [identifier appendString:mulle_locale_variant_is_modifier( s) ? @"@" : @"_"];
      [identifier appendString:s];
      has = YES;
   }

   return( has ? identifier : nil);
}


+ (NSString *) canonicalLocaleIdentifierFromString:(NSString *) string
{
   NSDictionary         *components;
   NSMutableDictionary  *canonical;
   NSString             *s;

   components = [self componentsFromLocaleIdentifier:string];
   if( ! [components count])
      return( nil);

   canonical = [NSMutableDictionary dictionaryWithDictionary:components];

   s = [components objectForKey:NSLocaleLanguageCode];
   if( s)
      [canonical setObject:[s lowercaseString] forKey:NSLocaleLanguageCode];

   s = [components objectForKey:NSLocaleScriptCode];
   if( s)
      [canonical setObject:[s capitalizedString] forKey:NSLocaleScriptCode];

   s = [components objectForKey:NSLocaleCountryCode];
   if( s)
      [canonical setObject:[s uppercaseString] forKey:NSLocaleCountryCode];

   return( [self localeIdentifierFromComponents:canonical]);
}


+ (NSString *) canonicalLanguageIdentifierFromString:(NSString *) string
{
   NSDictionary   *components;
   NSString       *language;

   components = [self componentsFromLocaleIdentifier:string];
   language   = [components objectForKey:NSLocaleLanguageCode];
   return( language ? [language lowercaseString] : nil);
}



+ (instancetype) localeWithLocaleIdentifier:(NSString *) s
{
   return( [[[self alloc] initWithLocaleIdentifier:s] autorelease]);
}


- (BOOL) __isNSLocale
{
   return( YES);
}


+ (instancetype) autoupdatingCurrentLocale
{
   return( [self currentLocale]);
}


- (NSString *) localeIdentifier
{
   return( _identifier);
}


// The identifier derived keys are precomputed by -_setupDerivedLocaleValues:
// into _derivedValues, an immutable dictionary that is filled before the
// locale can be reached by another thread and is never mutated afterwards.
// Reading it needs no lock, so the common accessors (languageCode,
// countryCode, scriptCode, ...) do not touch the mutex in steady state and do
// not reparse the identifier. NSNull marks a derived key that has no value,
// and is answered as nil.
//
// Everything else needs the OS (or is simply unknown) and is cached lazily in
// _keyValues, protected by _lock. A backend that does not create a lock
// (Windows for instance) is not synchronized, but the values are still
// answered and cached.
- (id) objectForKey:(id) key   MULLE_OBJC_THREADSAFE_METHOD
{
   id   value;

   value = [_derivedValues objectForKey:key];
   if( value)
      return( value == [NSNull null] ? nil : value);

   if( _lock)
      [_lock lock];
   {
      value = [_keyValues objectForKey:key];
      if( value)
      {
         if( value == [NSNull null])
            value = nil;
      }
      else
      {
         value = [self _localeInfoForKey:key];
         if( ! value)
            value = [self _derivedLocaleInfoForKey:key];
         [_keyValues setObject:value ? value : [NSNull null]
                        forKey:key];
      }
   }
   if( _lock)
      [_lock unlock];
   return( value);
}

@method_implementation -: = -objectForKey:;


// The platform category overrides this. The default answers "I don't know",
// which makes -objectForKey: fall through to the platform agnostic keys.
- (id) _localeInfoForKey:(id) key
{
   return( nil);
}


// https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html#//apple_ref/doc/uid/10000171i-CH15
//
// None of these need an OS API, they follow from the identifier alone. That is
// why they live in the platform agnostic part of NSLocale.
// These are fallbacks: a backend that can ask the OS (BSD uses querylocale,
// Linux parses the identifier) is consulted first and wins.
//
// -objectForKey: does not normally get here, because -init has already stored
// the answers in _derivedValues (see -_setupDerivedLocaleValues:). This is
// what answers when a locale was not built by -initWithLocaleIdentifier:.
- (id) _derivedLocaleInfoForKey:(id) key
{
   NSString   *language;
   NSString   *script;
   NSString   *country;
   NSString   *variant;
   NSString   *modifier;

   if( ! [key isKindOfClass:[NSString class]])
      return( nil);

   [[self class] _parseLocaleIdentifier:_identifier
                              language:&language
                                script:&script
                               country:&country
                               variant:&variant
                              modifier:&modifier];

   return( mulle_locale_derived_value_for_key( key, _identifier,
                                               language, script, country,
                                               variant, modifier));
}


// Every key mulle_locale_derived_value_for_key() can answer. Parsing the
// identifier once for all of them keeps -objectForKey: from reparsing it for
// each distinct key (and from taking _lock at all).
- (void) _setupDerivedLocaleValues:(NSDictionary *) auxiliaryInfo
{
   NSMutableDictionary   *values;
   NSString              *keys[] =
   {
      NSLocaleIdentifier,
      NSLocaleLanguageCode,
      NSLocaleScriptCode,
      NSLocaleCountryCode,
      NSLocaleVariantCode,
      NSLocaleCollationIdentifier,
      NSLocaleCollatorIdentifier,
      NSLocaleMeasurementSystem,
      NSLocaleUsesMetricSystem,
      NSLocaleQuotationBeginDelimiterKey,
      NSLocaleQuotationEndDelimiterKey,
      NSLocaleAlternateQuotationBeginDelimiterKey,
      NSLocaleAlternateQuotationEndDelimiterKey
   };
   NSString              *language;
   NSString              *script;
   NSString              *country;
   NSString              *variant;
   NSString              *modifier;
   id                    value;
   NSUInteger            i;

   [[self class] _parseLocaleIdentifier:_identifier
                              language:&language
                                script:&script
                               country:&country
                               variant:&variant
                              modifier:&modifier];

   values = [NSMutableDictionary dictionary];
   for( i = 0; i < sizeof( keys) / sizeof( keys[ 0]); i++)
   {
      value = mulle_locale_derived_value_for_key( keys[ i], _identifier,
                                                  language, script, country,
                                                  variant, modifier);
      // NSNull marks "asked, there is no value", so -objectForKey: answers
      // this key from the dictionary instead of asking the platform, which
      // would only answer nil as well.
      [values setObject:value ? value : [NSNull null]
                forKey:keys[ i]];
   }

   // A locale can ship a data file. That is the more specific source, so it
   // wins over the derived value (this used to be merged into _keyValues).
   if( auxiliaryInfo)
      [values addEntriesFromDictionary:auxiliaryInfo];

   // An immutable snapshot, marked thread-safe: it is handed to every thread
   // that asks, and -objectForKey: reads it without a lock.
   _derivedValues = [values copy];
   [_derivedValues mulleSetThreadSafe:YES];
}


+ (void) _parseLocaleIdentifier:(NSString *) identifier
                       language:(NSString **) language_p
                         script:(NSString **) script_p
                        country:(NSString **) country_p
                        variant:(NSString **) variant_p
                       modifier:(NSString **) modifier_p
{
   NSArray    *components;
   NSString   *base;
   NSString   *component;
   NSString   *language;
   NSString   *script;
   NSString   *country;
   NSString   *variant;
   unichar    c;
   NSUInteger i;
   NSUInteger n;

   *language_p = nil;
   *script_p   = nil;
   *country_p  = nil;
   *variant_p  = nil;
   *modifier_p = nil;

   if( ! identifier)
      return;

   // the "@modifier"...
   components = [identifier componentsSeparatedByString:@"@"];
   if( [components count] > 1)
      *modifier_p = [components objectAtIndex:1];
   base = [components objectAtIndex:0];

   // ...and the ".codeset"
   components = [base componentsSeparatedByString:@"."];
   base       = [components objectAtIndex:0];

   // "-" is a separator as well, normalize it before splitting
   base       = [base stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
   components = [base componentsSeparatedByString:@"_"];
   n          = [components count];

   language = n ? [components objectAtIndex:0] : nil;
   script   = nil;
   country  = nil;
   variant  = nil;

   for( i = 1; i < n; i++)
   {
      component = [components objectAtIndex:i];

      // A lone lowercase letter opens a BCP-47 extension sequence
      // ("en-US-u-ca-gregory"): "u" unicode, "t" transform, "x" private use.
      // None of what follows is a locale component, so stop here instead of
      // misreading its first token as a country.
      if( [component length] == 1)
      {
         c = [component characterAtIndex:0];
         if( c >= 'a' && c <= 'z')
            break;
      }

      // a four letter alphabetic component is a script ("Hans")
      if( ! script && mulle_locale_is_script_component( component))
      {
         script = component;
         continue;
      }

      // a four digit or all-uppercase component is a variant ("1901",
      // "POSIX", "VALENCIA")
      if( ! variant && mulle_locale_is_variant_component( component))
      {
         variant = component;
         continue;
      }

      // a two letter or three digit component is a country
      if( ! country && mulle_locale_is_country_component( component))
         country = component;
   }

   *language_p = [language length] ? language : nil;
   *script_p   = script;
   *country_p  = country;
   *variant_p  = variant;
}


// https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html#//apple_ref/doc/uid/10000171i-CH15
//
// Apple answers the name of a language, country, script or variant *in the
// language of the receiver*. We only have English names (see the tables
// above), so a receiver that is not English still answers the English name -
// a name is more useful than the bare code, which is what the old 12 entry
// table (and only for an "en" receiver) left behind.
//
// A code no table knows, and every key that has no name table at all (the
// identifier, a currency code, the calendar, the collation and collator
// identifiers), comes back as the value *unchanged*. Apple answers nil there,
// we must not: NSBundle turns localizedStringForLanguageCode: into a
// "<name>.lproj" directory name, so an unknown language has to come back as
// the code rather than as nil.
//
- (NSString *) displayNameForKey:(id) key
                           value:(id) value
{
   NSString   *code;
   NSString   *name;

   if( ! [key isKindOfClass:[NSString class]])
      return( value);
   if( ! [value isKindOfClass:[NSString class]])
      return( value);

   code = mulle_locale_display_name_code( value);

   if( [key isEqualToString:NSLocaleLanguageCode])
      name = mulle_locale_display_name( mulle_locale_language_names,
                                        MULLE_LOCALE_DISPLAY_NAME_COUNT( mulle_locale_language_names),
                                        [code lowercaseString]);
   else
      if( [key isEqualToString:NSLocaleCountryCode])
         name = mulle_locale_display_name( mulle_locale_country_names,
                                           MULLE_LOCALE_DISPLAY_NAME_COUNT( mulle_locale_country_names),
                                           [code uppercaseString]);
      else
         if( [key isEqualToString:NSLocaleScriptCode])
            name = mulle_locale_display_name( mulle_locale_script_names,
                                              MULLE_LOCALE_DISPLAY_NAME_COUNT( mulle_locale_script_names),
                                              [code capitalizedString]);
         else
            if( [key isEqualToString:NSLocaleVariantCode])
               name = mulle_locale_display_name( mulle_locale_variant_names,
                                                 MULLE_LOCALE_DISPLAY_NAME_COUNT( mulle_locale_variant_names),
                                                 [code uppercaseString]);
            else
               name = nil;

   return( name ? name : value);
}


#pragma mark - hash and equality

// The identifier two locales are compared and hashed through. Equality has to
// be canonical: "en_US", "en-US" and "en_US.UTF-8" are the *same* locale, and
// without this they would be three different dictionary keys and three
// different set members for one thing. Equal locales must hash equally, so
// -hash has to use this form as well.
//
// A locale made from "en_US" and one made from "en-US" are equal, hash
// equally and are *one* set member, yet their -localeIdentifier strings are
// "en_US" and "en-US" and are two different NSString keys. The object and the
// identifier it hands out are therefore two different key spaces, and a
// dictionary keyed by one will not be found through the other.
// Canonicalizing in -init would close that gap, at the price of
// -localeIdentifier no longer echoing what the caller passed in.
static NSString   *mulle_locale_canonical_identity( Class cls, NSString *identifier)
{
   NSString   *canonical;

   canonical = [cls canonicalLocaleIdentifierFromString:identifier];
   // an identifier without any component (nil, "") has no canonical form, so
   // it can only be compared to itself
   return( canonical ? canonical : identifier);
}


- (NSUInteger) hash
{
   return( [mulle_locale_canonical_identity( [self class], self->_identifier) hash]);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSLocale])
      return( NO);
   return( [self isEqualToLocale:other]);
}


- (BOOL) isEqualToLocale:(NSLocale *) other
{
   return( [mulle_locale_canonical_identity( [self class], self->_identifier)
              isEqualToString:mulle_locale_canonical_identity( [self class], [other localeIdentifier])]);
}

// these are somewhat superflous shortcuts for objectForKey:


- (NSString *) languageCode
{
   return( [self objectForKey:NSLocaleLanguageCode]);
}


- (NSString *) countryCode
{
   return( [self objectForKey:NSLocaleCountryCode]);
}


- (NSString *) scriptCode
{
   return( [self objectForKey:NSLocaleScriptCode]);
}


- (NSString *) variantCode
{
   return( [self objectForKey:NSLocaleVariantCode]);
}


- (NSString *) collationIdentifier
{
   return( [self objectForKey:NSLocaleCollationIdentifier]);
}


- (NSString *) collatorIdentifier
{
   return( [self objectForKey:NSLocaleCollatorIdentifier]);
}


- (NSString *) currencyCode
{
   return( [self objectForKey:NSLocaleCurrencyCode]);
}


// Apple answers a calendar *identifier* (a string, "gregorian") here, while
// objectForKey:NSLocaleCalendar answers an NSCalendar *object*. The object
// can not be built in this library (NSCalendar is in
// MulleObjCCalendarFoundation, above this one), but the string follows from
// the identifier alone, so this is answered from a small hand-rolled table.
- (NSString *) calendarIdentifier
{
   return( mulle_locale_calendar_identifier( [self languageCode], [self countryCode]));
}


- (NSString *) measurementSystem
{
   return( [self objectForKey:NSLocaleMeasurementSystem]);
}


- (BOOL) usesMetricSystem
{
   return( [[self objectForKey:NSLocaleUsesMetricSystem] boolValue]);
}



// these are somewhat superflous shortcuts for displayNameForKey:
- (NSString *) localizedStringForLocaleIdentifier:(NSString *) localeIdentifier
{
   return( [self displayNameForKey:NSLocaleIdentifier value:localeIdentifier]);
}


- (NSString *) localizedStringForCountryCode:(NSString *) countryCode
{
   return( [self displayNameForKey:NSLocaleCountryCode value:countryCode]);
}


- (NSString *) localizedStringForLanguageCode:(NSString *) languageCode
{
   return( [self displayNameForKey:NSLocaleLanguageCode value:languageCode]);
}


- (NSString *) localizedStringForScriptCode:(NSString *) scriptCode
{
   return( [self displayNameForKey:NSLocaleScriptCode value:scriptCode]);
}


- (NSString *) localizedStringForVariantCode:(NSString *) variantCode
{
   return( [self displayNameForKey:NSLocaleVariantCode value:variantCode]);
}


- (NSString *) localizedStringForCollationIdentifier:(NSString *) collationIdentifier
{
   return( [self displayNameForKey:NSLocaleCollationIdentifier value:collationIdentifier]);
}


- (NSString *) localizedStringForCollatorIdentifier:(NSString *) collatorIdentifier
{
   return( [self displayNameForKey:NSLocaleCollatorIdentifier value:collatorIdentifier]);
}


- (NSString *) localizedStringForCurrencyCode:(NSString *) currencyCode
{
   return( [self displayNameForKey:NSLocaleCurrencyCode value:currencyCode]);
}


- (NSString *) localizedStringForCalendarIdentifier:(NSString *) calendarIdentifier
{
   return( [self displayNameForKey:NSLocaleCalendar value:calendarIdentifier]);
}

@end
