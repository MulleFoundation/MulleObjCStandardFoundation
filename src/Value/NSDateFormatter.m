/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSDateFormatter.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSDateFormatter.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@implementation NSDateFormatter

static char  MulleObjCDefaultDateFormatterBehaviorKey;


- (id) initWithDateFormat:(NSString *) format 
     allowNaturalLanguage:(BOOL) flag
{
   _dateFormat            = [format copy];
   _allowsNaturalLanguage = flag;

   return( self);
}
    

static void   validate_behavior( NSDateFormatterBehavior behavior)
{
   if( behavior != NSDateFormatterBehaviorDefault && behavior != NSDateFormatterBehavior10_0)
      MulleObjCThrowInvalidArgumentException( @"unsupported behavior");
}


+ (void) setDefaultFormatterBehavior:(NSDateFormatterBehavior) behavior
{
   [self setClassValue:(void *) behavior
                forKey:&MulleObjCDefaultDateFormatterBehaviorKey];
}


+ (NSDateFormatterBehavior) defaultFormatterBehavior
{
   return( (NSDateFormatterBehavior) [self classValueForKey:&MulleObjCDefaultDateFormatterBehaviorKey]);
}


- (NSDate *) dateFromString:(NSString *) s
{
   abort();
}


- (NSString *) stringFromDate:(NSDate *) date
{
   abort();
}

@end

