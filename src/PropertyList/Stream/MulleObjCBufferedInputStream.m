//
//  MulleObjCBufferedInputStream.m
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

#import "MulleObjCBufferedInputStream.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies

#import "MulleObjCBufferedInputStream+InlineAccessors.h"

#import "MulleObjCStandardContainerFoundation.h"


static void   MulleObjCBufferedInputStreamFillBuffer( MulleObjCBufferedInputStream *self);
const static size_t   MulleObjCBufferedInputStreamDefaultBufferSize = 0x1000;


@implementation MulleObjCBufferedInputStream

- (instancetype) initWithInputStream:(id <MulleObjCInputStream>) stream
{
   _stream = [stream retain];
   MulleObjCBufferedInputStreamFillBuffer( self);  // need to have a notion of "_current" immediately
   if( self->_current == self->_sentinel)           // we can't have nothing
      return( nil);
   return( self);
}


- (instancetype) initWithData:(NSData *) data
{
   MulleObjCInMemoryInputStream  *stream;

   stream = [[MulleObjCInMemoryInputStream alloc] initWithData:data];
   self   = [self initWithInputStream:stream];
   [stream release];
   return( self);
}


- (void) dealloc
{
   [_bookmarkData release];
   [_stream release];
   [_data release];

   [super dealloc];
}


- (NSData *) readDataOfLength:(NSUInteger) size
{
   id       data;
   size_t   available;

   available = MulleObjCBufferedInputStreamBytesAvailable( self);

   if( size >= available)
   {
      data = [NSData dataWithBytes:_current
                            length:size];
      _current += size;
      return( data);
   }

   if( ! available && size >= MulleObjCBufferedInputStreamDefaultBufferSize / 2)
      return( [_stream readDataOfLength:size]);

   data = [NSMutableData dataWithCapacity:size];
   [data appendBytes:_current
              length:available];
   _current += available;

   //
   if( size >= MulleObjCBufferedInputStreamDefaultBufferSize)
   {
      [data appendData:[_stream readDataOfLength:size]];
      return( data);
   }

   MulleObjCBufferedInputStreamFillBuffer( self);
   available = MulleObjCBufferedInputStreamBytesAvailable( self);

   if( size >= available)
      size = available;

   [data appendBytes:_current
              length:size];
   _current += size;
   return( data);
}


- (void) bookmark
{
   NSParameterAssert( self->_current);

   MulleObjCBufferedInputStreamBookmark( self);
}


MulleObjCMemoryRegion   MulleObjCBufferedInputStreamBookmarkedRegion( MulleObjCBufferedInputStream *self)
{
   MulleObjCMemoryRegion  region;
   NSMutableData      *bookmarkData;
   unsigned char      *start;
   long               length;

   NSCParameterAssert( [self isKindOfClass:[MulleObjCBufferedInputStream class]]);

   if( ! self->_bookmark)
   {
      region.bytes  = NULL;
      region.length = 0;
      return( region);
   }

   if( self->_bookmarkData)
   {
      bookmarkData        = [self->_bookmarkData autorelease];
      self->_bookmarkData = nil;

      start  = (unsigned char *) [self->_data bytes];
      length = (long) (self->_current - start);
      if( length)
         [bookmarkData appendBytes:start
                            length:length];

      region.bytes  = (unsigned char *) [bookmarkData bytes];
      region.length = [bookmarkData length];
   }
   else
   {
      region.bytes  = self->_bookmark;
      region.length = (long) (self->_current - self->_bookmark);
   }
   self->_bookmark = NULL;
   return( region);
}


- (MulleObjCMemoryRegion) bookmarkedRegion
{
   return( MulleObjCBufferedInputStreamBookmarkedRegion( self));
}


- (NSData *) bookmarkedData
{
   id              data;
   unsigned char   *start;
   long            length;

   if( ! _bookmark)
      return( nil);

   data = nil;
   if( _bookmarkData)
   {
      data = [_bookmarkData autorelease];
      _bookmarkData = nil;

      start  = (unsigned char *) [_data bytes];
      length = (long) (self->_current - start);
      if( length)
         [data appendBytes:start
                  length:length];
   }
   else
   {
      length = (long) (self->_current - self->_bookmark);
      if( length)
         data = [[[NSData alloc] initWithBytes:self->_bookmark
                                       length:length] autorelease];
   }
   _bookmark = NULL;
   return( data);
}


int   MulleObjCBufferedInputStreamFillBufferAndNextCharacter( MulleObjCBufferedInputStream *self)
{
   NSCParameterAssert( [self isKindOfClass:[MulleObjCBufferedInputStream class]]);

   MulleObjCBufferedInputStreamFillBuffer( self);
   if( self->_current == self->_sentinel)
      return( -1);
   return( *self->_current);
}


static void   MulleObjCBufferedInputStreamFillBuffer( MulleObjCBufferedInputStream *self)
{
   NSCParameterAssert( [self isKindOfClass:[MulleObjCBufferedInputStream class]]);
   NSCParameterAssert( self->_current == self->_sentinel);

   //
   // we need to preserve Bookmark data, when we change the buffer
   //
   if( self->_bookmark)
   {
      if( ! self->_bookmarkData)
         self->_bookmarkData = [[NSMutableData alloc] initWithBytes:self->_bookmark
                                                             length:self->_sentinel - self->_bookmark];
      else
         [self->_bookmarkData appendData:self->_data];
   }

   [self->_data release];

   self->_data     = [[self->_stream readDataOfLength:MulleObjCBufferedInputStreamDefaultBufferSize] retain];
   self->_current  = (void *) [self->_data bytes];
   self->_sentinel = &self->_current[ [self->_data length]];
}

@end
