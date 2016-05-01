/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _MulleObjCBufferedDataInputStream.h is a part of MulleFoundation
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


//
// _MulleObjCBufferedDataInputStream is an abstraction to be used if reading
// or writing to NSFilehandles
//
typedef struct
{
   unsigned char   *bytes;
   size_t          length;
} MulleObjCMemoryRegion;



@interface _MulleObjCBufferedDataInputStream : NSObject < _MulleObjCInputDataStream>
{
#ifdef _MULLE_OBJC_BUFFERED_DATA_INPUT_STREAM_IVAR_VISIBILITY
_MULLE_OBJC_BUFFERED_DATA_INPUT_STREAM_IVAR_VISIBILITY      // allow public access for internal use
#endif
   id <_MulleObjCInputDataStream >  _stream;
   
   NSData          *_data;   
   unsigned char   *_current;
   unsigned char   *_sentinel; 
   
   unsigned char   *_bookmark; 
   NSMutableData   *_bookmarkData;
}

- (id) initWithData:(NSData *) data;
- (id) initWithInputStream:(id <_MulleObjCInputDataStream>) stream;

- (NSData *) readDataOfLength:(NSUInteger) size;

// you can only set one bookmark
- (void) bookmark;

// this returns the bookmark and clears it. use bytes before getting next
// character...
- (MulleObjCMemoryRegion) bookmarkedRegion;   // usually better
- (NSData *) bookmarkedData;            // use if you want a NSData anyway

@end




