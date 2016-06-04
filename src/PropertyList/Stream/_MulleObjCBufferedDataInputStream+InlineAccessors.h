/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  _MulleObjCBufferedDataOutputStream+InlineAccessors.h is a part of MulleFoundation
 *
 *  Copyright (C) 2009 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */

#define _MULLE_OBJC_BUFFERED_DATA_INPUT_STREAM_IVAR_VISIBILITY  @public
 
#import "_MulleObjCBufferedDataInputStream.h"


// don't inline these and don't call'em yourself
int    _MulleObjCBufferedDataInputStreamFillBufferAndNextCharacter( _MulleObjCBufferedDataInputStream *self);
MulleObjCMemoryRegion   _MulleObjCBufferedDataInputStreamBookmarkedRegion( _MulleObjCBufferedDataInputStream *self);

// keep as small as possible for inlining
static inline int  _MulleObjCBufferedDataInputStreamCurrentCharacter( _MulleObjCBufferedDataInputStream *_self)
{
   struct { @defs( _MulleObjCBufferedDataInputStream); }  *self = (void *) _self;
   
   if( ! self->_current)
      return( -1);
   return( *self->_current);
}


static inline int   _MulleObjCBufferedDataInputStreamNextCharacter( _MulleObjCBufferedDataInputStream *_self)
{
   struct { @defs( _MulleObjCBufferedDataInputStream); }  *self = (void *) _self;
   
   assert( self->_current);

   if( ++self->_current == self->_sentinel)
      return( _MulleObjCBufferedDataInputStreamFillBufferAndNextCharacter( _self));

   return( *self->_current);
}


static inline int   _MulleObjCBufferedDataInputStreamConsumeCurrentCharacter( _MulleObjCBufferedDataInputStream *_self)
{
   struct { @defs( _MulleObjCBufferedDataInputStream); }  *self = (void *) _self;
   int     c;

   // end reached ?
   if( ! self->_current)
      return( -1);
   c = *self->_current;
   
   _MulleObjCBufferedDataInputStreamNextCharacter( _self);
   return( c);
}


static inline size_t  _MulleObjCBufferedDataInputStreamBytesAvailable( _MulleObjCBufferedDataInputStream *_self)
{
   struct { @defs( _MulleObjCBufferedDataInputStream); }  *self = (void *) _self;
   
   return( self->_sentinel - self->_current);
}


static inline void  _MulleObjCBufferedDataInputStreamBookmark( _MulleObjCBufferedDataInputStream *_self)
{
   struct { @defs( _MulleObjCBufferedDataInputStream); }  *self = (void *) _self;
   
   if( self->_bookmarkData)
   {
      [self->_bookmarkData release];
      self->_bookmarkData = nil;
   }
   self->_bookmark = self->_current;
}

