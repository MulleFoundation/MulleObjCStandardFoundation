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

#import "NSMutableCopying.h"


@interface NSMutableString : NSString
{
   unsigned int   _length;
   unsigned int   _count;
   unsigned int   _size;
   NSString       **_storage;
   
   mulle_utf8_t   *_shadow;
   NSUInteger     _shadowLen;
}

+ (id) stringWithCapacity:(NSUInteger) capacity;
- (id) initWithCapacity:(NSUInteger) capacity;

- (id) initWithStrings:(NSString **) strings
                 count:(NSUInteger) count;

- (void) appendString:(NSString *) s;
- (void) appendFormat:(NSString *) format, ...;

- (void) replaceCharactersInRange:(NSRange) aRange 
                       withString:(NSString *) replacement;

- (void) replaceOccurrencesOfString:(NSString *) s
                         withString:(NSString *) replacement
                            options:(NSStringCompareOptions) options
                              range:(NSRange) range;

- (void) deleteCharactersInRange:(NSRange)aRange;

// here nil is allowed and clears the NSMutableString(!)
- (void) setString:(NSString *) s;

@end


@interface NSString ( NSMutableString) < NSMutableCopying>
@end
