/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSValue.h is a part of MulleFoundation
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



@interface NSValue : NSObject < MulleObjCClassCluster, NSCoding>
{
}

+ (id) value:(void *) bytes
withObjCType:(char *) type;
+ (id) valueWithBytes:(void *) bytes 
             objCType:(char *) type;
+ (id) valueWithPointer:(void *) pointer;
+ (id) valueWithRange:(NSRange) range;

- (id) initWithBytes:(void *) value
            objCType:(char *) type;

- (BOOL) isEqual:(id) other;
- (BOOL) isEqualToValue:(id) other;

- (NSRange) rangeValue;
- (void *) pointerValue;

@end


@interface NSValue (Subclasses)

- (char *) objCType;
- (id) initWithBytes:(void *) bytes
            objCType:(char *) type;
- (void) getValue:(void *) bytes;

@end



