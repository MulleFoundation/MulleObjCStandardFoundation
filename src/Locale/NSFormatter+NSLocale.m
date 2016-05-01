/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSFormatter+Localization.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSFormatter+NSLocale.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSNumberFormatter( NSLocale)

- (NSLocale *) locale
{
   return( _locale);
}


- (void) setLocale:(NSLocale *) locale
{
   [_locale autorelease];
   locale = [_locale copy];
}


- (void) setLocalizesFormat:(BOOL) flag
{
   _flags.localizesFormat = flag;
}


- (BOOL) localizesFormat
{
   return( _flags.localizesFormat);
}


@end


@implementation NSDateFormatter( _Localization)

- (NSLocale *) locale
{
   return( _locale);
}


- (void) setLocale:(NSLocale *) locale
{
   [_locale autorelease];
   locale = [_locale copy];
}

@end
