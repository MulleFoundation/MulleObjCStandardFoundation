/*
 *  MulleFoundation - the mulle-objc class library
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

@implementation NSLocale

- (NSString *) localeIdentifier
{
   return( _identifier);
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

@end

