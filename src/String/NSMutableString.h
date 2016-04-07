/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMutableString.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSString.h"


//
// if NSMutableString is too slow, add a little cache
// so that fastWideStringContents and friends are 
// possible
//
@interface NSMutableString : NSString
{
   NSUInteger   _length;
   NSUInteger   _count;
   NSUInteger   _size;
   NSString     **_storage;
}

+ (id) stringWithCapacity:(NSUInteger) capacity;
- (id) initWithCapacity:(NSUInteger) capacity;

- (id) initWithStrings:(NSString **) strings
                 count:(NSUInteger) count;

- (void) appendString:(NSString *) s;
- (void) deleteCharactersInRange:(NSRange)aRange;

@end

