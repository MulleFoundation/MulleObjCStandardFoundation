//
//  NSCharacterSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 04.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import <MulleObjC/MulleObjC.h>

#import <mulle_utf/mulle_utf.h>


@class NSData;

typedef mulle_utf32_t  unichar;


@interface NSCharacterSet : NSObject  < MulleObjCClassCluster>

- (NSData *) bitmapRepresentation;
- (BOOL) isSupersetOfSet:(NSCharacterSet *) set;
- (BOOL) longCharacterIsMember:(long) c;

+ (NSCharacterSet *) alphanumericCharacterSet;
+ (NSCharacterSet *) capitalizedLetterCharacterSet;
+ (NSCharacterSet *) controlCharacterSet;
+ (NSCharacterSet *) decimalDigitCharacterSet;
+ (NSCharacterSet *) decomposableCharacterSet;
+ (NSCharacterSet *) letterCharacterSet;
+ (NSCharacterSet *) lowercaseLetterCharacterSet;
+ (NSCharacterSet *) nonBaseCharacterSet;
+ (NSCharacterSet *) punctuationCharacterSet;
+ (NSCharacterSet *) symbolCharacterSet;
+ (NSCharacterSet *) uppercaseLetterCharacterSet;
+ (NSCharacterSet *) whitespaceAndNewlineCharacterSet;
+ (NSCharacterSet *) whitespaceCharacterSet;
+ (NSCharacterSet *) URLFragmentAllowedCharacterSet;
+ (NSCharacterSet *) URLHostAllowedCharacterSet;
+ (NSCharacterSet *) URLPasswordAllowedCharacterSet;
+ (NSCharacterSet *) URLPathAllowedCharacterSet;
+ (NSCharacterSet *) URLQueryAllowedCharacterSet;
+ (NSCharacterSet *) URLUserAllowedCharacterSet;

// mulle addition
+ (NSCharacterSet *) nonPercentEscapeCharacterSet;

@end


@interface NSCharacterSet( Subclasses)

- (BOOL) characterIsMember:(unichar) c;
- (BOOL) hasMemberInPlane:(NSUInteger) plane;
- (NSCharacterSet *) invertedSet;

@end
