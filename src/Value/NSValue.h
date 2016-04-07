/*
 *  MulleFoundation - A tiny Foundation replacement
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



@interface NSValue : NSObject < MulleObjCClassCluster, NSCopying>
{
}

+ (id) value:(void *) bytes
withObjCType:(char *) type;
+ (id) valueWithBytes:(void *) bytes 
             objCType:(char *) type;
+ (id) valueWithPointer:(void *) pointer;
+ (id) valueWithRange:(NSRange) range;

- (BOOL) isEqual:(id) arg1;
- (BOOL) isEqualToValue:(id) arg1;

- (NSRange) rangeValue;
- (void *) pointerValue;

@end


@interface NSValue (Subclasses)

- (char *) objCType;
- (id) initWithBytes:(void *) bytes
            objCType:(char *) type;
- (void) getValue:(void *) bytes;

@end



