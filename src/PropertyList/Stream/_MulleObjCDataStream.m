/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  MulleObjCDataStream.h is a part of MulleFoundation
 *
 *  Copyright (C) 2009 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */

#import "_MulleObjCDataStream.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies

#import "MulleObjCFoundationException.h"


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
