//
//  NSDate.m
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
#import "NSDate.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation NSObject( _NSDate)

- (BOOL) __isNSDate
{
   return( NO);
}

@end


@implementation NSDate

- (BOOL) __isNSDate
{
   return( YES);
}


- (instancetype) initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)seconds
{
   self->_interval = seconds;

   return( self);
}


# pragma mark -
# pragma mark convenience constructors


+ (instancetype) dateWithTimeIntervalSince1970:(NSTimeInterval) seconds
{
   seconds -= NSTimeIntervalSince1970;
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:seconds] autorelease]);
}


+ (instancetype) dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval) seconds
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:seconds] autorelease]);
}


// make these class clusters
+ (instancetype) distantFuture
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:_NSDistantFuture] autorelease]);
}


+ (instancetype) distantPast
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:_NSDistantPast] autorelease]);
}


# pragma mark -
# pragma mark Various inits

- (instancetype) initWithTimeInterval:(NSTimeInterval) seconds
                  sinceDate:(NSDate *) refDate
{
   return( [self initWithTimeIntervalSinceReferenceDate:seconds - [refDate timeIntervalSinceReferenceDate]]);
}


- (instancetype) initWithTimeIntervalSince1970:(NSTimeInterval) seconds
{
   return( [self initWithTimeIntervalSinceReferenceDate:seconds - NSTimeIntervalSince1970]);
}


- (NSComparisonResult) compare:(id) other
{
   NSTimeInterval  diff;

   if( ! other)
      return( NSOrderedDescending);

   diff = [self timeIntervalSinceReferenceDate] - [other timeIntervalSinceReferenceDate];
   if( diff < 0)
      return( NSOrderedAscending);
   if( diff > 0)
      return( NSOrderedDescending);
   return( NSOrderedSame);
}


- (instancetype) dateByAddingTimeInterval:(NSTimeInterval) seconds
{
   seconds += [self timeIntervalSinceReferenceDate];
   return( [[self class] dateWithTimeIntervalSinceReferenceDate:seconds]);
}


- (NSDate *) earlierDate:(NSDate *) other
{
   NSTimeInterval   diff;

   diff = [self timeIntervalSinceDate:other];  // according to dox
   if( diff < 0)
      return( self);
   return( other);
}


- (NSTimeInterval) timeIntervalSinceReferenceDate
{
   return( _interval);
}


- (NSTimeInterval) timeIntervalSinceDate:(NSDate *) other
{
   return( [self timeIntervalSinceReferenceDate] -
           [other timeIntervalSinceReferenceDate]);
}


- (NSTimeInterval) timeIntervalSince1970
{
   return( [self timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970);
}


#pragma mark - hash and equality

- (NSUInteger) hash
{
   return( mulle_hash( &self->_interval, sizeof( NSTimeInterval)));
}


- (BOOL) isEqualToDate:(NSDate *) other
{
   if( ! other)
      return( NO);

   return( [self timeIntervalSinceReferenceDate] == [other timeIntervalSinceReferenceDate]);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSDate])
      return( NO);

   // dunno yet
   //   if( ! [other __isNSCalendarDate])
   //      return( NO);
   return( [self isEqualToDate:other]);
}


- (id) copy
{
   return( [self retain]);
}

@end
