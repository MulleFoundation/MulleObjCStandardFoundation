//
//  _MulleObjCConcreteCalendarDate.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2021 Nat! - Mulle kybernetiK.
//  Copyright (c) 2021 Codeon GmbH.
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
#import "_MulleObjCConcreteCalendarDate.h"

#import "import-private.h"


#import "NSTimeZone.h"


@implementation _MulleObjCConcreteCalendarDate

+ (instancetype) newWithMiniTM:(struct mulle_mini_tm) tm
                      timeZone:(NSTimeZone *) tz
{
   _MulleObjCConcreteCalendarDate  *obj;

   obj             = NSAllocateObject( self, 0, NULL);
   obj->_tm.values = tm;
   if( ! tz)
      tz = [NSTimeZone defaultTimeZone];
   obj->_timeZone = [tz retain];
   return( obj);
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void) dealloc
{
   [_timeZone release];
   NSDeallocateObject( self);
}
#pragma clang diagnostic pop


#pragma mark - accessors

- (struct mulle_mini_tm) mulleMiniTM
{
   return( _tm.values);
}


- (NSInteger) secondOfMinute
{
   return( self->_tm.values.second);
}


- (NSInteger) minuteOfHour
{
   return( self->_tm.values.minute);
}


- (NSInteger) hourOfDay
{
   return( self->_tm.values.hour);
}


- (NSInteger) dayOfMonth
{
   return( self->_tm.values.day);
}


- (NSInteger) monthOfYear
{
   return( self->_tm.values.month);
}


- (NSInteger) yearOfCommonEra
{
   return( self->_tm.values.year);
}


- (NSTimeZone *) timeZone
{
   return( self->_timeZone);
}


// we keep -hash and -isEqual from NSDate:
// we could just call isEqual: and maybe we should ?
- (BOOL) isEqualToCalendarDate:(NSCalendarDate *) otherDate
{
   NSTimeZone   *timeZone;
   NSTimeZone   *otherTimeZone;
   NSTimeZone   *gmtTimeZone;

   if( ! mulle_mini_tm_equal_tm( self->_tm.values, [otherDate mulleMiniTM]))
      return( NO);

   timeZone      = self->_timeZone;
   otherTimeZone = [otherDate timeZone];
   if( timeZone == otherTimeZone)
      return( YES);

   if( ! timeZone || ! otherTimeZone)
   {
      gmtTimeZone   = [NSTimeZone mulleGMTTimeZone];
      timeZone      = timeZone      ? timeZone      : gmtTimeZone;
      otherTimeZone = otherTimeZone ? otherTimeZone : gmtTimeZone;
   }

   return( [timeZone isEqualToTimeZone:otherTimeZone]);
}


@end
