/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSNumberFormatter.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSNumberFormatter.h"

// other files in this library
#import "NSNumber.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@class NSDecimalNumberHandler;

extern Class   __NS1000NumberFormatterClass;
extern Class   __NS1040NumberFormatterClass;


@implementation NSNumberFormatter

static NSString  *MulleObjCDefaultNumberFormatterBehaviorKey = @"MulleObjCDefaultNumberFormatterBehavior";


static void   validate_behavior( NSNumberFormatterBehavior behavior)
{
   if( behavior != NSNumberFormatterBehaviorDefault && behavior != NSNumberFormatterBehavior10_0)
      MulleObjCThrowInvalidArgumentException( @"unsupported behavior");
}


+ (NSNumberFormatterBehavior) defaultFormatterBehavior
{
   return( [[self classValueForKey:MulleObjCDefaultNumberFormatterBehaviorKey] unsignedIntegerValue]);
}


+ (void) setDefaultFormatterBehavior:(NSNumberFormatterBehavior) behavior
{
   validate_behavior( behavior);
   [self setClassValue:[NSNumber numberWithUnsignedInteger:behavior]
                forKey:MulleObjCDefaultNumberFormatterBehaviorKey];
}


- (void) _initDefaultValues
{
   _format            = @"";
   _positiveFormat    = _format;
   _negativeFormat    = _format;
   _decimalSeparator  = @".";
   _thousandSeparator = @",";
}


- (id) init
{
   [self _initDefaultValues];
   return( self);
}


- (void) dealloc
{
   [_format release];  // need to release nonnull manually
   [super dealloc];
}


- (void) setAllowsFloats:(BOOL) flag            {  _flags.allowsFloats = flag; }
- (void) setGeneratesDecimalNumbers:(BOOL) flag {  _flags.generatesDecimalNumbers = flag; }
- (void) setHasThousandSeparators:(BOOL) flag   {  _flags.hasThousandSeparators = flag; }
- (void) setLenient:(BOOL) flag   {  _flags.isLenient = flag; }

- (BOOL) allowsFloats              { return( _flags.allowsFloats); }
- (BOOL) generatesDecimalNumbers   { return( _flags.generatesDecimalNumbers); }
- (BOOL) hasThousandSeparators     { return( _flags.hasThousandSeparators); }
- (BOOL) isLenient                 { return( _flags.isLenient); }


- (void) setFormat:(NSString *) s              
{ 
   NSArray    *components;
   NSString   *zero;
   NSString   *plus;
   NSString   *minus;
   
   components = [s componentsSeparatedByString:@";"];
   switch( [components count])
   {
   case 1 : zero  = s;
            plus  = s;
            minus = s;
            break;

   case 2 : plus  = [components objectAtIndex:0];
            minus = [components objectAtIndex:1];
            zero  = @"0";
            break;
         
   case 3 : plus  = [components objectAtIndex:0];
            zero  = [components objectAtIndex:1];
            minus = [components objectAtIndex:2];
            break;
   default :
            MulleObjCThrowInvalidArgumentException( @"malformed");
   }
   
   _format = [zero copy];
   [self setPositiveFormat:zero];
   [self setNegativeFormat:zero];
}


- (NSNumber *) numberFromString:(NSString *) s
{     
   id  value;
   
   value = nil;
   [self getObjectValue:&value
              forString:s
       errorDescription:NULL];
   return( value);
}


- (NSString *) stringFromNumber:(NSNumber *) number
{     
   return( [self stringForObjectValue:number]);
}


- (void) setFormatterBehavior:(NSNumberFormatterBehavior) behavior
{
   validate_behavior( behavior);
retry:
   switch( behavior)
   {
   case NSNumberFormatterBehaviorDefault :  
      behavior = [[self class] defaultFormatterBehavior];
      if( behavior == NSNumberFormatterBehaviorDefault)
         behavior = NSNumberFormatterBehavior10_0;
      goto retry;
   case NSNumberFormatterBehavior10_0 :
   ;
   }
}

@end
