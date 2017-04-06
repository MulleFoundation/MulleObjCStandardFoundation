//
//  NSData.m
//  MulleObjCFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#define _GNUSOURCE   // UGLINESS for memmem and memrmem

#import "NSData.h"

// other files in this library
#import "_MulleObjCDataSubclasses.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#import <mulle_buffer/mulle_buffer.h>


#if MULLE_BUFFER_VERSION < ((0 << 20) | (4 << 8) | 1)
# error "mulle_buffer is too old"
#endif


@implementation NSObject ( _NSData)

- (BOOL) __isNSData
{
   return( NO);
}

@end


@implementation NSData

- (BOOL) __isNSData
{
   return( YES);
}


+ (id) data
{
   return( [[self new] autorelease]);
}


+ (id) dataWithBytes:(void *) buf
              length:(NSUInteger) length
{
   return( [[[self alloc] initWithBytes:buf
                                 length:length] autorelease]);
}


+ (id) dataWithBytesNoCopy:(void *) buf
                    length:(NSUInteger) length
{
   return( [[[self alloc] initWithBytesNoCopy:buf
                                       length:length] autorelease]);
}


+ (id) dataWithBytesNoCopy:(void *) buf
                    length:(NSUInteger) length
              freeWhenDone:(BOOL) flag
{
   return( [[[self alloc] initWithBytesNoCopy:buf
                                       length:length
                                 freeWhenDone:flag] autorelease]);
}


+ (id) dataWithData:(NSData *) data
{
   return( [[[self alloc] initWithData:data] autorelease]);
}


static NSData  *_newData( void *buf, NSUInteger length)
{
   switch( length)
   {
   case 0  : return( [_MulleObjCZeroBytesData newWithBytes:buf]);
   case 8  : return( [_MulleObjCEightBytesData newWithBytes:buf]);
   case 16 : return( [_MulleObjCSixteenBytesData newWithBytes:buf]);
   }

   if( length < 0x100 + 1)
      return( [_MulleObjCTinyData newWithBytes:buf
                                        length:length]);
   if( length < 0x10000 + 0x100 + 1)
      return( [_MulleObjCMediumData newWithBytes:buf
                                          length:length]);

   return( [_MulleObjCAllocatorData newWithBytes:buf
                                          length:length]);
}


#pragma mark -
#pragma mark class cluster stuff

- (id)  init
{
   [self release];
   return( _newData( 0, 0));
}


// since "self" is the placeholder, we don't really need to release it
- (id) initWithBytes:(void *) bytes
              length:(NSUInteger) length
{
   [self release];
   return( _newData( bytes, length));
}


- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
{
   [self release];
   return( [_MulleObjCAllocatorData newWithBytesNoCopy:bytes
                                                length:length
                                             allocator:&mulle_stdlib_allocator]);
}

- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
                 allocator:(struct mulle_allocator *) allocator
{
   [self release];
   return( [_MulleObjCAllocatorData newWithBytesNoCopy:bytes
                                                length:length
                                             allocator:allocator]);
}


- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
               freeWhenDone:(BOOL) flag
{
   struct mulle_allocator   *allocator;

   [self release];

   allocator = flag ? &mulle_stdlib_allocator: NULL;
   return( [_MulleObjCAllocatorData newWithBytesNoCopy:bytes
                                                length:length
                                             allocator:allocator]);
}


- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
                     owner:(id) owner
{
   [self release];

   return( [_MulleObjCSharedData newWithBytesNoCopy:bytes
                                             length:length
                                              owner:owner]);
}


- (id) initWithData:(id) other
{
   [self release];

   return( _newData( [other bytes], [other length]));
}


- (id) copy
{
   return( [self retain]);
}


#pragma mark -
#pragma mark common code

- (NSUInteger) hash
{
   long        length;
   char        *buf;
   char        *sentinel;
   uintptr_t   hash;

   length   = [self length];
   buf      = (char *) [self bytes];
   sentinel = &buf[ length > 0x400 ? 0x400 : length]; // touch at most a page

   // this hashes 4*32 bytes max
   hash = 0x1848;
   while( length > 32)
   {
      hash = mulle_chained_hash( buf, 32, hash);
      buf  = &buf[ 0x100];
      if( buf >= sentinel)
         return( (NSUInteger) hash);

      length -= 0x100;
   }

   // small and large data goes here
   hash = mulle_chained_hash( buf, length, hash);
   return( (NSUInteger) hash);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSData])
      return( NO);
   return( [self isEqualToData:other]);
}


- (void) getBytes:(void *) buf
{
   assert( buf);
   memcpy( buf, [self bytes], [self length]);
}


- (void) getBytes:(void *) buf
           length:(NSUInteger) length
{
   MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( NSMakeRange( 0, length), [self length]);
   // need assert
   memcpy( buf, [self bytes], length);
}


- (void) getBytes:(void *) buf
            range:(NSRange) range
{
   MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( range, [self length]);

   // need assert
   memcpy( buf, &((char *)[self bytes])[ range.location], range.length);
}


- (BOOL) isEqualToData:(NSData *) other
{
   NSUInteger   length;

   length = [other length];
   if( length != [self length])
      return( NO);
   return( ! memcmp( [self bytes], [other bytes], length));
}


- (id) subdataWithRange:(NSRange) range
{
   MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( range, [self length]);

   return( [NSData dataWithBytes:&((char *)[self bytes])[ range.location]
                           length:range.length]);
}


// layme brute forcer
static void   *mulle_memrmem( unsigned char *a, size_t a_len,
                              unsigned char *b, size_t b_len)
{
   unsigned char   *a_curr;
   unsigned char   first_b;

   a_curr  = &a[ a_len - b_len];
   first_b = *b;

   for( a_curr  = &a[ a_len - b_len]; a_curr >= a; --a_curr)
      if( *a_curr == first_b)
         if( ! memcmp( a_curr, b, b_len))
            return( a_curr);

   return( NULL);
}


- (NSRange) rangeOfData:(id) other
                options:(NSUInteger) options
                  range:(NSRange) range
{
   NSUInteger      length;
   NSUInteger      location;
   NSUInteger      other_length;
   unsigned char   *bytes;
   unsigned char   *found;
   unsigned char   *other_bytes;
   unsigned char   *start;

   length = [self length];
   if( range.location + range.length > length || range.length > length)
      MulleObjCThrowInvalidRangeException( range);

   other_length = [other length];
   length       = range.length;
   if( ! length || ! other_length || other_length > length)
      return( NSMakeRange( NSNotFound, 0));

   start       = [self bytes];
   bytes       = &start[ range.location];
   other_bytes = [other bytes];

   // easy
   if( options & NSDataSearchAnchored)
   {
      if( options & NSDataSearchBackwards)
      {
         location = length - other_length;
         if( ! memcmp( &bytes[ location], other_bytes, other_length))
            return( NSMakeRange( range.location + location, other_length));
      }
      else
      {
         if( ! memcmp( bytes, other_bytes, other_length))
            return( NSMakeRange( range.location, other_length));
      }
   }
   else
   {
      if( options & NSDataSearchBackwards)
      {
         found = mulle_memrmem( bytes, length, other_bytes, other_length);
         if( found)
            return( NSMakeRange( found - start, other_length));
      }
      else
      {
         found = memmem( bytes, length, other_bytes, other_length);
         if( found)
            return( NSMakeRange( found - start, other_length));
      }
   }

   return( NSMakeRange( NSNotFound, 0));
}


#pragma mark -
#pragma mark placeholder only

// for debug description
- (void *) bytes
{
   return( NULL);
}

- (NSUInteger) length
{
   return( 0);
}

@end
