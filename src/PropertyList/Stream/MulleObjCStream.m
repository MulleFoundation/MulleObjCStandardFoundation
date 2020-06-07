//
//  MulleObjCStream.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2009 Nat! - Mulle kybernetiK.
//  Copyright (c) 2009 Codeon GmbH.
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

#import "MulleObjCStream.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardFoundationException.h"

// std-c and dependencies


PROTOCOLCLASS_IMPLEMENTATION( MulleObjCOutputStream)

- (void) writeData:(NSData *) data
{
   [self mulleWriteBytes:[data bytes]
                  length:[data length]];
}

PROTOCOLCLASS_END();


@implementation MulleObjCInMemoryInputStream : NSObject

- (instancetype) initWithData:(NSData *) data
{
   _data = [data retain];

   return( self);
}


- (void) dealloc
{
   [_data release];

   [super dealloc];
}


- (NSData *) readDataOfLength:(NSUInteger) length
{
   unsigned char   *dst;
   NSData          *data;

   if( ! _current)
   {
      _current  = (unsigned char *) [_data bytes];
      _sentinel = &_current[ [_data length]];
   }

   //
   // if isa is NSMutableData and you changed something, then reading will
   // fail miserably. Could reimplement this in NSMutableData or so, to
   // use an integer index instead...
   //
   NSParameterAssert( _current >= (unsigned char *) [_data bytes]);
   NSParameterAssert( _current <= &((unsigned char *)[_data bytes])[ [_data length]]);

   dst = &_current[ length];
   if( dst > _sentinel)
   {
      length -= (dst - _sentinel);
      dst     = _sentinel;
   }

   if( ! length)
      return( nil);

   data = [NSData dataWithBytes:_current
                         length:length];
   _current = dst;
   return( data);
}

@end



@implementation NSMutableData( MulleObjCOutputStream)

- (void) writeData:(NSData *) data
{
   [self appendData:data];
}


- (void) mulleWriteBytes:(void *) bytes
                  length:(NSUInteger) length
{
   if( length == -1)
      length = strlen( bytes);

   [self appendBytes:bytes
              length:length];
}

@end


@implementation NSString( MulleObjCOutputStream)

- (void) mulleWriteToStream:(id <MulleObjCOutputStream>) handle
              usingEncoding:(NSStringEncoding) encoding
{
   NSData                    *data;
   struct mulle_utf8_data    utf8data;
   struct mulle_utf16_data   utf16data;
   struct mulle_utf32_data   utf32data;
   struct mulle_ascii_data   asciidata;

   switch( encoding)
   {
   default :
      MulleObjCThrowInvalidArgumentExceptionCString( "encoding %s (%ld) is not supported",
         MulleStringEncodingCStringDescription( encoding),
         (long) encoding);

   case NSASCIIStringEncoding  :
      if( [self mulleFastGetASCIIData:&asciidata])
      {
         [handle mulleWriteBytes:asciidata.characters
                          length:asciidata.length];
         return;
      }
      data = [self _asciiData];
      if( ! data)
         MulleObjCThrowInvalidArgumentExceptionCString( "Can not convert this string to ASCII");
      break;

   case NSUTF8StringEncoding  :
   {
      mulle_utf8_t             tmp[ 64];
      struct mulle_utf8_data   utf8data;

      utf8data = MulleStringGetUTF8Data( self, mulle_utf8_data_make( tmp, 64));
      [handle mulleWriteBytes:utf8data.characters
                       length:utf8data.length];
      return;
   }

   case NSUTF16StringEncoding :
      if( [self mulleFastGetUTF16Data:&utf16data])
      {
         [handle mulleWriteBytes:utf16data.characters
                          length:utf16data.length];
         return;
      }
      data = [self _utf16DataWithEndianness:native_end_first
                              prefixWithBOM:NO
                          terminateWithZero:NO];
      break;

   case NSUTF16LittleEndianStringEncoding :
      data = [self _utf16DataWithEndianness:little_end_first
                              prefixWithBOM:NO
                          terminateWithZero:NO];
      break;
   case NSUTF16BigEndianStringEncoding :
      data = [self _utf16DataWithEndianness:big_end_first
                              prefixWithBOM:NO
                          terminateWithZero:NO];
      break;

   case NSUTF32StringEncoding :
      if( [self mulleFastGetUTF32Data:&utf32data])
      {
         [handle mulleWriteBytes:utf32data.characters
                          length:utf32data.length];
         return;
      }
      data = [self _utf32DataWithEndianness:native_end_first
                              prefixWithBOM:NO
                          terminateWithZero:NO];
      break;
   case NSUTF32LittleEndianStringEncoding :
      data = [self _utf32DataWithEndianness:little_end_first
                              prefixWithBOM:NO
                          terminateWithZero:NO];
      break;
   case NSUTF32BigEndianStringEncoding :
      data = [self _utf32DataWithEndianness:big_end_first
                              prefixWithBOM:NO
                          terminateWithZero:NO];
      break;
   }
   [handle writeData:data];
}

@end

//@implementation NSFileHandle( MulleObjCDataStream)

// all done in original class

//@end
