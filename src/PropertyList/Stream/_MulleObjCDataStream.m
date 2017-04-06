//
//  _MulleObjCDataStream.m
//  MulleObjCFoundation
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

#import "_MulleObjCDataStream.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies


@implementation _MulleObjCMemoryDataInputStream : NSObject

- (id) initWithData:(NSData *) data
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



@implementation NSMutableData( _MulleObjCOutputDataStream)

- (void) writeData:(NSData *) data
{
   [self appendData:data];
}


- (void) writeBytes:(void *) bytes
             length:(NSUInteger) length
{
   [self appendBytes:bytes
              length:length];
}

@end


//@implementation NSFileHandle( MulleObjCDataStream)

// all done in original class

//@end
