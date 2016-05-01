//
//  _MulleObjCConcreteBitmapCharacterSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 15.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteBitmapCharacterSet.h"

// other files in this library
#import "NSString.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCConcreteBitmapCharacterSet

static int   set_bit( uint32_t ** planes, int c)
{
   uint32_t       *bitmap;
   unsigned int   bindex;
   unsigned int   index;
   unsigned int   plane;

   plane  = c >> 16;
   index  = c >> 5;
   bindex = c & 0x1F;
   
   bitmap = planes[ plane];
   if( ! bitmap)
      return( -1);
   
   bitmap[ index] |= 1 << bindex;
   
   return( 0);
}


static int   get_bit( uint32_t ** planes, int c)
{
   uint32_t       *bitmap;
   uint32_t       word;
   unsigned int   bindex;
   unsigned int   index;
   unsigned int   plane;
   
   plane  = c >> 16;
   index  = c >> 5;
   bindex = c & 0x1F;
   
   bitmap = planes[ plane];
   if( ! bitmap)
      return( 0);
   
   word = bitmap[ index];
   word = word & (1 << bindex);
   
   return( word ? 1 : 0);
}


+ (id) newWithBitmapPlanes:(uint32_t **) planes
                    invert:(BOOL) invert
                 allocator:(struct mulle_allocator *)  allocator
                     owner:(id) owner
{
   _MulleObjCConcreteBitmapCharacterSet   *obj;
   NSUInteger                             i;
   
   obj = NSAllocateObject( self, 0, NULL);
   
   for( i = 0; i <= 0x10; i++)
      obj->_planes[ i] = planes[ i];
   
   obj->_rval      = invert ? 0 : 1;
   obj->_allocator = allocator;
   obj->_owner     = [owner retain];
   
   return( obj);
}


+ (id) newWithString:(NSString *) s
{
   _MulleObjCConcreteBitmapCharacterSet   *obj;
   NSUInteger                             i, n;
   unichar                                c;
   unsigned int                           plane;
   
   obj = NSAllocateObject( self, 0, NULL);

   obj->_allocator = MulleObjCClassGetAllocator( self);
   obj->_rval      = 1;

   n = [s length];
   for( i = 0; i < n; i++)
   {
      c = [s characterAtIndex:i];
      if( set_bit( obj->_planes, c))
      {
         plane  = c >> 16;
         obj->_planes[ plane] = mulle_allocator_calloc( obj->_allocator, 1, 8192);
         set_bit( obj->_planes, c);
      }
   }
   
   return( obj);
}


- (void) dealloc
{
   unsigned int  i;
   
   [_owner release];
   
   if( _allocator)
      for( i = 0; i <= 0x10; i++)
         mulle_allocator_free( _allocator, _planes[ i]);
   
   [super dealloc];
}


- (BOOL) characterIsMember:(unichar) c
{
   int            bit;
   
   bit = get_bit( _planes, c);
   return( _rval == bit);
}


- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   return( _planes[ plane] != NULL);
}


- (void) getBitmapBytes:(unsigned char *) bytes
                  plane:(unsigned int) plane
{
   if( _planes[ plane])
      memcpy( bytes, _planes[ plane], 8192);
   else
      memset( bytes, 0, 8192);
}


- (NSCharacterSet *) invertedSet
{
   return( [[_MulleObjCConcreteBitmapCharacterSet newWithBitmapPlanes:_planes
                                                              invert:_rval
                                                           allocator:NULL
                                                               owner:self] autorelease]);
}

@end
