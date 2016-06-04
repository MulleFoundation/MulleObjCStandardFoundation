/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSFormatter.h is a part of MulleFoundation
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


@class NSString;


@interface NSFormatter : NSObject

- (NSString *) editingStringForObjectValue:(id) obj;

- (BOOL) getObjectValue:(id *) obj 
              forString:(NSString *) s 
       errorDescription:(NSString **) error;
       
- (BOOL) isPartialStringValid:(NSString *) s 
             newEditingString:(NSString **) newString 
             errorDescription:(NSString **) error;
             
- (BOOL) isPartialStringValid:(NSString **) s_p
        proposedSelectedRange:(NSRange *) range_p
               originalString:(NSString *) origString 
        originalSelectedRange:(NSRange) origSelRange 
             errorDescription:(NSString **) error;
             
- (NSString *) stringForObjectValue:(id) obj;

@end

