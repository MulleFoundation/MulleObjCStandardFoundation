/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSLocale.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
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



@implementation NSLocale

- (NSString *) localeIdentifier
{
   return( _identifier);
}
   

- (NSString *) displayNameForKey:(id) key 
                           value:(id) value
{
   return( key);
}                           

@end

