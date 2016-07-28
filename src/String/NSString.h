/*
 *  MulleFoundation - the mulle-objc class library
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

#import "NSCharacterSet.h"

#import <mulle_vararg/mulle_vararg.h>


enum 
{
   NSCaseInsensitiveSearch = 0x001,
   NSLiteralSearch         = 0x002,  
   NSBackwardsSearch       = 0x004,
   NSAnchoredSearch        = 0x008,
   NSNumericSearch         = 0x040 
};

typedef NSUInteger   NSStringCompareOptions;



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

@interface NSString : NSObject < MulleObjCClassCluster, NSCopying, NSCoding>
{
}

+ (id) string;
+ (id) stringWithString:(NSString *) other;

- (id) description;

- (NSString *) substringWithRange:(NSRange) range;
- (NSString *) substringFromIndex:(NSUInteger) index;
- (NSString *) substringToIndex:(NSUInteger) index;

- (double) doubleValue;
- (float) floatValue;
- (int) intValue;
- (long long) longLongValue;
- (NSInteger) integerValue;
- (BOOL) boolValue;


//
// UTF32
//
+ (id) stringWithCharacters:(unichar *) s
                     length:(NSUInteger) len;

- (void) getCharacters:(unichar *) buffer;

//
// UTF8
//
+ (id) stringWithUTF8String:(mulle_utf8_t *) s;
+ (id) _stringWithUTF8Characters:(mulle_utf8_t *) s
                         length:(NSUInteger) len;

// characters are not zero terminated
- (void) _getUTF8Characters:(mulle_utf8_t *) buf;

+ (BOOL) _areValidUTF8Characters:(mulle_utf8_t *) buffer
                          length:(NSUInteger) length;

// strings are zero terminated, zero stored in
// buf[ size - 1]
//
- (NSUInteger) _getUTF8String:(mulle_utf8_t *) buf
                  bufferSize:(NSUInteger) size;
- (void) _getUTF8String:(mulle_utf8_t *) buf;

- (mulle_utf8_t *) UTF8String;

- (NSString *) uppercaseString;
- (NSString *) lowercaseString;
- (NSString *) capitalizedString;

@end


@interface NSString( MulleAdditions)

- (NSUInteger) _UTF8StringLength;
+ (id) _stringWithCharactersNoCopy:(unichar *) s
                            length:(NSUInteger) len
                         allocator:(struct mulle_allocator *) allocator;
+ (id) _stringWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                length:(NSUInteger) len
                             allocator:(struct mulle_allocator *) allocator;

@end


@interface NSString( Subclasses)

- (unichar) characterAtIndex:(NSUInteger) index;
- (NSUInteger) length;

- (void) getCharacters:(unichar *) buffer
                 range:(NSRange) range;
- (void) _getUTF8Characters:(mulle_utf8_t *) buffer
                  maxLength:(NSUInteger) length;
@end


@interface NSString ( Todo)

- (NSString *) stringByAppendingString:(NSString *) other;

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


/*
 * support for subclasses to calculate
 * hash efficiently. Deals with UTF8 strings!
 */
static inline  NSRange   MulleObjCHashRange( NSUInteger length)
{
   NSUInteger   offset;

   offset = 0;
   if( length > 48)
   {
      offset = length - 48;
      length = 48;
   }
   return( NSMakeRange( offset, length));
}


static inline NSUInteger   MulleObjCStringHash( mulle_utf8_t *buf, NSUInteger length)
{
   return( mulle_objc_fnv1( buf, length * sizeof( mulle_utf8_t)));
}

