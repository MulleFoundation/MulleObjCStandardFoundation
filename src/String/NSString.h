/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSString.h is a part of MulleFoundation
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


#import <mulle_utf/mulle_utf.h>
#import <mulle_vararg/mulle_vararg.h>


// maybe more later. ensure that the enums have same numeric values as 
// in AppleFoundation
//

enum
{
   NSASCIIStringEncoding,  // easy
   NSUTF8StringEncoding,   // default
   NSUTF32StringEncoding   // easy
};


enum 
{
   NSCaseInsensitiveSearch = 0x001,
   NSLiteralSearch         = 0x002,  
   NSBackwardsSearch       = 0x004,
   NSAnchoredSearch        = 0x008,
   NSNumericSearch         = 0x040 
};

typedef NSUInteger   NSStringCompareOptions;
typedef NSUInteger   NSStringEncoding;



//
// NSString is outside of NSObject, the most fundamental class
// since its totally pervasive in all other classes.
// The implementation in MulleObjCFoundation is slightly schizophrenic.
// On the character level anything below UTF-32 is just misery.
// But UTF-8 is basically what is being used (for I/O).
//
// The MulleObjCFoundation deals with UTF32 and UTF8.
// UTF-16 is treated just an optimized storage medium for UTF strings.
//
// A CString is a string with a zero terminator in the C locale,
// this particular library does not deal with locales, so the concept
// is postponed until the POSIX is introduced. (Truth be told, c locales suck)
//
// To support unichar somewhat efficiently
//
//    o make unichar UTF-32
//    o store strings in three formats
//        1. ASCII (7 bit)
//        2. UTF-16 (w/o surrogate pairs)
//        3. UTF-32, everything else
//    o strings that are not ASCII, store their UTF8 representation when
//      needed.
//
// As an external exchange format UTF8 is the law, forget the others.
//

//
// when dealing with the filesystem (open/stat) use -fileSystemRepresentation
// defined by a layer upwards of MulleObjCFoundation
// when interfacing with the OS (log messages) or C use cString
// in all other cases use UTF8String
//

@interface NSString : NSObject < NSCopying>
{
}

+ (id) string;
+ (id) stringWithString:(NSString *) other;

- (id) description;

- (NSString *) substringFromIndex:(NSUInteger) index;
- (NSString *) substringToIndex:(NSUInteger) index;

- (double) doubleValue;
- (float) floatValue;
- (int) intValue;
- (long long) longLongValue;
- (NSInteger) integerValue;
- (BOOL) boolValue;




//
// UTF8
//
+ (id) stringWithUTF8String:(mulle_utf8char_t *) s;
+ (id) stringWithUTF8Characters:(mulle_utf8char_t *) s
                         length:(NSUInteger) len;
+ (id) stringWithUTF8CharactersNoCopy:(mulle_utf8char_t *) s
                               length:(NSUInteger) len
                            allocator:(struct mulle_allocator *) allocator;
// characters are not zero terminated
- (void) getUTF8Characters:(mulle_utf8char_t *) buf
                 maxLength:(NSUInteger) maxLength;
- (void) getUTF8Characters:(mulle_utf8char_t *) buf;

// strings are zero terminated
- (void) getUTF8String:(mulle_utf8char_t *) buf
             maxLength:(NSUInteger) maxLength;
- (void) getUTF8String:(mulle_utf8char_t *) buf;

- (mulle_utf8char_t *) UTF8String;

@end


@interface NSString( Subclasses)

- (unichar) characterAtIndex:(NSUInteger) index;
- (NSUInteger) length;

- (NSString *) stringByAppendingString:(NSString *) other;

- (NSUInteger) getCharacters:(unichar *) buffer
                   maxLength:(NSUInteger) maxLength
                       range:(NSRange) aRange;

- (NSUInteger) getUTF8Characters:(mulle_utf8char_t *) buffer
                       maxLength:(NSUInteger) maxLength
                          range:(NSRange) aRange;

- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range;


- (NSString *) uppercaseString;
- (NSString *) lowercaseString;
- (NSString *) capitalizedString;

- (NSString *) substringWithRange:(NSRange) range;

@end


@interface NSString ( Todo)

- (id) stringByPaddingToLength:(NSUInteger) length
                    withString:(NSString *) other
                startingAtIndex:(NSUInteger) index;
                
- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) search
                                         withString:(NSString *) replacement
                                            options:(NSUInteger) options
                                              range:(NSRange) range;
                                    
- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) search
                                         withString:(NSString *) replacement;
- (NSString *) stringByReplacingCharactersInRange:(NSRange) range
                                       withString:(NSString *) replacement;

@end

