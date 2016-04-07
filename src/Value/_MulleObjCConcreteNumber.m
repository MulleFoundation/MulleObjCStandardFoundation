//
//  _MulleObjCConcreteNumber.m
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteNumber.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCIntegerNumber : NSNumber

- (id) initWithInteger:(NSInteger) value
{
   _value = value;
   return( self);
}


- (NSInteger) integerValue
{
   return( _value);
}


- (double) doubleValue
{
   return( (double) _value);
}


- (long long) longLongValue
{
   return( (long long) _value);
}


- (void) getValue:(void *) value
{
   *(NSInteger *) value = _value;
}


- (char *) objCType
{
   return( @encode( NSInteger));
}

@end



@implementation _MulleObjCLongLongNumber

- (id) initWithLongLong:(long long)value
{
   _value = value;
   return( self);
}


- (long long) longLongValue
{
   return( _value);
}


- (NSInteger) integerValue
{
   return( (NSInteger) _value);
}


- (double) doubleValue
{
   return( (double) _value);
}


- (void) getValue:(void *) value
{
   *(long long *) value = _value;
}


- (char *) objCType
{
   return( @encode( long long));
}

@end


@implementation _MulleObjCDoubleNumber : NSNumber

- (id) initWithDouble:(double) value
{
   _value = value;
   return( self);
}


- (double) doubleValue
{
   return( _value);
}


- (long long) longLongValue
{
   return( (long long) _value);
}


- (NSInteger) integerValue
{
   return( (NSInteger) _value);
}


- (void) getValue:(void *) value
{
   *(double *) value = _value;
}


- (char *) objCType
{
   return( @encode( double));
}

@end

