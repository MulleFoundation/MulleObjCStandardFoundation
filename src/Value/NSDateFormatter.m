/*
 *  MulleFoundation - the mulle-objc class library
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
#import "NSDate.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"
#import "MulleObjCFoundationValue.h"

// std-c and dependencies


@implementation NSDateFormatter


NSString  *NSDateFormatter1000BehaviourClassKey = @"1000";
NSString  *NSDateFormatter1040BehaviourClassKey = @"1040";


static NSString  *MulleObjCDefaultDateFormatterBehaviorKey = @"MulleObjCDefaultDateFormatterBehavior";



- (id) _initWithDateFormat:(NSString *) format
     allowNaturalLanguage:(BOOL) flag
{
   _dateClass             = [NSDate class];
   _dateFormat            = [format copy];
   _allowsNaturalLanguage = flag;

   return( self);
}


- (id) init
{
   return( [self initWithDateFormat:@"%y-%m-%dT%H:%M:%SZ%z"
               allowNaturalLanguage:NO]);
}


- (id) initWithDateFormat:(NSString *) format
     allowNaturalLanguage:(BOOL) flag
{
   [self setFormatterBehavior:NSDateFormatterBehavior10_0];
   return( [self _initWithDateFormat:format
                allowNaturalLanguage:flag]);
}


static void   validate_behavior( NSDateFormatterBehavior behavior)
{
   if( behavior != NSDateFormatterBehaviorDefault && behavior != NSDateFormatterBehavior10_0)
      MulleObjCThrowInvalidArgumentException( @"unsupported behavior");
}


+ (void) setDefaultFormatterBehavior:(NSDateFormatterBehavior) behavior
{
   NSParameterAssert( behavior == NSDateFormatterBehavior10_0 ||
                      behavior == NSDateFormatterBehavior10_4);
   
   [self setClassValue:behavior == NSDateFormatterBehavior10_0 ?
                          NSDateFormatter1000BehaviourClassKey :
                          NSDateFormatter1040BehaviourClassKey
                forKey:MulleObjCDefaultDateFormatterBehaviorKey];
}


+ (NSDateFormatterBehavior) defaultFormatterBehavior
{
   NSString  *key;
   
   key = [self classValueForKey:MulleObjCDefaultDateFormatterBehaviorKey];
   if( key == NSDateFormatter1040BehaviourClassKey)
      return( NSDateFormatterBehavior10_4);
   if( key == NSDateFormatter1000BehaviourClassKey)
      return( NSDateFormatterBehavior10_0);
   return( NSDateFormatterBehaviorDefault);
}


- (BOOL) generateCalendarDates
{
   return( [_dateClass isSubclassOfClass:NSClassFromString( @"NSCalendarDate")]);
}


- (void) setGenerateCalendarDates:(BOOL) flag
{
   _dateClass = NSClassFromString( @"NSCalendarDate");
   if( ! _dateClass)
      MulleObjCThrowInvalidArgumentException( @"no NSCalendarDate class present");
}


- (NSDateFormatterBehavior) formatterBehavior
{
   return( NSDateFormatterBehaviorDefault);
}


- (void) setFormatterBehavior:(NSDateFormatterBehavior) formatterBehavior
{
   Class   cls;
   
   if( formatterBehavior == NSDateFormatterBehaviorDefault)
      formatterBehavior = [isa defaultFormatterBehavior];

   cls = Nil;
   switch( formatterBehavior)
   {
   case NSDateFormatterBehavior10_0  :
      cls = [isa classValueForKey:NSDateFormatter1000BehaviourClassKey];
      break;

   case NSDateFormatterBehavior10_4 :
      cls = [isa classValueForKey:NSDateFormatter1040BehaviourClassKey];
      break;
   }
   
   if( ! cls)
      MulleObjCThrowInternalInconsistencyException( @"no class for behaviour %d loaded", formatterBehavior);
   
   _mulle_objc_object_set_isa( self, cls);
}

@end


@implementation NSDate ( NSDateFormatter)

- (NSString *) description
{
   NSDateFormatter  *formatter;
   
   formatter = [[[NSDateFormatter alloc] init] autorelease];
   return( [formatter stringFromDate:self]);
}

@end

