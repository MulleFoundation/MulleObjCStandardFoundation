/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSTimeZone.m is a part of MulleFoundation
 *
 *  Copyright (C)  2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSTimeZone.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationString.h"
#import "MulleObjCFoundationValue.h"

// std-c and dependencies


@interface _MulleObjCLocalTimeZone : NSTimeZone
@end


@implementation _MulleObjCLocalTimeZone

- (NSMethodSignature *) methodSignatureForSelector:(SEL) aSelector
{
   return( [super methodSignatureForSelector:@selector( self)]);
}


- (void) forwardInvocation:(NSInvocation *) anInvocation
{
   [anInvocation setTarget:[NSTimeZone defaultTimeZone]];
   [anInvocation invoke];
}


@end


@implementation NSTimeZone


+ (id) timeZoneWithName:(NSString *) name
{
   return( [[[self alloc] initWithName:name] autorelease]);
}
   
   
+ (id) timeZoneWithName:(NSString *) name 
                   data:(NSData *) data
{
   return( [[[self alloc] initWithName:name
                                  data:data] autorelease]);
}                   


- (id) initWithName:(NSString *) name 
               data:(NSData *) data;
{
   [self init];
   
   _name = [name copy];
   _data = [_data copy];
   
   return( self);
}


- (void) dealloc
{
   [_data release];
   [_name release];

   [super dealloc];
}
   

- (id) copy
{
   return( [self retain]);
}

#pragma mark -
#pragma mark convenience constructors


+ (id) timeZoneWithAbbreviation:(NSString *) key
{
   NSString  *name;
   
   name = [[self abbreviationDictionary] objectForKey:key];
   if( ! name)
      return( nil);
      
   return( [self timeZoneWithName:name]);
}


- (NSString *) name
{
   return( _name);
}


- (NSData *) data
{
   return( _data);
}


static NSString   *NSSystemTimeZoneKey  = @"NSSystemTimeZone";
static NSString   *NSDefaultTimeZoneKey = @"NSDefaultTimeZone";

+ (NSTimeZone *) systemTimeZone
{
   NSTimeZone   *timeZone;
   
   timeZone = [self classValueForKey:NSSystemTimeZoneKey];
   if( ! timeZone)
   {
      timeZone = [self _uncachedSystemTimeZone];
      [self setClassValue:timeZone
                   forKey:NSSystemTimeZoneKey];
   }
   return( timeZone);
}


+ (void) resetSystemTimeZone
{
   NSTimeZone   *timeZone;
   
   timeZone   = [self _uncachedSystemTimeZone];
   [self setClassValue:timeZone
                forKey:NSSystemTimeZoneKey];
}


+ (NSTimeZone *) defaultTimeZone
{
   NSTimeZone   *timeZone;
   
   timeZone = [self classValueForKey:NSDefaultTimeZoneKey];
   if( ! timeZone)
      timeZone = [self systemTimeZone];
   return( timeZone);
}


+ (void) setDefaultTimeZone:(NSTimeZone *) tz
{
   [self setClassValue:[[tz copy] autorelease]
                forKey:NSSystemTimeZoneKey];
}


+ (NSTimeZone *) localTimeZone
{
   // return a proxy
   return( [[_MulleObjCLocalTimeZone new] autorelease]);
}


- (BOOL) isEqualToTimeZone:(NSTimeZone *) tz
{
   if( ! tz)
      return( NO);
   return( [_data isEqualToData:[tz data]]);
}

@end
