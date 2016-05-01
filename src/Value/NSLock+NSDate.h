/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSLock.h is a part of MulleFoundation
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


@class NSDate;


@interface NSLock( NSDate)

- (BOOL) lockBeforeDate:(NSDate *) limit;

@end

