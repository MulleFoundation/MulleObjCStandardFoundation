/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSFormatter.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSFormatter.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies



@implementation NSFormatter

- (NSString *) editingStringForObjectValue:(id) obj
{
   return( [obj description]);
}


- (BOOL) getObjectValue:(id *) obj 
              forString:(NSString *) s 
       errorDescription:(NSString **) error
{
   return( NO);
}       
    
          
- (BOOL) isPartialStringValid:(NSString *) s 
             newEditingString:(NSString **) newString 
             errorDescription:(NSString **) error
{
   return( NO);
}             
     
                     
- (BOOL) isPartialStringValid:(NSString **) s_p
        proposedSelectedRange:(NSRange *) range_p
               originalString:(NSString *) origString 
        originalSelectedRange:(NSRange) origSelRange 
             errorDescription:(NSString **) error
{
   *error = NULL;
   return( NO);
}             
    
                      
- (NSString *) stringForObjectValue:(id) obj
{
   return( [obj description]);
}

@end

