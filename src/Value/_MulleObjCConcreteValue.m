//
//  _MulleObjCConcreteValue.m
//  MulleObjCFoundation
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteValue.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <string.h>


@implementation _MulleObjCConcreteValue

static void   *_MulleObjCConcreteValueBytes( _MulleObjCConcreteValue *self)
{
   return( &self->_size + 1);
}


static void   *_MulleObjCConcreteValueObjCType( _MulleObjCConcreteValue *self)
{
   return( &((char *) _MulleObjCConcreteValueBytes( self))[ self->_size]);
}


+ (id) valueWithBytes:(void *) bytes
             objCType:(char *) type
{
   _MulleObjCConcreteValue   *value;
   NSUInteger                extra;
   NSUInteger                size;
   size_t                    type_size;
   
   NSParameterAssert( type && *type);
   NSParameterAssert( bytes);

   NSGetSizeAndAlignment( type, &size, NULL);
   
   NSParameterAssert( size);
   
   type_size = strlen( type) + 1;
   extra     = size + type_size;
   
   value = NSAllocateObject( self, extra, NULL);
   
   value->_size = size;
   memcpy( _MulleObjCConcreteValueBytes( value), bytes, size);
   memcpy( _MulleObjCConcreteValueObjCType( value), type, type_size);
   
   return( [value autorelease]);
}


- (char *) objCType
{
   return( _MulleObjCConcreteValueObjCType( self));
}


- (NSUInteger) hash
{
   return( mulle_hash( _MulleObjCConcreteValueBytes( self), _size));
}


- (void) getValue:(void *) bytes
{
   memcpy( bytes, _MulleObjCConcreteValueBytes( self), _size);
}


- (void) getValue:(void *) bytes
             size:(NSUInteger) size
{
   if( size != _size)
      MulleObjCThrowInvalidArgumentException( @"size should be %ld bytes on this platform", _size);
   
   memcpy( bytes, _MulleObjCConcreteValueBytes( self), _size);
}

@end

