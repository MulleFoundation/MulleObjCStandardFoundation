//
//  NSString+Components.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  Copyright (c) 2020 Codeon GmbH.
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
#define _GNU_SOURCE   // UGLINESS for memmem and memrmem

#import "NSString+Components.h"

// std-c and other dependencies
#import "import-private.h"

#include <string.h>


@interface NSArray( DataComponents)

+ (instancetype) mulleArrayFromCData:(struct mulle_data) buf
                        pointerQueue:(struct mulle__pointerqueue *) pointers
                              stride:(NSUInteger) sepLen
                        factoryClass:(Class) factory
                       sharingObject:(id) sharingObject;

@end


@implementation NSArray( DataComponents)

+ (instancetype) mulleArrayFromCData:(struct mulle_data) buf
                        pointerQueue:(struct mulle__pointerqueue *) pointers
                              stride:(NSUInteger) sepLen
                        factoryClass:(Class) factory
                       sharingObject:(id) sharingObject
{
   NSArray                                *array;
   id                                     *dst;
   id                                     *objects;
   NSUInteger                             n;
   struct mulle__pointerqueueenumerator   rover;
   struct mulle_allocator                 *allocator;
   void                                   *p;
   void                                   *q;
   ptrdiff_t                              length;

   assert( buf.length >= 1);

   allocator = MulleObjCClassGetAllocator( self);
   n         = _mulle__pointerqueue_get_count( pointers) + 1;
   objects   = mulle_allocator_malloc( allocator, n * sizeof( id));
   dst       = objects;

   /* create strings for pointers make a little string of it and place it in
      strings array
     */
   p     = buf.bytes;
   rover = mulle__pointerqueue_enumerate( pointers);
   while( _mulle__pointerqueueenumerator_next( &rover, &q))
   {
      length  = q  - p;
      length -= sepLen;
      assert( (NSInteger) length >= 0);
      *dst++  = [(NSData *) [factory alloc] mulleInitWithBytesNoCopy:p
                                                              length:length
                                                       sharingObject:sharingObject];
      p       = q;
   }
   mulle__pointerqueueenumerator_done( &rover);

   q = &((char *) buf.bytes)[ buf.length];

   // can happen if there was not a trailing delimiter
   *dst++ = [[factory alloc] mulleInitWithBytesNoCopy:p
                                               length:q - p
                                        sharingObject:sharingObject];

   assert( dst - objects == n);
   array = [[[self alloc] mulleInitWithRetainedObjectStorage:objects
                                                       count:dst - objects
                                                        size:n] autorelease];
   return( array);
}

@end



@implementation NSData ( Components)

static void
   _mulleDataSeparateComponentsByCData( struct mulle_data data,
                                        struct mulle_data sepData,
                                        struct mulle__pointerqueue *pointers)
{
   char   *q;
   char   *found;
   char   *p;
   char   *sentinel;
   int    d;

   if( ! sepData.length)
      return;

   sentinel = &((char *) data.bytes)[ data.length];
   // Degenerate case @"." -> ( @"", @"")

   if( sepData.length == 1)
   {
      d = *(char *) sepData.bytes;
      for( p = data.bytes; p < sentinel;)
      {
         found = memchr( p, d, sentinel - p);
         if( ! found)
            break;

         p = found + 1;
         _mulle__pointerqueue_push( pointers, p, NULL);
      }
      return;
   }

   for( p = data.bytes; p < sentinel;)
   {
      found = memmem( p, sentinel - p, sepData.bytes, sepData.length);
      if( ! found)
         break;

      p = found + sepData.length;
      _mulle__pointerqueue_push( pointers, p, NULL);
   }
}


- (NSArray *) mulleComponentsSeparatedByData:(NSData *) separator
{
   struct mulle__pointerqueue   pointers;
   NSArray                      *array;
   NSUInteger                   sepLen;
   struct mulle_data            data;
   struct mulle_data            sepData;

   data    = [self mulleCData];
   sepData = [separator mulleCData];
   _mulle__pointerqueue_init( &pointers, 0x1000, 0);
   _mulleDataSeparateComponentsByCData( data,
                                            sepData,
                                            &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [NSArray mulleArrayFromCData:data
                                  pointerQueue:&pointers
                                        stride:sepData.length
                                  factoryClass:[NSData class]
                                 sharingObject:nil];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array ? array : [NSArray arrayWithObject:self]);
}

@end

