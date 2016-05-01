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
#import "MulleObjCFoundationValue.h"


@class NSLocale;


@interface NSNumberFormatter( NSLocale)

- (NSLocale *) locale;
- (void) setLocale:(NSLocale *) locale;

- (void) setLocalizesFormat:(BOOL) flag;
- (BOOL) localizesFormat;

@end


@interface NSDateFormatter( NSLocale)

- (NSLocale *) locale;
- (void) setLocale:(NSLocale *) locale;

@end
