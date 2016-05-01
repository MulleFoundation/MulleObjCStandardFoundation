//
//  NSKeyedArchiver.m
//  MulleObjCFoundation
//
//  Created by Nat! on 20.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSKeyedArchiver.h"

// other files in this library
#import "MulleObjCArchiver+Private.h"
#include "mulle_buffer_archiver.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@interface MulleObjCArchiver ( Private)

- (void) _appendBytes:(void *) bytes
               length:(size_t) len;

- (void *) _encodeValueOfObjCType:(char *) type
                               at:(void *) p;

@end


@implementation NSKeyedArchiver

- (void) _writeHeader
{
   mulle_buffer_add_bytes( &_buffer, "mulle-key-stream", 16);
   mulle_buffer_add_integer( &_buffer, [self systemVersion]); // archive version
}


- (void) _appendKey:(NSString *) key
{
   NSUInteger     length;
   mulle_utf8_t   *s;

   if( ! key)
      [NSException raise:NSInconsistentArchiveException
                  format:@"nil key is not acceptable"];
   
   s      = [key UTF8String];
   length = [key _UTF8StringLength] + 1;
   
   [self _appendBytes:s
               length:length];
}


- (void) encodeBytes:(void *) bytes
              length:(NSUInteger) len
              forKey:(NSString *) key
{
   struct mulle_buffer   memo;
   unsigned char         tmp[ 0x400];
   
   [self _appendKey:key];
   
   memo = _buffer;
   
   mulle_buffer_init_with_static_bytes( &_buffer,
                                       tmp, sizeof( tmp),
                                       mulle_buffer_get_allocator( &memo));
   [self _appendBytes:bytes
               length:len];
   
   mulle_buffer_add_integer( &memo, mulle_buffer_get_length( &_buffer));
   mulle_buffer_add_buffer( &memo, &_buffer);
   mulle_buffer_done( &_buffer);
   
   _buffer = memo;
}



- (void) encodeValueOfObjCType:(char *) type
                            at:(void *) p
                           key:(NSString *) key
{
   struct mulle_buffer   memo;
   unsigned char         tmp[ 0x400];
   
   [self _appendKey:key];
   
   memo = _buffer;
   
   mulle_buffer_init_with_static_bytes( &_buffer,
                                        tmp, sizeof( tmp),
                                        mulle_buffer_get_allocator( &memo));
   [self _encodeValueOfObjCType:type
                             at:p];
   
   mulle_buffer_add_integer( &memo, mulle_buffer_get_length( &_buffer));
   mulle_buffer_add_buffer( &memo, &_buffer);
   mulle_buffer_done( &_buffer);

   _buffer = memo;
}


- (void) encodeObject:(id) obj
{
   if( _objectHandle == 0)
      [self _encodeValueOfObjCType:@encode( id)
                                at:&obj];
   else
      [NSException raise:NSInconsistentArchiveException
                  format:@"don't use encodeObject: with NSKeyedArchiver"];
}


- (void) encodeObject:(id) obj
               forKey:(NSString *) key
{
   [self encodeValueOfObjCType:@encode( id)
                            at:&obj
                           key:key];
}


- (void) encodeConditionalObject:(id) obj
                          forKey:(NSString *) key
{
   static char  type[] = { _C_ASSIGN_ID };
      
   [self encodeValueOfObjCType:type
                            at:&obj
                           key:key];
}


- (void) encodeBool:(BOOL) value
             forKey:(NSString *) key
{
   [self encodeValueOfObjCType:@encode( BOOL)
                            at:&value
                           key:key];
}


- (void) encodeInt:(int) value
            forKey:(NSString *) key
{
   [self encodeValueOfObjCType:@encode( int)
                            at:&value
                           key:key];
}


- (void) encodeInt32:(int32_t) value
              forKey:(NSString *) key
{
   [self encodeValueOfObjCType:@encode( int32_t)
                            at:&value
                           key:key];
}


- (void) encodeInt64:(int64_t) value
              forKey:(NSString *) key
{
   [self encodeValueOfObjCType:@encode( int64_t)
                            at:&value
                           key:key];
}


- (void) encodeFloat:(float) value
              forKey:(NSString *) key
{
   [self encodeValueOfObjCType:@encode( float)
                            at:&value
                           key:key];
}


- (void) encodeDouble:(double) value
               forKey:(NSString *) key
{
   [self encodeValueOfObjCType:@encode( double)
                            at:&value
                           key:key];
}

@end
