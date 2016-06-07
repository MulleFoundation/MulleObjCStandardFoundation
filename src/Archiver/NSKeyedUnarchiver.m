//
//  NSKeyedUnarchiver.m
//  MulleObjCFoundation
//
//  Created by Nat! on 20.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSKeyedUnarchiver.h"

// other files in this library
#import "MulleObjCArchiver+Private.h"
#include "mulle_buffer_archiver.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"


@interface MulleObjCUnarchiver ( Private)

- (struct blob *) _nextBlob;
- (id) _nextObject;

- (void *) _decodeValueOfObjCType:(char *) type
                               at:(void *) p;

@end


// std-c and dependencies
@implementation NSKeyedUnarchiver

- (instancetype) initForReadingWithData:(NSData *)data
{
   struct mulle_container_keycallback   callback;
   
   callback          = NSNonOwnedPointerMapKeyCallBacks;
   callback.hash     = (void *) blob_hash;
   callback.is_equal = (void *) blob_is_equal;
   callback.describe = (void *) blob_describe;

   _scope = _NSCreateMapTableWithAllocator( callback,
                              NSIntegerMapValueCallBacks,
                              16, MulleObjCObjectGetAllocator( self));
   return( [super initForReadingWithData:data]);
}


- (void) dealloc
{
   NSFreeMapTable( _scope);
   [super dealloc];
}


- (size_t) _offsetForKey:(NSString *) key
{
   size_t         offset;
   struct blob   blob;
   
   blob._storage = [key UTF8String];
   blob._length  = [key _UTF8StringLength] + 1;
   
   offset = (size_t) NSMapGet( _scope, &blob);
   return( offset);
}


- (BOOL) containsValueForKey:(NSString *) key
{
   return( [self _offsetForKey:key]  != 0);
}


- (id) decodeObject
{
   if( _inited)
      [NSException raise:NSInconsistentArchiveException
                  format:@"don't use decodeObject with NSKeyedUnarchiver"];
   
   return( [self _nextObject]);
}


#pragma mark -
#pragma mark xxx


- (id) _initObject:(id) obj
{
   size_t         offset;
   size_t         skip;
   struct blob    *blob;
   
   NSResetMapTable( _scope);
   
   // read in all keys now
   while( blob = (struct blob *) [self _nextBlob])
   {
      skip   = mulle_buffer_next_integer( &_buffer);
      
      offset = mulle_buffer_get_seek( &_buffer);
      NSMapInsert( _scope, blob, (void *) offset);

      mulle_buffer_set_seek( &_buffer, MULLE_BUFFER_SEEK_CUR, skip);
   }
   
   //   NSLog( @"%@", NSStringFromMapTable( _scope));
   
   return( [obj initWithCoder:self]);
}



- (void *) _decodeValueOfObjCType:(char *) type
                               at:(void *) p
                              key:(NSString *) key
{
   size_t   memo;
   size_t   offset;

   offset = [self _offsetForKey:key];
   if( ! offset)
      [NSException raise:NSInconsistentArchiveException
                  format:@"unknown key \"%@\"", key];
   
   memo = mulle_buffer_get_seek( &_buffer);
   mulle_buffer_set_seek( &_buffer, MULLE_BUFFER_SEEK_SET, offset);
   
   p = [self _decodeValueOfObjCType:type
                             at:p];
   mulle_buffer_set_seek( &_buffer, MULLE_BUFFER_SEEK_SET, memo);
   return( p);
}


- (void) decodeValueOfObjCType:(char *) type
                            at:(void *) p
                           key:(NSString *) key
{
   [self _decodeValueOfObjCType:type
                             at:p
                            key:key];
}


- (id) decodeObjectForKey:(NSString *) key
{
   id  obj;
   
   obj = nil;
   [self _decodeValueOfObjCType:@encode( id)
                             at:&obj
                            key:key];
   return( [obj autorelease]);
}



- (BOOL) decodeBoolForKey:(NSString *) key
{
   BOOL   value;
   
   [self _decodeValueOfObjCType:@encode( BOOL)
                             at:&value
                            key:key];
   return( value);
}


- (int) decodeIntForKey:(NSString *) key
{
   int   value;
   
   [self _decodeValueOfObjCType:@encode( int)
                             at:&value
                            key:key];
   return( value);
}


- (int32_t) decodeInt32ForKey:(NSString *) key
{
   int32_t   value;
   
   [self _decodeValueOfObjCType:@encode( int32_t)
                             at:&value
                            key:key];
   return( value);
}


- (int64_t) decodeInt64ForKey:(NSString *) key
{
   int64_t   value;
   
   [self _decodeValueOfObjCType:@encode( int64_t)
                             at:&value
                            key:key];
   return( value);
}


- (float) decodeFloatForKey:(NSString *) key
{
   float   value;
   
   [self _decodeValueOfObjCType:@encode( float)
                             at:&value
                            key:key];
   return( value);
}


- (double) decodeDoubleForKey:(NSString *) key
{
   double   value;
   
   [self _decodeValueOfObjCType:@encode( double)
                             at:&value
                            key:key];
   return( value);
}



- (void *) decodeBytesForKey:(NSString *) key
              returnedLength:(NSUInteger *) len_p
{
   size_t               memo;
   size_t               offset;
   struct blob          *blob;
   static struct blob   empty_blob;
   
   offset = [self _offsetForKey:key];
   if( ! offset)
      [NSException raise:NSInconsistentArchiveException
                  format:@"unknown key \"%@\"", key];
   
   memo = mulle_buffer_get_seek( &_buffer);
   mulle_buffer_set_seek( &_buffer, MULLE_BUFFER_SEEK_SET, offset);
   
   blob = [self _nextBlob];
   
   mulle_buffer_set_seek( &_buffer, MULLE_BUFFER_SEEK_SET, memo);

   // memory is owned by NSKeyedUnarchiver its OK
   if( ! blob)
      blob = &empty_blob;
   if( len_p)
      *len_p = blob->_length;
   
   return( blob->_storage);
}

@end
