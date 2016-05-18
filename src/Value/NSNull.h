/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSNull.h is a part of MulleFoundation
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


@interface NSNull : NSObject < MulleObjCSingleton, NSCopying, NSCoding>
{
}

+ (NSNull *) null;

@end
