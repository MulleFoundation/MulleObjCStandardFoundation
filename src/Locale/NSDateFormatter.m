//
//  NSDateFormatter.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSDateFormatter.h"

// other files in this library
#import "NSLocale.h"
#import "NSTimeZone.h"
#import "NSCalendarDate.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"
#import "MulleObjCFoundationValue.h"

// std-c and dependencies


@implementation NSDateFormatter


NSString  *NSDateFormatter1000BehaviourClassKey = @"1000";
NSString  *NSDateFormatter1040BehaviourClassKey = @"1040";


static NSString  *MulleObjCDefaultDateFormatterBehaviorKey = @"MulleObjCDefaultDateFormatterBehavior";



- (instancetype) _initWithDateFormat:(NSString *) format
                allowNaturalLanguage:(BOOL) flag
{
   _dateClass             = [NSDate class];
   _dateFormat            = [format copy];
   _allowsNaturalLanguage = flag;

   return( self);
}


- (void) dealloc
{
   MulleObjCObjectDeallocateMemory( self, _cformat);
   [_dateFormat release];

   [super dealloc];
}


- (instancetype) init
{
   // this is incompatible, os x uses an empty date format
   return( [self initWithDateFormat:@"%y-%m-%dT%H:%M:%SZ%z"
               allowNaturalLanguage:NO]);
}


- (instancetype) initWithDateFormat:(NSString *) format
     allowNaturalLanguage:(BOOL) flag
{
   [self setFormatterBehavior:NSDateFormatterBehavior10_0];
   return( [self _initWithDateFormat:format
                allowNaturalLanguage:flag]);
}


//static void   validate_behavior( NSDateFormatterBehavior behavior)
//{
//   if( behavior != NSDateFormatterBehaviorDefault && behavior != NSDateFormatterBehavior10_0)
//      MulleObjCThrowInvalidArgumentException( @"unsupported behavior");
//}

+ (void) initialize
{
   static BOOL  doneOnce;

   if( doneOnce)
      return;
   doneOnce = YES;

   [self setDefaultFormatterBehavior:NSDateFormatterBehavior10_0];
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


- (NSDateFormatterBehavior) formatterBehavior
{
   return( NSDateFormatterBehaviorDefault);
}


- (void) setFormatterBehavior:(NSDateFormatterBehavior) formatterBehavior
{
   Class   cls;

   cls = [self class];
   if( formatterBehavior == NSDateFormatterBehaviorDefault)
      formatterBehavior = [cls defaultFormatterBehavior];

   switch( formatterBehavior)
   {
   case NSDateFormatterBehavior10_0  :
      cls = [cls classValueForKey:NSDateFormatter1000BehaviourClassKey];
      break;

   case NSDateFormatterBehavior10_4 :
      cls = [cls classValueForKey:NSDateFormatter1040BehaviourClassKey];
      break;

   default :
      cls = Nil;
      break;
   }

   if( ! cls)
      MulleObjCThrowInternalInconsistencyException( @"no class for NSDateFormatterBehavior %d loaded", formatterBehavior);

   MulleObjCSetClass( self, cls);
}


- (BOOL) generatesCalendarDates
{
   return( [(id) _dateClass isSubclassOfClass:[NSCalendarDate class]]);
}


- (void) setGeneratesCalendarDates:(BOOL) flag
{
   _dateClass = flag ? [NSCalendarDate class] : [NSDate class];
}

@end

