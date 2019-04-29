//
//  mulle_buffer_archiver.h
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

#import <mulle-buffer/mulle-buffer.h>

#include <MulleObjC/minimal.h>


# pragma mark -
# pragma mark mulle_buffer extended reading
//
// output format:
//  c x x x x x x x
// 7 bits + continuation
//
static inline uint64_t  mulle_buffer_next_integer( struct mulle_buffer *buffer)
{
   int        c;
   uint64_t   v;

   v = 0;
   do
   {
      c = mulle_buffer_next_byte( buffer);
      if( c < 0) // EOB
         return( 0);

      v <<= 7;
      v  += (c & 0x7F);
   }
   while( c & 0x80);

   return( v);
}


static inline long long
   mulle_buffer_next_long_long( struct mulle_buffer *buffer)
{
   long long   swap;

   mulle_buffer_next_bytes( buffer, &swap, sizeof( swap));
   return( NSSwapBigLongLongToHost( swap));
}


static inline float   mulle_buffer_next_float( struct mulle_buffer *buffer)
{
   NSSwappedFloat   swap;

   mulle_buffer_next_bytes( buffer, &swap, sizeof( swap));
   return( NSSwapBigFloatToHost( swap));
}


static inline double   mulle_buffer_next_double( struct mulle_buffer *buffer)
{
   NSSwappedDouble   swap;

   mulle_buffer_next_bytes( buffer, &swap, sizeof( swap));
   return( NSSwapBigDoubleToHost( swap));
}


static inline long double
   mulle_buffer_next_long_double( struct mulle_buffer *buffer)
{
   NSSwappedLongDouble   swap;

   mulle_buffer_next_bytes( buffer, &swap, sizeof( swap));
   return( NSSwapBigLongDoubleToHost( swap));
}


# pragma mark -
# pragma mark mulle_buffer extended writing

//
// output format:
//  c x x x x x x x
// 7 bits + continuation
//

#define shift32( x)    ((x) - 7)
#define mask32( x)     ((0x1U << ((x) - 7)) - 1)

static inline void  mulle_buffer_add_integer_7( struct mulle_buffer *buffer,
                                                uint8_t v)
{
   mulle_buffer_add_byte( buffer, v);
}


static inline void  mulle_buffer_add_integer_14( struct mulle_buffer *buffer,
                                                 uint16_t v)
{
   mulle_buffer_add_byte( buffer, (unsigned char) (v >> shift32( 14)) | 0x80);
   mulle_buffer_add_integer_7( buffer, v & mask32( 14));
}


static inline void  mulle_buffer_add_integer_21( struct mulle_buffer *buffer,
                                                 uint32_t v)
{
   mulle_buffer_add_byte( buffer, (unsigned char) (v >> shift32( 21)) | 0x80);
   mulle_buffer_add_integer_14( buffer, v & mask32( 21));
}


static inline void  mulle_buffer_add_integer_28( struct mulle_buffer *buffer,
                                                 uint32_t v)
{
   mulle_buffer_add_byte( buffer, (unsigned char) (v >> shift32( 28)) | 0x80);
   mulle_buffer_add_integer_21( buffer, v & mask32( 28));
}

#define shift64( x)    ((x) - 7)
#define mask64( x)     ((0x1ULL << ((x) - 7)) - 1)

static inline void  mulle_buffer_add_integer_35( struct mulle_buffer *buffer,
                                                 uint64_t v)
{
   mulle_buffer_add_byte( buffer, (unsigned char) (v >> shift64( 35)) | 0x80);
   mulle_buffer_add_integer_28( buffer, (uint32_t) (v & mask64( 35)));
}


static inline void  mulle_buffer_add_integer_42( struct mulle_buffer *buffer,
                                                 uint64_t v)
{
   mulle_buffer_add_byte( buffer, (unsigned char) (v >> shift64( 42)) | 0x80);
   mulle_buffer_add_integer_35( buffer, v & mask64( 42));
}


static inline void  mulle_buffer_add_integer_49( struct mulle_buffer *buffer,
                                                 uint64_t v)
{
   mulle_buffer_add_byte( buffer, (unsigned char) (v >> shift64( 49)) | 0x80);
   mulle_buffer_add_integer_42( buffer, v & mask64( 49));
}


static inline void  mulle_buffer_add_integer_56( struct mulle_buffer *buffer,
                                                 uint64_t v)
{
   mulle_buffer_add_byte( buffer, (unsigned char) (v >> shift64( 56)) | 0x80);
   mulle_buffer_add_integer_49( buffer, v & mask64( 56));
}


static inline void  mulle_buffer_add_integer_63( struct mulle_buffer *buffer,
                                                 uint64_t v)
{
   mulle_buffer_add_byte( buffer, (unsigned char) (v >> shift64( 63)) | 0x80);
   mulle_buffer_add_integer_56( buffer, v & mask64( 63));
}


static inline void  mulle_buffer_add_integer_64( struct mulle_buffer *buffer,
                                                 uint64_t v)
{
   mulle_buffer_add_byte( buffer, 0x81);
   mulle_buffer_add_integer_63( buffer, v << 1 >> 1);  // clear top bit
}


// this must be easier
//
// not efficient for negative numbers
//
static inline void   mulle_buffer_add_integer( struct mulle_buffer *buffer,
                                               uint64_t v)
{
   uint32_t       v32;
   unsigned int   bytes;

   if( v < 0x7F)
   {
      mulle_buffer_add_integer_7( buffer, (uint8_t) v);
      return;
   }

   if( v < 0x10000000U)    // 32 bit: best fit 28 bits
   {
      uint32_t   mask;

      bytes = 4;
      v32 = (uint32_t) v;
      mask = 0x0FE00000U;
      while( ! (v32 & mask))
      {
         --bytes;
         mask >>= 7;
      }
   }
   else
   {
      uint64_t   mask;

      bytes = 10;
      if( (int64_t) v >= 0)  // 32 bit: best fit 63 bits
      {
         --bytes;
         mask = 0x7F00000000000000ULL;
         while( ! (v & mask))
         {
            --bytes;
            mask >>= 7;
         }
      }
   }

   switch( bytes)
   {
   case 10 : mulle_buffer_add_integer_64( buffer, v); return;
   case  9 : mulle_buffer_add_integer_63( buffer, v); return;
   case  8 : mulle_buffer_add_integer_56( buffer, v); return;
   case  7 : mulle_buffer_add_integer_49( buffer, v); return;
   case  6 : mulle_buffer_add_integer_42( buffer, v); return;
   case  5 : mulle_buffer_add_integer_35( buffer, v); return;

   case  4 : mulle_buffer_add_integer_28( buffer, (uint32_t) v); return;
   case  3 : mulle_buffer_add_integer_21( buffer, (uint32_t) v); return;
   case  2 : mulle_buffer_add_integer_14( buffer, (uint16_t) v); return;
   case  1 : mulle_buffer_add_integer_7( buffer,  (uint8_t) v); return;
   }
}


static inline void  mulle_buffer_add_long_long( struct mulle_buffer *buffer,
                                                long long v)
{
   long long   swap;

   swap = NSSwapHostLongLongToBig( v);
   mulle_buffer_add_bytes( buffer, &swap, sizeof( swap));
}


static inline void  mulle_buffer_add_float( struct mulle_buffer *buffer, float v)
{
   NSSwappedFloat   swap;

   swap = NSSwapHostFloatToBig( v);
   mulle_buffer_add_bytes( buffer, &swap, sizeof( swap));
}


static inline void   mulle_buffer_add_double( struct mulle_buffer *buffer, double v)
{
   NSSwappedDouble   swap;

   swap = NSSwapHostDoubleToBig( v);
   mulle_buffer_add_bytes( buffer, &swap, sizeof( swap));
}


static inline void   mulle_buffer_add_long_double( struct mulle_buffer *buffer,
                                                   long double v)
{
   NSSwappedLongDouble   swap;

   swap = NSSwapHostLongDoubleToBig( v);
   mulle_buffer_add_bytes( buffer, &swap, sizeof( swap));
}
