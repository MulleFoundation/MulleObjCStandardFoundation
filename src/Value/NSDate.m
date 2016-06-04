/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSDate.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSDate.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies
#include <time.h>


// compatible values
#define NSDistantFuture   63113904000.0
#define NSDistantPast    -63114076800.0


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


- (id) initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)seconds
{
   self->_interval = seconds;

   return( self);
}


# pragma mark -
# pragma mark NSCoding

- (id) initWithCoder:(NSCoder *) coder
{
   NSTimeInterval   value;
   
   [coder decodeValueOfObjCType:@encode( NSTimeInterval)
                             at:&value];
   return( [self initWithTimeIntervalSinceReferenceDate:value]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   [coder encodeValueOfObjCType:@encode( NSTimeInterval)
                             at:&_interval];
}


# pragma mark -
# pragma mark convenience constructors

+ (id) date
{  
   NSTimeInterval   seconds;
   
   seconds = time( NULL) + NSTimeIntervalSince1970;
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:seconds] autorelease]);
}


+ (id) dateWithTimeIntervalSince1970:(NSTimeInterval) seconds
{
   seconds -= NSTimeIntervalSince1970;
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:seconds] autorelease]);
}


+ (id) dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval) seconds
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:seconds] autorelease]);
}


// make these class clusters
+ (id) distantFuture
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:NSDistantFuture] autorelease]);
}


+ (id) distantPast
{
   return( [[[self alloc] initWithTimeIntervalSinceReferenceDate:NSDistantPast] autorelease]);
}



# pragma mark -
# pragma mark Various inits

- (id) initWithTimeInterval:(NSTimeInterval) seconds 
                  sinceDate:(NSDate *) refDate
{
   return( [self initWithTimeIntervalSinceReferenceDate:seconds - [refDate timeIntervalSinceReferenceDate]]);
}


- (id) initWithTimeIntervalSince1970:(NSTimeInterval) seconds
{
   return( [self initWithTimeIntervalSinceReferenceDate:seconds - NSTimeIntervalSince1970]);
}



# pragma mark -
# pragma mark Operations

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


- (id) dateByAddingTimeInterval:(NSTimeInterval) seconds
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


+ (NSTimeInterval) timeIntervalSinceReferenceDate
{
   // TODO: non optimal!
   return( time( NULL));
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

@end

