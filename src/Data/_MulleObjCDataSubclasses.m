/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _MulleObjCDataSubclasses.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCDataSubclasses.h"



@implementation _MulleObjCConcreteData

+ (id) newWithBytes:(void *) bytes
{
   _MulleObjCZeroBytesData   *data;

   data = NSAllocateObject( self, 0, NULL);
   return( data);
}

static inline void   *get_bytes( id self)
{
   return( self);
}

- (void *) bytes
{
   return( get_bytes( self));
}

- (void) dealloc
{
   NSDeallocateObject( self);
}

@end


@implementation _MulleObjCZeroBytesData

- (NSUInteger) length { return( 0); }

@end


@implementation _MulleObjCEightBytesData

+ (id) newWithBytes:(void *) bytes
{
   _MulleObjCEightBytesData   *data;
   
   data = NSAllocateObject( self, 8, NULL);
   memcpy( get_bytes( data), bytes, 8);
   return( data);
}

- (NSUInteger) length { return( 8); }

@end


@implementation _MulleObjCSixteenBytesData

+ (id) newWithBytes:(void *) bytes
{
   _MulleObjCSixteenBytesData   *data;
   
   data = NSAllocateObject( self, 16, NULL);
   memcpy( get_bytes( data), bytes, 16);
   return( data);
}

- (NSUInteger) length { return( 16); }

@end


@implementation _MulleObjCAllocatorData

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length
{
   _MulleObjCAllocatorData   *data;
   
   data = NSAllocateObject( self, 0, NULL);
   
   data->_storage   = MulleObjCAllocateNonZeroedMemory( length);
   data->_length    = length;
   data->_allocator = MulleObjCClassGetAllocator( self);

   memcpy( data->_storage, bytes, length);

   return( data);
}


+ (id) newWithBytesNoCopy:(void *) bytes
                   length:(NSUInteger) length
                allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorData   *data;
   
   data = NSAllocateObject( self, 0, NULL);
   
   data->_storage   = bytes;
   data->_length    = length;
   data->_allocator = allocator;
   
   return( data);
}


- (void *) bytes
{
   return( _storage);
}


- (NSUInteger) length
{
   return( _length);
}


- (void) dealloc
{
   if( _allocator)
      mulle_allocator_free( _allocator, _storage);
   NSDeallocateObject( self);
}

@end



@implementation _MulleObjCSharedData

+ (id) newWithBytesNoCopy:(void *) bytes
                       length:(NSUInteger) length
                        owner:(id) owner
{
   _MulleObjCSharedData   *data;
   
   data = [self newWithBytesNoCopy:bytes
                                length:length
                             allocator:NULL];
   data->_other = [owner retain];

   return( data);
}


- (void) dealloc
{
   [_other release];
   [super dealloc];
}

@end


@implementation _MulleObjCTinyData

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length
{
   _MulleObjCTinyData   *data;
   NSUInteger            extra;
   
   assert( length >= 1 && length <= 256);
   
   extra = length > 3 ? length - 3 : 0;

   data = NSAllocateObject( self, extra, NULL);
   memcpy( data->_storage, bytes, length);
   data->_length = (unsigned char) (length - 1);

   return( data);
}


- (void *) bytes
{
   return( _storage);
}


- (NSUInteger) length
{
   return( _length + 1);
}

@end


@implementation _MulleObjCMediumData

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length
{
   _MulleObjCMediumData   *data;
   
   assert( length >= 0x101 && length <= 0x10100);
   
   data = NSAllocateObject( self, length - 2, NULL);

   memcpy( data->_storage, bytes, length);
   data->_length = (uint16_t) (length - 0x100 - 1);
   
   return( data);
}


- (void *) bytes
{
   return( _storage);
}


- (NSUInteger) length
{
   return( _length + 0x100 + 1);
}

@end

