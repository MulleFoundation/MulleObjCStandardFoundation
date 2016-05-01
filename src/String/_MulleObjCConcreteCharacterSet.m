//
//  _MulleObjCConcreteCharacterSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 15.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteCharacterSet.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCConcreteCharacterSet

+ (id) newWithMemberFunction:(int (*)( unichar)) f
               planeFunction:(int (*)( unsigned int)) plane_f
                      invert:(BOOL) invert
{
   _MulleObjCConcreteCharacterSet   *obj;
   
   // known to be all zeroed out(!) important!
   obj           = NSAllocateObject( self, 0, NULL);
   obj->_f       = f;
   obj->_plane_f = plane_f;
   obj->_rval    = invert ? 0 : 1;
   return( obj);
}


- (BOOL) characterIsMember:(unichar) c
{
   return( (*_f)( c) == _rval);
}


- (BOOL) longCharacterIsMember:(long) c
{
   return( (*_f)( (unichar) c) == _rval);
}


- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   return( (*_plane_f)( (unsigned int) plane) == _rval);
}


- (NSCharacterSet *) invertedSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:_f
                                                    planeFunction:_plane_f
                                                           invert:_rval] autorelease]);
}


- (void) getBitmapBytes:(unsigned char *) bytes
                  plane:(unsigned int) plane
{
   mulle_utf32_t   c;
   mulle_utf32_t   end;
   
   c   = plane * 0x10000;
   end = c + 0x10000;
   for( ; c < end; c += 8)
   {
      *bytes++ = (unsigned char)
       (((*_f)(c + 0) << 0) |
        ((*_f)(c + 1) << 1) |
        ((*_f)(c + 2) << 2) |
        ((*_f)(c + 3) << 3) |
        ((*_f)(c + 4) << 4) |
        ((*_f)(c + 5) << 5) |
        ((*_f)(c + 6) << 6) |
        ((*_f)(c + 7) << 7));
   }
}

@end
