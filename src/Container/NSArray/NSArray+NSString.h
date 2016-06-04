/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSArray+NSString.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSArray.h"


@class NSString;


@interface NSArray( NSString)

- (NSString *) componentsJoinedByString:(NSString *) separator;

@end
