//
//  NSArray+StringComponents.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
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
#import "import-private.h"

#import "NSArray+StringComponents.h"

#import <MulleObjCValueFoundation/_MulleObjCValueTaggedPointer.h>
#import <MulleObjCValueFoundation/NSString+Substring-Private.h>
#import <MulleObjCValueFoundation/_MulleObjCTaggedPointerChar5String.h>
#import <MulleObjCValueFoundation/_MulleObjCTaggedPointerChar7String.h>
#import <MulleObjCValueFoundation/_MulleObjCASCIIString.h>
#import <MulleObjCValueFoundation/_MulleObjCUTF16String.h>
#import <MulleObjCValueFoundation/_MulleObjCUTF32String.h>

#include <assert.h>


@implementation NSArray( StringComponents)


typedef NSString   *(*MakeStringFunction)( void *start,
                                           void **end,
                                           struct _MulleStringContext *ctxt);

// We get:
//       pointers[0]
//      /
//     / / pointers[1]
//    v v
//  a,b,c
//  ^
//  \---- buf.bytes, buf.length = 5
//
// sepLen = is delimiter size, or -1 for UTF8 meaning one UTF character
//
+ (instancetype) mulleArrayFromData:(struct mulle_data) buf
               createStringFunction:(MakeStringFunction) makeString
                       pointerQueue:(struct mulle__pointerqueue *) pointers
                             stride:(NSUInteger) sepLen
                      sharingObject:(id) object
{
   NSArray                                *array;
   NSString                               **dst;
   NSString                               **strings;
   NSUInteger                             nStrings;
   struct _MulleStringContext             ctxt;
   struct mulle__pointerqueueenumerator   rover;
   struct mulle_allocator                 *allocator;
   void                                   *p;
   void                                   *q;

   assert( buf.length >= 1);

   allocator = MulleObjCClassGetAllocator( self);
   nStrings  = _mulle__pointerqueue_get_count( pointers) + 1;
   strings   = mulle_allocator_malloc( allocator, nStrings * sizeof( NSString *));
   dst       = strings;

   ctxt.stringClass   = [NSString class];
   ctxt.sharingObject = object;
   ctxt.sepLen        = sepLen;

   /* create strings for pointers make a little string of it and place it in
      strings array
     */
   p     = buf.bytes;
   rover = mulle__pointerqueue_enumerate( pointers);
   while( _mulle__pointerqueueenumerator_next( &rover, &q))
   {
      assert( (char *) q >= (char *) p);
      *dst++ = (*makeString)( p, q, &ctxt);
      p      = q;
   }
   mulle__pointerqueueenumerator_done( &rover);

   q      = &((char *) buf.bytes)[ buf.length];
   // can happen if there was not trailing delimiter
   ctxt.sepLen = 0;
   *dst++ = (*makeString)( p, q, &ctxt);

   assert( dst - strings == nStrings);
   array = [[[self alloc] mulleInitWithRetainedObjectStorage:strings
                                                       count:dst - strings
                                                        size:nStrings] autorelease];
   return( array);
}


+ (instancetype) _mulleArrayFromASCIIData:(struct mulle_asciidata) buf
                             pointerQueue:(struct mulle__pointerqueue *) pointers
                                   stride:(NSUInteger) stride
                            sharingObject:(id) object
{
   return( [self mulleArrayFromData:mulle_data_make( buf.characters, buf.length)
               createStringFunction:(MakeStringFunction) _mulleNewASCIIStringWithStringContext
                       pointerQueue:pointers
                             stride:stride
                      sharingObject:object]);
}


+ (instancetype) mulleArrayFromUTF8Data:(struct mulle_utf8data) buf
                           pointerQueue:(struct mulle__pointerqueue *) pointers
                                 stride:(NSUInteger) stride
                          sharingObject:(id) object
{
   return( [self mulleArrayFromData:mulle_data_make( buf.characters, buf.length)
               createStringFunction:(MakeStringFunction) _mulleNewUTF8StringWithStringContext
                       pointerQueue:pointers
                             stride:stride
                      sharingObject:object]);
}



// just the same for utf16, but must be utf_15 bit clean
+ (instancetype) _mulleArrayFromUTF16Data:(struct mulle_utf16data) buf
                             pointerQueue:(struct mulle__pointerqueue *) pointers
                                   stride:(NSUInteger) stride
                            sharingObject:(id) object
{
   return( [self mulleArrayFromData:mulle_data_make( buf.characters,
                                                     buf.length * sizeof( mulle_utf16_t))
               createStringFunction:(MakeStringFunction) _mulleNewUTF16StringWithStringContext
                       pointerQueue:pointers
                             stride:stride
                      sharingObject:object]);
}


+ (instancetype) mulleArrayFromUTF32Data:(struct mulle_utf32data) buf
                            pointerQueue:(struct mulle__pointerqueue *) pointers
                                  stride:(NSUInteger) stride
                           sharingObject:(id) object
{
   return( [self mulleArrayFromData:mulle_data_make( buf.characters,
                                                     buf.length * sizeof( mulle_utf32_t))
               createStringFunction:(MakeStringFunction) _mulleNewUTF32StringWithStringContext
                       pointerQueue:pointers
                             stride:stride
                      sharingObject:object]);
}

@end
