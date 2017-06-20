//
//  _MulleObjCBufferedDataOutputStream.m
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
#import "_MulleObjCBufferedDataOutputStream.h"

// other files in this library
#import "_MulleObjCBufferedDataOutputStream+InlineAccessors.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation _MulleObjCBufferedDataOutputStream

#define Buffersize      0x2000
#define MaxToBuffer     (Buffersize - (Buffersize / 4))

- (instancetype) initWithOutputStream:(id <_MulleObjCOutputDataStream>) stream
{
   _stream = [stream retain];
   _data   = [[NSMutableData alloc] initWithLength:Buffersize];

   self->_start    = (unsigned char *) [_data bytes];
   self->_current  = self->_start;
   self->_sentinel = &self->_current[ Buffersize];

   return( self);
}


- (instancetype) initWithMutableData:(NSMutableData *) data
{
   _stream = [data retain];

   return( self);
}


- (void) flush
{
   NSData   *data;

   if( _data)
   {
      data = [[NSData alloc] initWithBytesNoCopy:self->_start
                                          length:self->_current - self->_start
                                    freeWhenDone:NO];
      [_stream writeData:data];
      [data release];
   }

   self->_current = self->_start;
}


- (void) dealloc
{
   [self flush];

   [_stream release];
   [_data release];

   [super dealloc];
}


- (void) writeBytes:(void *) bytes
             length:(NSUInteger) len
{
   if( _data && len < MaxToBuffer)
   {
      if( &self->_current[ len] >= self->_sentinel)
         [self flush];

      memcpy( self->_current, bytes, len);
      self->_current += len;
      return;
   }
   [_stream writeBytes:bytes
                length:len];
}


- (void) writeData:(NSData *) data
{
   [self writeBytes:[data bytes]
             length:[data length]];
}


void   _MulleObjCBufferedDataOutputStreamExtendBuffer( _MulleObjCBufferedDataOutputStream *self)
{
   NSCParameterAssert( self->_current == self->_sentinel);

   [self flush];
}

@end
