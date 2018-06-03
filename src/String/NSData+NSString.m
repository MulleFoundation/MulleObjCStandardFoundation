//
//  NSData+NSString.m
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

#import "NSData.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies
#include <mulle-buffer/mulle-buffer.h>
#include <ctype.h>


@implementation NSData( NSString)

static inline unsigned int   hex( unsigned int c)
{
   assert( c >= 0 && c <= 0xf);
   return( c >= 0xa ? c + 'a' - 0xa : c + '0');
}

#define WORD_SIZE   4

- (NSString *) description
{
   NSUInteger               full_lines;
   NSUInteger               i;
   NSUInteger               j;
   NSUInteger               length;
   NSUInteger               lines;
   NSUInteger               remainder;
   mulle_utf8_t             *s;
   struct mulle_allocator   *allocator;
   struct mulle_buffer      buffer;
   unsigned char            *bytes;
   unsigned int             value;

   length = [self length];
   if( ! length)
      return( @"<>");

   bytes     = [self bytes];
   allocator = MulleObjCObjectGetAllocator( self);

   mulle_buffer_init( &buffer, allocator);

   mulle_buffer_add_string( &buffer, "<");

   lines      = (length + WORD_SIZE - 1) / WORD_SIZE;
   full_lines = length / WORD_SIZE;

   for( i = 0; i < full_lines; i++)
   {
      s = mulle_buffer_advance( &buffer, 2 * WORD_SIZE);
      for( j = 0;  j < WORD_SIZE; j++)
      {
         value = *bytes++;

         *s++ = (mulle_utf8_t) hex( value >> 4);
         *s++ = (mulle_utf8_t) hex( value & 0xF);
      }
      mulle_buffer_add_byte( &buffer, ' ');
   }

   if( i < lines)
   {
      remainder = length - (full_lines * WORD_SIZE);
      s = mulle_buffer_advance( &buffer, 2 * remainder);
      for( j = 0;  j < remainder; j++)
      {
         value = *bytes++;

         *s++ = (mulle_utf8_t) hex( value >> 4);
         *s++ = (mulle_utf8_t) hex( value & 0xF);
      }
   }
   else
      mulle_buffer_remove_last_byte( &buffer);

   mulle_buffer_add_byte( &buffer, '>');
   mulle_buffer_add_byte( &buffer, 0);

   length = mulle_buffer_get_length( &buffer);
   s      = mulle_buffer_extract_all( &buffer);
   mulle_buffer_done( &buffer);

   return( [NSString _stringWithUTF8CharactersNoCopy:s
                                              length:length
                                           allocator:allocator]);
}


- (NSString *) debugDescription
{
   NSUInteger               length;
   mulle_utf8_t             *s;
   struct mulle_allocator   *allocator;
   struct mulle_buffer      buffer;
   unsigned char            *bytes;

   length = [self length];
   if( ! length)
      return( @"<>");

   bytes     = [self bytes];
   allocator = MulleObjCObjectGetAllocator( self);

   mulle_buffer_init( &buffer, allocator);

   mulle_buffer_hexdump( &buffer, bytes, length, 0, 0);
   mulle_buffer_add_byte( &buffer, 0);

   length = mulle_buffer_get_length( &buffer);
   s      = mulle_buffer_extract_all( &buffer);

   mulle_buffer_done( &buffer);

   return( [NSString _stringWithUTF8CharactersNoCopy:s
                                              length:length
                                           allocator:allocator]);
}


@end
