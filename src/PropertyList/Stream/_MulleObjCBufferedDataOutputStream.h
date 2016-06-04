/*
 *  MulleFoundation - the mulle-objc class library
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

#import "_MulleObjCDataStream.h"


@interface _MulleObjCBufferedDataOutputStream : NSObject < _MulleObjCOutputDataStream>
{
#ifdef _MULLE_OBJC_BUFFERED_DATA_OUTPUT_STREAM_IVAR_VISIBILITY
_MULLE_OBJC_BUFFERED_DATA_OUTPUT_STREAM_IVAR_VISIBILITY      // allow public access for internal use
#endif
   id <_MulleObjCOutputDataStream >  _stream;
   
   NSMutableData   *_data;   
   unsigned char   *_start;
   unsigned char   *_current;
   unsigned char   *_sentinel; 
}

//
// DO NOT DO THAT, JUST USE NSMutableData as stream!
//
//- (id) initWithMutableData:(NSMutableData *) data;
- (id) initWithOutputStream:(id <_MulleObjCOutputDataStream>) stream;

- (void) writeData:(NSData *) data;

@end


