/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _MulleObjCUTF8StreamReader.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCBufferedDataInputStream.h"


// only can deal with UTF8 but returns UTF32
@interface _MulleObjCUTF8StreamReader : NSObject 
{
#ifdef MULLE_OBJC_UTF8_STREAM_READER_IVAR_VISIBILITY
MULLE_OBJC_UTF8_STREAM_READER_IVAR_VISIBILITY
#endif
   _MulleObjCBufferedDataInputStream  *_stream;

   long   _current;
   long   _lineNr;
}

- (id) initWithString:(NSString *) s;
- (id) initWithBufferedInputStream:(_MulleObjCBufferedDataInputStream *) stream;

- (void) bookmark;
- (NSData *) bookmarkedData;
- (MulleObjCMemoryRegion) bookmarkedRegion;

@end


