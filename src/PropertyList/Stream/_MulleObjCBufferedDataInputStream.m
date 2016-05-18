/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _MulleObjCBufferedDataOutputStream.h is a part of MulleFoundation
 *
 *  Copyright (C) 2009 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCBufferedDataInputStream.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies

#import "_MulleObjCBufferedDataInputStream+InlineAccessors.h"

#import "MulleObjCFoundationContainer.h"


static void   _MulleObjCBufferedDataInputStreamFillBuffer( _MulleObjCBufferedDataInputStream *self);
const static size_t   _MulleObjCBufferedDataInputStreamDefaultBufferSize = 0x1000;


@implementation _MulleObjCBufferedDataInputStream

- (id) initWithInputStream:(id <_MulleObjCInputDataStream>) stream
{
   _stream = [stream retain];
   _MulleObjCBufferedDataInputStreamFillBuffer( self);  // need to have a notion of "_current" immediately
   if( self->_current == self->_sentinel)           // we can't have nothing
      return( nil);
   return( self);
}


- (id) initWithData:(NSData *) data
{
   _MulleObjCMemoryDataInputStream  *stream;
   
   stream = [[_MulleObjCMemoryDataInputStream alloc] initWithData:data];
   self   = [self initWithInputStream:stream];
   [stream release];
   return( self);
}


- (void) dealloc
{
   [_stream autorelease];
   [_data autorelease];

   [super dealloc];
}


- (NSData *) readDataOfLength:(NSUInteger) size
{
   id       data;
   size_t   available;
   
   available = _MulleObjCBufferedDataInputStreamBytesAvailable( self);
   
   if( size >= available)
   {
      data = [NSData dataWithBytes:_current
                            length:size];
      _current += size;
      return( data);
   }
   
   if( ! available && size >= _MulleObjCBufferedDataInputStreamDefaultBufferSize / 2)
      return( [_stream readDataOfLength:size]);
      
   data = [NSMutableData dataWithCapacity:size];
   [data appendBytes:_current
              length:available];
   _current += available;

   // 
   if( size >= _MulleObjCBufferedDataInputStreamDefaultBufferSize)
   {
      [data appendData:[_stream readDataOfLength:size]];
      return( data);
   }
   
   _MulleObjCBufferedDataInputStreamFillBuffer( self);
   available = _MulleObjCBufferedDataInputStreamBytesAvailable( self);
   
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
   
   _MulleObjCBufferedDataInputStreamBookmark( self);
}


MulleObjCMemoryRegion   _MulleObjCBufferedDataInputStreamBookmarkedRegion( _MulleObjCBufferedDataInputStream *self)
{
   MulleObjCMemoryRegion  region;
   NSMutableData      *bookmarkData;
   unsigned char      *start;
   long               length;
   
   NSCParameterAssert( [self isKindOfClass:[_MulleObjCBufferedDataInputStream class]]);

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
   return( _MulleObjCBufferedDataInputStreamBookmarkedRegion( self));
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


int   _MulleObjCBufferedDataInputStreamFillBufferAndNextCharacter( _MulleObjCBufferedDataInputStream *self)
{
   NSCParameterAssert( [self isKindOfClass:[_MulleObjCBufferedDataInputStream class]]);

   _MulleObjCBufferedDataInputStreamFillBuffer( self);
   if( self->_current == self->_sentinel)
      return( -1);
   return( *self->_current);
}


static void   _MulleObjCBufferedDataInputStreamFillBuffer( _MulleObjCBufferedDataInputStream *self)
{
   NSCParameterAssert( [self isKindOfClass:[_MulleObjCBufferedDataInputStream class]]);
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
         [self->_bookmarkData  appendData:self->_data];
   }
   
   [self->_data release];
  
   self->_data     = [[self->_stream readDataOfLength:_MulleObjCBufferedDataInputStreamDefaultBufferSize] retain];
   self->_current  = (void *) [self->_data bytes];
   self->_sentinel = &self->_current[ [self->_data length]];
}


@end

