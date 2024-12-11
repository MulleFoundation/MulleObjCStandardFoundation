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
#import "NSError.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardContainerFoundation.h"
#import "MulleObjCStandardExceptionFoundation.h"
#import "MulleObjCStandardValueFoundation.h"
// std-c and dependencies



NSString  *MulleDateFormatISOWithMilliseconds = @"%Y-%m-%dT%H:%M:%S:%F%z";
NSString  *MulleDateFormatISO                 = @"%Y-%m-%dT%H:%M:%S%z";


@implementation NSDateFormatter


static struct
{
   mulle_thread_mutex_t      _lock;
   NSMapTable                *_table;
   NSDateFormatterBehavior   _defaultBehavior;
} Self =
{
   ._defaultBehavior = NSDateFormatterBehavior10_0
};


static inline void   SelfLock( void)
{
   mulle_thread_mutex_lock( &Self._lock);
}


static inline void   SelfUnlock( void)
{
   mulle_thread_mutex_unlock( &Self._lock);
}


+ (void) initialize
{
   if( ! Self._table)
   {
      Self._table = NSCreateMapTable( NSIntegerMapKeyCallBacks,
                                      NSObjectMapValueCallBacks,
                                      4);
      // _NSPosixDateFormatter will supply 10_0
      if( mulle_thread_mutex_init( &Self._lock))
      {
         fprintf( stderr, "%s could not get a mutex\n", __FUNCTION__);
         abort();
      }
   }
}

+ (void) deinitialize
{
   NSMapTable   *table;

   table = Self._table;
   if( table)
   {
      @autoreleasepool
      {
         // table will release values, reap them ASAP
         Self._table = NULL;
         NSFreeMapTable( table);
      }
      mulle_thread_mutex_done( &Self._lock);
   }
}


+ (void) setDefaultFormatterBehavior:(NSDateFormatterBehavior) behavior
{
   NSParameterAssert( behavior == NSDateFormatterBehavior10_0 ||
                      behavior == NSDateFormatterBehavior10_4);

   SelfLock();
   {
      Self._defaultBehavior = behavior;
   }
   SelfUnlock();
}


+ (NSDateFormatterBehavior) defaultFormatterBehavior
{
   NSDateFormatterBehavior   behavior;

   SelfLock();
   {
      behavior = Self._defaultBehavior;
   }
   SelfUnlock();
   return( behavior);
}


- (NSDateFormatterBehavior) formatterBehavior
{
   // subclasses override this
   return( NSDateFormatterBehaviorDefault);
}


- (void) setFormatterBehavior:(NSDateFormatterBehavior) formatterBehavior
{
   Class   cls;

   cls = [self class];
   if( formatterBehavior == NSDateFormatterBehaviorDefault)
      formatterBehavior = [cls defaultFormatterBehavior];

   SelfLock();
   {
      cls = NSMapGet( Self._table, (void *) formatterBehavior);
   }
   SelfUnlock();

   if( ! cls)
      MulleObjCThrowInternalInconsistencyException( @"No class for NSDateFormatterBehavior %d loaded", formatterBehavior);

   MulleObjCInstanceSetClass( self, cls);
}


+ (void) mulleSetClass:(Class) cls
  forFormatterBehavior:(NSDateFormatterBehavior) formatterBehavior
{
   SelfLock();
   {
      NSMapInsert( Self._table, (void *) formatterBehavior, cls);
      NSParameterAssert( cls == NSMapGet( Self._table, (void *) formatterBehavior));
   }
   SelfUnlock();
}


/*
 *
 */
- (instancetype) _initWithDateFormat:(NSString *) format
                allowNaturalLanguage:(BOOL) flag
{
   _dateClass             = [NSDate class];
   _allowsNaturalLanguage = flag;

   // don't set timeZone by default
   [self setDateFormat:format];

   return( self);
}


- (void) dealloc
{
   MulleObjCInstanceDeallocateMemory( self, _cformat);
   [_dateFormat release];

   [super dealloc];
}


- (instancetype) init
{
   // this is incompatible, os x uses an empty date format
   return( [self initWithDateFormat:MulleDateFormatISO // changed to %Y from %y
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



- (BOOL) generatesCalendarDates
{
   return( [(id) _dateClass isSubclassOfClass:[NSCalendarDate class]]);
}


- (void) setGeneratesCalendarDates:(BOOL) flag
{
   _dateClass = flag ? [NSCalendarDate class] : [NSDate class];
}


- (BOOL) getObjectValue:(id *) obj
              forString:(NSString *) string
       errorDescription:(NSString **) errorDescription
{
   NSError   *error;
   BOOL      flag;

   flag = [self getObjectValue:obj
                     forString:string
                         range:NULL
                         error:&error];
   if( errorDescription)
      *errorDescription = flag ? nil : [error description];
   return( flag);
}


- (NSString *) stringForObjectValue:(id) obj
{
   return( [self stringFromDate:obj]);
}

@end

