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

@interface NSString : NSObject < MulleObjCClassCluster, NSCopying>
{
}

+ (id) string;
+ (id) stringWithString:(NSString *) arg1;
+ (id) stringWithFormat:(NSString *) format, ...;
+ (id) stringWithFormat:(NSString *) format
              arguments:(mulle_vararg_list) arguments;
+ (id) stringWithFormat:(NSString *) format
                va_list:(va_list) arguments;


- (id) description;


- (NSString *) substringWithRange:(NSRange) arg1;
- (NSString *) substringFromIndex:(NSUInteger) arg1;
- (NSString *) substringToIndex:(NSUInteger) arg1;
- (NSString *) stringByAppendingFormat:(NSString *) arg1, ...;


- (double) doubleValue;
- (float) floatValue;
- (int) intValue;
- (long long) longLongValue;
- (NSInteger) integerValue;
- (BOOL) boolValue;



//
// UTF32
//
- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range;


//
// UTF8
//
+ (id) stringWithUTF8String:(utf8char *) s;
+ (id) stringWithUTF8Characters:(utf8char *) s
                         length:(NSUInteger) len;

+ (id) stringWithUTF8String:(utf8char *) s
                     length:(NSUInteger) len
               freeWhenDone:(BOOL) flag;

// characters are not zero terminated
- (void) getUTF8Characters:(utf8char *) buf
                 maxLength:(NSUInteger) maxLength;
- (void) getUTF8Characters:(utf8char *) buf;

// strings are zero terminated
- (void) getUTF8String:(utf8char *) buf
             maxLength:(NSUInteger) maxLength;
- (void) getUTF8String:(utf8char *) buf;

@end


@interface NSString( ClassCluster)

- (utf8char *) UTF8String;

- (id) initWithString:(NSString *) arg1;
- (id) initWithFormat:(NSString *) format, ...; 
- (id) initWithFormat:(NSString *) format 
            arguments:(mulle_vararg_list) argList;
- (id) initWithFormat:(NSString *) format
              va_list:(va_list) arguments;

- (id) initWithUTF8Characters:(utf8char *) s
                       length:(NSUInteger) len;

- (id) initWithUTF8String:(utf8char *) s;
- (id) initWithUTF8String:(utf8char *) s
                   length:(NSUInteger) len;
- (id) initWithUTF8StringNoCopy:(utf8char *) s
                         length:(NSUInteger) length
                   freeWhenDone:(BOOL) flag;
@end


@interface NSString( Subclasses)

- (unichar) characterAtIndex:(NSUInteger) index;
- (NSUInteger) length;

- (NSString *) stringByAppendingString:(NSString *) arg1;

- (NSUInteger) getCharacters:(unichar *) buffer
                   maxLength:(NSUInteger) maxLength
                       range:(NSRange) aRange;

- (NSUInteger) getUTF8Characters:(utf8char *) buffer
                       maxLength:(NSUInteger) maxLength
                          range:(NSRange) aRange;

- (NSString *) uppercaseString;
- (NSString *) lowercaseString;
- (NSString *) capitalizedString;

@end


@interface NSString ( Todo)

- (id) stringByPaddingToLength:(NSUInteger) arg1 
                    withString:(NSString *) arg2 
                startingAtIndex:(NSUInteger) arg3;
                
- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) arg1 
                                         withString:(NSString *) arg2 
                                            options:(NSUInteger) arg3 
                                              range:(NSRange) arg4;
                                    
- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) arg1 
                                         withString:(NSString *) arg2;
- (NSString *) stringByReplacingCharactersInRange:(NSRange) arg1 
                                       withString:(NSString *) arg2;

@end

