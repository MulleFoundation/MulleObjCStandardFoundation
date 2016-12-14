//
//  NSTimeZone.m
//  MulleObjCFoundation
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
