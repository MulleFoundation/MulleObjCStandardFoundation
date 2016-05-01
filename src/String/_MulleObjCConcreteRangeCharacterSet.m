//
//  _MulleObjCConcreteRangeCharacterSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 15.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteRangeCharacterSet.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCConcreteRangeCharacterSet

+ (id) newWithRange:(NSRange) range
             invert:(BOOL) invert;
{
   _MulleObjCConcreteRangeCharacterSet   *obj;
   
   // known to be all zeroed out(!) important!
   obj           = NSAllocateObject( self, 0, NULL);
   obj->_range   = range;
   obj->_rval    = invert ? 0 : 1;
   return( obj);
}


- (BOOL) characterIsMember:(unichar) c
{
   return( NSLocationInRange( c, _range) == _rval);
}


- (BOOL) longCharacterIsMember:(long) c
{
   return( NSLocationInRange( c, _range)  == _rval);
}


- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   NSRange   planeRange;
   
   planeRange.location = plane * 0x10000;
   planeRange.length   = 0x10000;
   return( (NSIntersectionRange( _range, planeRange).length != 0) == _rval);
}


- (NSCharacterSet *) invertedSet
{
   return( [[_MulleObjCConcreteRangeCharacterSet newWithRange:_range
                                                       invert:_rval] autorelease]);
}

@end
