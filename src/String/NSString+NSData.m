//
//  NSString+NSData.m
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

#import "NSString+NSData.h"

// other files in this library
#import "NSString+ClassCluster.h"
#import "_MulleObjCUTF16String.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationBase.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <mulle-utf/mulle-utf.h>
#include <mulle-buffer/mulle-buffer.h>

enum
{
   big_end_first    = 0,
   little_end_first = 1,
   native_end_first = 2
};



@implementation NSString (NSData)


// defaults

- (NSStringEncoding) fastestEncoding
{
   return( NSUTF8StringEncoding);
}

- (NSStringEncoding) smallestEncoding
{
   return( NSUTF8StringEncoding);
}



#pragma mark -
#pragma mark Export


// move convenient for subclasses
- (BOOL) _getBytes:(void *) buffer
         maxLength:(NSUInteger) maxLength
        usedLength:(NSUInteger *) usedLength
          encoding:(NSStringEncoding) encoding
           options:(NSStringEncodingConversionOptions) options
{
   NSUInteger   length;
   void         *bytes;
   NSData       *data;

   data   = [self dataUsingEncoding:encoding];
   bytes  = [data bytes];
   length = [data length];

   // do maxLength (in unichar)

   if( length > maxLength)
      length = maxLength;

   // do usedLength (in unichar)
   if( usedLength)
      *usedLength = length;

   memcpy( buffer, bytes, length);
   return( YES);
}


- (BOOL) getBytes:(void *) buffer
        maxLength:(NSUInteger) maxLength
       usedLength:(NSUInteger *) usedLength
         encoding:(NSStringEncoding) encoding
          options:(NSStringEncodingConversionOptions) options
            range:(NSRange) range
   remainingRange:(NSRangePointer) leftover
{
   NSUInteger   length;
   NSString     *s;

   if( ! range.length)
      return( YES);

   length = [self length];
   MulleObjCValidateRangeWithLength( range, length);

   // do leftover (in unichar)
   if( leftover)
   {
      leftover->location = range.location + range.length;
      leftover->length   = length - leftover->location;
   }

   // do range (in unichar)
   s = self;
   if( range.location || range.length != length)
      s = [s substringWithRange:range];

   return( [s _getBytes:buffer
              maxLength:maxLength
             usedLength:usedLength
               encoding:encoding
                options:options]);
}


- (NSData *) _utf8Data
{
   NSUInteger      length;
   NSMutableData   *data;

   length = [self mulleUTF8StringLength];
   data   = [NSMutableData _mulleNonZeroedDataWithLength:length];
   [self mulleGetUTF8Characters:[data mutableBytes]
                  maxLength:length];
   return( data);
}


//
// need to improve this the duplicate buffer is layme
// put better code into subclasses
//
- (NSData *) _utf16DataWithEndianness:(unsigned int) endianess
                        prefixWithBOM:(BOOL) prefixWithBOM
                    terminateWithZero:(BOOL) terminateWithZero
{
   NSMutableData                  *data;
   NSMutableData                  *tmp_data;
   NSUInteger                     tmp_length;
   NSUInteger                     utf16total;
   mulle_utf16_t                  *buf;
   mulle_utf16_t                  *p;
   mulle_utf16_t                  *sentinel;
   mulle_utf16_t                  bom;
   mulle_utf32_t                  *tmp_buf;
   struct mulle_buffer            buffer;
   struct mulle_utf_information   info;
   size_t                         size;

   tmp_length = [self length];
   tmp_data   = [NSMutableData _mulleNonZeroedDataWithLength:tmp_length * sizeof( mulle_utf32_t)];
   tmp_buf    = [tmp_data mutableBytes];

   [self getCharacters:tmp_buf
                 range:NSMakeRange( 0, tmp_length)];

   if( mulle_utf32_information( tmp_buf, tmp_length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF32");

   utf16total = info.utf16len;
   if( prefixWithBOM)
      ++utf16total;
   if( terminateWithZero)
      ++utf16total;

   size = utf16total * sizeof( mulle_utf16_t);
   data = [NSMutableData _mulleNonZeroedDataWithLength:size];
   buf  = [data mutableBytes];

   mulle_buffer_init_inflexible_with_static_bytes( &buffer, buf, size);

   if( prefixWithBOM)
   {
      bom = (mulle_utf16_t) mulle_utf32_get_bomcharacter();
      mulle_buffer_add_bytes( &buffer, &bom, sizeof( bom));
   }
   mulle_utf32_bufferconvert_to_utf16( info.start,
                                       info.utf32len,
                                       &buffer,
                                       (void (*)()) mulle_buffer_add_bytes);
   if( terminateWithZero)
   {
      bom = 0;
      mulle_buffer_add_bytes( &buffer, &bom, sizeof( bom));
   }

   assert( mulle_buffer_get_length( &buffer) == size);
   assert( ! mulle_buffer_has_overflown( &buffer));
   mulle_buffer_done( &buffer);

   if( endianess == native_end_first)
      return( data);

#ifdef __LITTLE_ENDIAN__
   if( endianess == little_end_first)
      return( data);
#else
   if( endianess == big_end_first)
      return( data);
#endif

   p        = buf;
   sentinel = &p[ utf16total];

   while( p < sentinel)
   {
      *p = MulleObjCSwapUInt16( *p);
      ++p;
   }

   return( data);
}


- (NSData *) _utf32DataWithEndianness:(unsigned int) endianess
                        prefixWithBOM:(BOOL) prefixWithBOM
                    terminateWithZero:(BOOL) terminateWithZero
{
   NSUInteger      length;
   NSUInteger      total;
   NSMutableData   *data;
   mulle_utf32_t   *buf;
   mulle_utf32_t   *p;
   mulle_utf32_t   *sentinel;

   total = length = [self length];
   if( prefixWithBOM)
      ++total;
   if( terminateWithZero)
      ++total;

   data    = [NSMutableData _mulleNonZeroedDataWithLength:total * sizeof( mulle_utf32_t)];
   p = buf = [data mutableBytes];

   if( prefixWithBOM)
      *p++ = mulle_utf32_get_bomcharacter();

   [self getCharacters:p
                 range:NSMakeRange( 0, length)];
   p = &p[ length];

   if( terminateWithZero)
      *p = 0;

   if( endianess == native_end_first)
      return( data);

#ifdef __LITTLE_ENDIAN__
   if( endianess == little_end_first)
      return( data);
#else
   if( endianess == big_end_first)
      return( data);
#endif

   p        = buf;
   sentinel = &p[ total];

   while( p < sentinel)
   {
      *p = MulleObjCSwapUInt32( *p);
      ++p;
   }

   return( data);
}


//
// TODO: need a plugin mechanism to support more encodings
//
- (BOOL) canBeConvertedToEncoding:(NSStringEncoding) encoding
{
   switch( encoding)
   {
   case NSUTF8StringEncoding  :
   case NSUTF16StringEncoding :
   case NSUTF16LittleEndianStringEncoding :
   case NSUTF16BigEndianStringEncoding :
   case NSUTF32StringEncoding :
   case NSUTF32LittleEndianStringEncoding :
   case NSUTF32BigEndianStringEncoding :
      return( YES);
   }

   return( NO);
}


- (NSData *) _dataUsingEncoding:(NSStringEncoding) encoding
                  prefixWithBOM:(BOOL) withBOM
              terminateWithZero:(BOOL) withZero
{
   switch( encoding)
   {
   default :
      MulleObjCThrowInvalidArgumentException( @"encoding %d is not supported", encoding);

   case NSUTF8StringEncoding  :
      return( [self _utf8Data]);

   case NSUTF16StringEncoding :
      return( [self _utf16DataWithEndianness:native_end_first
                                prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   case NSUTF16LittleEndianStringEncoding :
      return( [self _utf16DataWithEndianness:little_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   case NSUTF16BigEndianStringEncoding :
      return( [self _utf16DataWithEndianness:big_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);

   case NSUTF32StringEncoding :
      return( [self _utf32DataWithEndianness:native_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   case NSUTF32LittleEndianStringEncoding :
      return( [self _utf32DataWithEndianness:little_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   case NSUTF32BigEndianStringEncoding :
      return( [self _utf32DataWithEndianness:big_end_first
                               prefixWithBOM:withBOM
                           terminateWithZero:withZero]);
   }
}


- (NSData *) dataUsingEncoding:(NSStringEncoding) encoding
{
   return( [self _dataUsingEncoding:encoding
                      prefixWithBOM:YES
                  terminateWithZero:NO]);
}


#pragma mark -
#pragma mark Import

- (instancetype) mulleInitWithUTF16Characters:(mulle_utf16_t *) chars
                                   length:(NSUInteger) length
{
   struct mulle_utf_information    info;
   struct mulle_buffer             buffer;
   void                            *p;
   struct mulle_allocator          *allocator;
   id                              old;

   if( mulle_utf16_information( chars, length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF16");

   allocator = MulleObjCObjectGetAllocator( self);

   if( info.is_ascii)
   {
      /* convert to utf8 */
      mulle_buffer_init_with_capacity( &buffer, info.utf8len, allocator);

      mulle_utf16_bufferconvert_to_utf8( info.start,
                                              info.utf16len,
                                              &buffer,
                                              (void (*)()) mulle_buffer_add_bytes);

      assert( mulle_buffer_get_length( &buffer) == info.utf8len);

      p = mulle_buffer_extract_all( &buffer);
      mulle_buffer_done( &buffer);

      return( [self mulleInitWithUTF8CharactersNoCopy:p
                                           length:info.utf8len
                                        allocator:allocator]);
   }

   if( info.is_utf15)
   {
      // shortcut ...
      old  = self;
      self = [_MulleObjCGenericUTF16String newWithUTF16Characters:info.start
                                                            length:info.utf16len];
      [old release];
      return( self);
   }

   /* convert to utf32 */
   mulle_buffer_init_with_capacity( &buffer, info.utf32len * sizeof( mulle_utf32_t), allocator);

   mulle_utf16_bufferconvert_to_utf32( info.start,
                                            info.utf16len,
                                            &buffer,
                                            (void (*)()) mulle_buffer_add_bytes);

   assert( mulle_buffer_get_length( &buffer) == info.utf32len * sizeof( mulle_utf32_t));

   p = mulle_buffer_extract_all( &buffer);
   mulle_buffer_done( &buffer);

   return( [self mulleInitWithCharactersNoCopy:p
                                        length:info.utf32len
                                     allocator:allocator]);
}


- (instancetype) _initWithSwappedUTF16Characters:(mulle_utf16_t *) chars
                                          length:(NSUInteger) length
{
   mulle_utf16_t   *p;
   mulle_utf16_t   *buf;
   mulle_utf16_t   *sentinel;

   buf      = [[NSMutableData _mulleNonZeroedDataWithLength:length * sizeof( mulle_utf16_t)] mutableBytes];
   p        = buf;
   sentinel = &p[ length];

   while( p < sentinel)
      *p++ = MulleObjCSwapUInt16( *chars++);

   return( [self mulleInitWithUTF16Characters:buf
                                       length:length]);
}



- (instancetype) _initWithSwappedUTF32Characters:(mulle_utf32_t *) chars
                                          length:(NSUInteger) length
{
   mulle_utf32_t   *p;
   mulle_utf32_t   *buf;
   mulle_utf32_t   *sentinel;

   buf      = [[NSMutableData _mulleNonZeroedDataWithLength:length * sizeof( mulle_utf32_t)] mutableBytes];
   p        = buf;
   sentinel = &p[ length];

   while( p < sentinel)
      *p++ = MulleObjCSwapUInt32( *chars++);

   return( [self initWithCharacters:buf
                             length:length]);
}


- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
                      encoding:(NSUInteger) encoding

{
   if( ! bytes && length)
      MulleObjCThrowInvalidArgumentException( @"null bytes");

   switch( encoding)
   {
   default :
      MulleObjCThrowInvalidArgumentException( @"encoding %d is not supported", encoding);

   case NSUTF8StringEncoding  :
      return( [self mulleInitWithUTF8Characters:bytes
                                    length:length]);

   case NSUTF16StringEncoding :
      return( [self mulleInitWithUTF16Characters:bytes
                                      length:length / sizeof( mulle_utf16_t)]);

   case NSUTF16LittleEndianStringEncoding :
#ifdef __LITTLE_ENDIAN__
      return( [self mulleInitWithUTF16Characters:bytes
                                      length:length / sizeof( mulle_utf16_t)]);
#else
      return( [self _initWithSwappedUTF16Characters:bytes
                                             length:length / sizeof( mulle_utf16_t)]);
#endif
   case NSUTF16BigEndianStringEncoding :
#ifdef __BIG_ENDIAN__
      return( [self initWithCharacters:bytes
                                length:length / sizeof( mulle_utf16_t)]);
#else
      return( [self _initWithSwappedUTF16Characters:bytes
                                             length:length / sizeof( mulle_utf16_t)]);
#endif

   case NSUTF32StringEncoding :
      return( [self initWithCharacters:bytes
                                length:length / sizeof( mulle_utf32_t)]);

   case NSUTF32LittleEndianStringEncoding :
#ifdef __LITTLE_ENDIAN__
      return( [self initWithCharacters:bytes
                                length:length / sizeof( mulle_utf32_t)]);
#else
      return( [self _initWithSwappedUTF32Characters:bytes
                                             length:length / sizeof( mulle_utf32_t)]);
#endif

   case NSUTF32BigEndianStringEncoding :
#ifdef __BIG_ENDIAN__
      return( [self initWithCharacters:bytes
                                length:length / sizeof( mulle_utf32_t)]);
#else
      return( [self _initWithSwappedUTF32Characters:bytes
                                             length:length / sizeof( mulle_utf32_t)]);
#endif
   }
}


- (instancetype) initWithData:(NSData *) data
                     encoding:(NSUInteger) encoding
{
   void         *bytes;
   NSUInteger   length;

   bytes  = [data bytes];
   length = [data length];

   return( [self initWithBytes:bytes
                        length:length
                      encoding:encoding]);
}


- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
                            encoding:(NSStringEncoding) encoding
                        freeWhenDone:(BOOL) flag
{
   NSString                 *s;
   struct mulle_allocator   *allocator;

   allocator = flag ? &mulle_stdlib_allocator : NULL;

   if( ! bytes && length)
      MulleObjCThrowInvalidArgumentException( @"null bytes");

   // has zero termination ?
   switch( encoding)
   {
   case NSUTF8StringEncoding :
      if( length && ! ((char *) bytes)[ length - 1])
         return( [self mulleInitWithUTF8CharactersNoCopy:bytes
                                                  length:length
                                               allocator:allocator]);
      break;

   case NSUnicodeStringEncoding :
      return( [self mulleInitWithCharactersNoCopy:bytes
                                       length:length
                                    allocator:allocator]);
   }

   s = [self initWithBytes:bytes
                    length:length
                  encoding:encoding];
   if( allocator)
      mulle_allocator_free( allocator, bytes);
   return( s);
}


- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                                 encoding:(NSStringEncoding) encoding
                            sharingObject:(id) owner
{
   switch( encoding)
   {
   case NSUTF8StringEncoding :
      return( [self mulleInitWithUTF8CharactersNoCopy:bytes
                                           length:length
                                       sharingObject:owner]);
   case NSUnicodeStringEncoding :
      NSParameterAssert( (length & (sizeof( mulle_utf32_t) - 1)) == 0);
      return( [self mulleInitWithCharactersNoCopy:bytes
                                       length:length / sizeof( mulle_utf32_t)
                                sharingObject:owner]);
   }

   return( [self initWithBytes:bytes
                        length:length
                      encoding:encoding]);
}


- (instancetype) mulleInitWithDataNoCopy:(NSData *) data
                                encoding:(NSStringEncoding) encoding
{
   void         *bytes;
   NSUInteger   length;

   bytes  = [data bytes];
   length = [data length];

   return( [self mulleInitWithBytesNoCopy:bytes
                                   length:length
                                 encoding:encoding
                            sharingObject:data]);
}


// this code works for UTF8String and ASCII only
- (NSUInteger) lengthOfBytesUsingEncoding:(NSStringEncoding) encoding
{
   size_t                        length;
   struct mulle_utf_information  info;
   mulle_utf8_t                  *s;

   if( [self mulleFastASCIICharacters])
   {
      length = [self length];
      switch( encoding)
      {
      case NSASCIIStringEncoding :
      case NSUTF8StringEncoding  : return( length);
      case NSUTF16StringEncoding : return( length * sizeof( mulle_utf16_t));
      case NSUTF32StringEncoding : return( length * sizeof( mulle_utf32_t));
      default                    : return( 0);
      }
   }

   // subclasses can do this faster
   s = [self mulleFastUTF8Characters];
   if( ! s)
      s = (mulle_utf8_t *) [self UTF8String];

   length = [self mulleUTF8StringLength];
   if( mulle_utf8_information( s, length, &info))
      MulleObjCThrowInternalInconsistencyException( @"supposed UTF8 is not UTF8");

   switch( encoding)
   {
   case NSASCIIStringEncoding : return( info.is_ascii ? info.utf8len : 0);
   case NSUTF8StringEncoding  : return( info.utf8len);
   case NSUTF16StringEncoding : return( info.utf16len * sizeof( mulle_utf16_t));
   case NSUTF32StringEncoding : return( info.utf32len * sizeof( mulle_utf32_t));
   default                    : return( 0);
   }
}


#pragma mark -
#pragma mark lldb support

// the actual function is:
// CFStringRef CFStringCreateWithBytes (
//   CFAllocatorRef alloc,
//   const UInt8 *bytes,
//   CFIndex numBytes,
//   CFStringEncoding encoding,
//   Boolean isExternalRepresentation
// );
// rename it in the debugger and use this

NSString   *_NSStringCreateWithBytes( void *allocator,
                                     mulle_utf8_t *bytes,
                                     NSUInteger length,
                                     NSStringEncoding encoding,
                                     char isExternal);

NSString   *_NSStringCreateWithBytes( void *allocator,
                                     mulle_utf8_t *bytes,
                                     NSUInteger length,
                                     NSStringEncoding encoding,
                                     char isExternal)
{
   return( [[[NSString alloc] initWithBytes:bytes
                                     length:length
                                   encoding:encoding] autorelease]);
}




@end
