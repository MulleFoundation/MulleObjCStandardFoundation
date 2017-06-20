//
//  NSKeyedArchiver.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "NSKeyedArchiver.h"

// other files in this library
#import "MulleObjCArchiver+Private.h"
#include "mulle_buffer_archiver.h"

// other libraries of MulleObjCStandardFoundation
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
   NSUInteger   length;
   char         *s;

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

   fprintf( stderr, "key=%p\n", key);

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
   fprintf( stderr, "key=%p\n", key);
   fprintf( stderr, "obj=%p\n", obj);
   fprintf( stderr, "obj=%p\n", &obj);

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
