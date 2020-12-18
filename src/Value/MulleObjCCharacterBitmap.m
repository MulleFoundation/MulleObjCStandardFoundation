//
//  MulleObjCCharacterBitmap.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2019 Nat! - Mulle kybernetiK.
//  Copyright (c) 2019 Codeon GmbH.
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
#import "MulleObjCCharacterBitmap.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


#define N_PLANES     0x11
#define N_PLANEBITS  0x10000
#define N_BYTES      (N_PLANEBITS / 8)
#define N_WORDS      (N_BYTES / sizeof( uint32_t))
#define MAX_C        (N_PLANES * N_PLANEBITS)


static int   mulle_memop2_32( uint32_t *dst,
                              uint32_t *src,
                              size_t length,
                              enum MulleObjCCharacterBitmapLogicOpcode operation)
{
   uint32_t   *p;
   uint32_t   *q;
   uint32_t   *sentinel;
   uint32_t   bits;

   bits     = 0;
   p        = dst;
   q        = src;
   sentinel = &p[ length];

   switch( operation)
   {
   case MulleObjCCharacterBitmapAND  : while( p < sentinel) { bits |= (*p &= *q);         p++; q++; } break;
   case MulleObjCCharacterBitmapNAND : while( p < sentinel) { bits |= (*p = ~ (*p & *q)); p++; q++; } break;
   case MulleObjCCharacterBitmapOR   : while( p < sentinel) { bits |= (*p |= *q);         p++; q++; } break;
   case MulleObjCCharacterBitmapNOR  : while( p < sentinel) { bits |= (*p = ~ (*p | *q)); p++; q++; } break;
   }

   return( (int) bits);
}


static int   mulle_meminvert_32( uint32_t *buf, size_t length)
{
   uint32_t   *p;
   uint32_t   *sentinel;
   uint32_t   bits;

   bits     = 0;
   p        = buf;
   sentinel = &p[ length];
   while( p < sentinel)
   {
      bits |= (*p = ~*p);
      ++p;
   }

   return( (int) bits);
}


static uint32_t   *mulle_memany_32( uint32_t *buf, size_t length)
{
   uint32_t   *p;
   uint32_t   *sentinel;

   p        = buf;
   sentinel = &p[ length];
   while( p < sentinel)
   {
      if( *p)
         return( p);
      ++p;
   }

   return( NULL);
}


static BOOL  MulleObjCCharacterBitmapPlaneContainsOnlyZeroes( struct MulleObjCCharacterBitmap *p,
                                                              unsigned int plane)
{
   uint32_t   *bitmap;

   assert( p);
   assert( plane < N_PLANES);

   bitmap = p->planes[ plane];
   if( ! bitmap)
      return( NO);

   return( mulle_memany_32( bitmap, N_WORDS) ? NO : YES);
}


static void   MulleObjCCharacterBitmapRemoveUnusedPlanes( struct MulleObjCCharacterBitmap *p,
                                                          struct mulle_allocator *allocator)
{
   unsigned int   i;

   assert( p);
   assert( allocator);

   for( i = 0; i < N_PLANES; i++)
      if( MulleObjCCharacterBitmapPlaneContainsOnlyZeroes( p, i))
      {
         mulle_allocator_free( allocator, p->planes[ i]);
         p->planes[ i] = NULL;
      }
}


int   MulleObjCCharacterBitmapGetBit( struct MulleObjCCharacterBitmap *p,
                                      unsigned int c)
{
   uint32_t       *bitmap;
   uint32_t       word;
   unsigned int   bindex;
   unsigned int   index;
   unsigned int   plane;
   unsigned int   d;

   assert( p);

   plane = c >> 16;
   if( plane >= N_PLANES)
      return( 0);

   bitmap = p->planes[ plane];
   if( ! bitmap)
      return( 0);

   d      = c & 0xFFFF;
   index  = d >> 5;
   bindex = d & 0x1F;
   word   = bitmap[ index];
   word   = word & (1 << bindex);

   return( word ? 1 : 0);
}


static void   MulleObjCCharacterBitmapClearBit( struct MulleObjCCharacterBitmap *p,
                                                unsigned int c)
{
   uint32_t       *bitmap;
   unsigned int   bindex;
   unsigned int   index;
   unsigned int   plane;
   unsigned int   d;

   assert( p);
   assert( c < MAX_C);

   plane  = c >> 16;
   bitmap = p->planes[ plane];
   if( bitmap)
   {
      d      = c & 0xFFFF;
      index  = d >> 5;
      bindex = d & 0x1F;
      bitmap[ index] &= ~(1 << bindex);
   }
}


static int   MulleObjCCharacterBitmapSetBit( struct MulleObjCCharacterBitmap *p,
                                             unsigned int c)
{
   uint32_t       *bitmap;
   unsigned int   bindex;
   unsigned int   index;
   unsigned int   plane;
   unsigned int   d;

   assert( p);
   assert( c < MAX_C);

   plane  = c >> 16;
   bitmap = p->planes[ plane];
   if( ! bitmap)
      return( -1);

   d      = c & 0xFFFF;
   index  = d >> 5;
   bindex = d & 0x1F;

   bitmap[ index] |= 1 << bindex;

   return( 0);
}


void   MulleObjCCharacterBitmapSetBitsWithString( struct MulleObjCCharacterBitmap *p,
                                                  NSString *s,
                                                  struct mulle_allocator *allocator)
{
   unsigned int   i, n;
   unichar        c;
   unsigned int   plane;

   assert( p);
   assert( allocator);

   n = [s length];
   for( i = 0; i < n; i++)
   {
      c = [s characterAtIndex:i];
      if( MulleObjCCharacterBitmapSetBit( p, c))
      {
         plane             = c >> 16;
         p->planes[ plane] = mulle_allocator_calloc( allocator, 1, N_BYTES);
         MulleObjCCharacterBitmapSetBit( p, c);
      }
   }
}


void   MulleObjCCharacterBitmapClearBitsWithString( struct MulleObjCCharacterBitmap *p,
                                                    NSString *s,
                                                    struct mulle_allocator *allocator)
{
   NSUInteger     i, n;
   unichar        c;
   unsigned int   plane;

   assert( p);
   assert( allocator);

   n = [s length];
   for( i = 0; i < n; i++)
   {
      c = [s characterAtIndex:i];
      MulleObjCCharacterBitmapClearBit( p, c);
   }

   MulleObjCCharacterBitmapRemoveUnusedPlanes( p, allocator);
}


void   MulleObjCCharacterBitmapSetBitsInRange( struct MulleObjCCharacterBitmap *p,
                                               NSRange range,
                                               struct mulle_allocator *allocator)
{
   int   plane;

   assert( p);
   assert( allocator);

   while( range.length--)
   {
      if( MulleObjCCharacterBitmapSetBit( p, range.location))
      {
         plane             = range.location >> 16;
         p->planes[ plane] = mulle_allocator_calloc( allocator, 1, N_BYTES);
         MulleObjCCharacterBitmapSetBit( p, range.location);
      }
      range.location++;
   }
}


void   MulleObjCCharacterBitmapClearBitsInRange( struct MulleObjCCharacterBitmap *p,
                                                 NSRange range,
                                                 struct mulle_allocator *allocator)
{
   assert( p);
   assert( allocator);

   while( range.length--)
      MulleObjCCharacterBitmapClearBit( p, range.location++);

   MulleObjCCharacterBitmapRemoveUnusedPlanes( p, allocator);
}


void  MulleObjCCharacterBitmapInitWithPlanes( struct MulleObjCCharacterBitmap *p,
                                              uint32_t **planes,
                                              unsigned int n_planes)
{
   assert( p);
   assert( n_planes <= N_PLANES);

   // just copying pointers here
   memcpy( p->planes, planes, sizeof( uint32_t **) * n_planes);
}


int  MulleObjCCharacterBitmapInitWithBitmapRepresentation( struct MulleObjCCharacterBitmap *p,
                                                           NSData *data,
                                                           struct mulle_allocator *allocator)
{
   NSUInteger   i;
   uint8_t      *bytes;
   size_t       length;

   assert( p);
   assert( allocator);

   memset( p, 0, sizeof( struct MulleObjCCharacterBitmap));

   bytes  = [data bytes];
   length = [data length];

   i = 0;
   for(;;)
   {
      if( length < N_BYTES)
         return( -1);

      p->planes[ i] = mulle_allocator_malloc( allocator, N_BYTES);
      memcpy( p->planes[ i], bytes, N_BYTES);
      bytes          = &bytes[ N_BYTES];
      length        -= N_BYTES;
      if( ! length)
         return( 0);

      i = *bytes++;
      --length;

      if( i >= N_PLANES)
         return( -1);
   }
}


void   MulleObjCCharacterBitmapFreePlanes( struct MulleObjCCharacterBitmap *p,
                                           struct mulle_allocator *allocator)
{
   unsigned int  i;

   assert( p);
   assert( allocator);

   for( i = 0; i < N_PLANES; i++)
      mulle_allocator_free( allocator, p->planes[ i]);
}


void   MulleObjCCharacterBitmapInvert( struct MulleObjCCharacterBitmap *p,
                                       struct mulle_allocator *allocator)
{
   unsigned int  i;

   assert( p);
   assert( allocator);

   for( i = 0; i < N_PLANES; i++)
      if( ! p->planes[ i])
      {
         p->planes[ i] = mulle_allocator_malloc( allocator, N_BYTES);
         memset( p->planes[ i], 0xFF, N_BYTES);
      }
      else
         if( ! mulle_meminvert_32( p->planes[ i], N_WORDS))
         {
            mulle_allocator_free( allocator, p->planes[ i]);
            p->planes[ i] = NULL;
         }
}


void   MulleObjCCharacterBitmapLogicOperation( struct MulleObjCCharacterBitmap *p,
                                               struct MulleObjCCharacterBitmap *q,
                                               enum MulleObjCCharacterBitmapLogicOpcode opcode,
                                               struct mulle_allocator *allocator)
{
   unsigned int  i;

   assert( p);
   assert( q);
   assert( allocator);

   for( i = 0; i < N_PLANES; i++)
   {
      if( p->planes[ i] && q->planes[ i])
      {
         if( ! mulle_memop2_32( p->planes[ i], q->planes[ i], N_WORDS, opcode))
         {
            mulle_allocator_free( allocator, p->planes[ i]);
            p->planes[ i] = NULL;
         }
         continue;
      }

      switch( opcode)
      {
      case MulleObjCCharacterBitmapAND  :
         mulle_allocator_free( allocator, p->planes[ i]);
         p->planes[ i] = NULL;
         break;

      case MulleObjCCharacterBitmapNAND  :
         if( ! p->planes[ i])
            p->planes[ i] = mulle_allocator_malloc( allocator, N_BYTES);
         memset( p->planes[ i], 0xFF, N_BYTES);
         break;

      case MulleObjCCharacterBitmapOR   :
         if( ! p->planes[ i])
         {
            if( q->planes[ i])
            {
               p->planes[ i] = mulle_allocator_malloc( allocator, N_BYTES);
               memcpy( p->planes[ i], q->planes[ i], N_BYTES);
            }
         }
         break;

      case MulleObjCCharacterBitmapNOR :
         if( ! p->planes[ i])
            p->planes[ i] = mulle_allocator_calloc( allocator, 1, N_BYTES);
         mulle_meminvert_32( p->planes[ i], N_WORDS);
         break;
      }
   }
}
