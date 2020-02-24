//
//  NSData+Unicode.m
//  MulleObjCStandardFoundation
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
#import "NSData+Unicode.h"


@implementation NSData( _Unicode)


static _MulleObjCByteOrderMark  byteOrderMark( uint8_t *p, size_t len)
{
   assert( p && len >= 2);

   switch( *p)
   {
   case 0xEF :
      if( len >= 3 && p[ 1] == 0xBB && p[2] == 0xBF)
         return( _MulleObjCUTF8ByteOrderMark);
      break;

   case 0xFE :
      if( p[ 1] == 0xFF)
         return( _MulleObjCUTF16BigEndianByteOrderMark);
      break;

   case 0xFF :
      if( p[ 1] == 0xFE)
         return( _MulleObjCUTF16LittleEndianByteOrderMark);
      break;
   }
   return( _MulleObjCNoByteOrderMark);
}


- (_MulleObjCByteOrderMark) _byteOrderMark
{
   NSUInteger     len;
   unsigned char  *p;

   len = [self length];
   if( len < 2)
      return( _MulleObjCNoByteOrderMark);

// http://de.wikipedia.org/wiki/Byte_Order_Mark
//
//  Kodierung 	        hexadezimale Darstellung
//  UTF-8 	        EF BB BF[3]
//  UTF-16 (BE) 	FE FF
//  UTF-16 (LE) 	FF FE

   return( byteOrderMark( [self bytes], len));
}


- (NSData *) swappedUTF16Data
{
   NSMutableData   *data;
   mulle_utf16_t   *src;
   mulle_utf16_t   *sentinel;
   mulle_utf16_t   *dst;
   NSUInteger      length;

   length  = [self length];
   if( length & 1)
      return( nil);

   data = [NSMutableData mulleNonZeroedDataWithLength:length];
   dst  = [data mutableBytes];

   src      = [self bytes];
   sentinel = &src[ length / sizeof( uint16_t)];
   while( src < sentinel)
      *dst++ = MulleObjCSwapUInt16( *src++);
   return( data);
}


- (NSData *) UTF8DataFromUTF16
{
   struct mulle_buffer      buf;
   struct mulle_allocator   *allocator;
   size_t                   length;
   mulle_utf16_t            *srcBytes;
   mulle_utf8_t             *dstBytes;

   allocator = MulleObjCObjectGetAllocator( self);
   mulle_buffer_init( &buf, allocator);
   srcBytes  = [self bytes];
   length    = [self length] / sizeof( mulle_utf16_t);
   if( length)
   {
      if( *srcBytes == mulle_utf16_get_bomcharacter())
      {
         --length;
         ++srcBytes;
      }
   }
   mulle_utf16_bufferconvert_to_utf8( srcBytes,
                                      length,
                                      &buf,
                                      (void (*)()) mulle_buffer_add_bytes);

   length   = mulle_buffer_get_length( &buf);
   dstBytes = mulle_buffer_extract_all( &buf);
   mulle_buffer_done( &buf);

   return( [[[NSData alloc] mulleInitWithBytesNoCopy:dstBytes
                                              length:length
                                           allocator:allocator] autorelease]);
}


@end
