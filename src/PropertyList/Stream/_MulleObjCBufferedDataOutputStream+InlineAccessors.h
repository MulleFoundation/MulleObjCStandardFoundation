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

#define _MULLE_OBJC_BUFFERED_DATA_OUTPUT_STREAM_IVAR_VISIBILITY  @public
 
#import "_MulleObjCBufferedDataOutputStream.h"


// don't inline these and don't call'em yourself
void   _MulleObjCBufferedDataOutputStreamExtendBuffer( _MulleObjCBufferedDataOutputStream *self);

// keep as small as possible for inlining
static inline void  _MulleObjCBufferedDataOutputStreamNextCharacter( _MulleObjCBufferedDataOutputStream *_self, char c)
{
   struct { @defs( _MulleObjCBufferedDataOutputStream); }  *self = (void *) _self;
   
   if( self->_current == self->_sentinel)
      _MulleObjCBufferedDataOutputStreamExtendBuffer( _self);
   *self->_current++ = c;
}



static inline size_t  _MulleObjCBufferedDataOutputStreamBytesWritten( _MulleObjCBufferedDataOutputStream *_self)
{
   struct { @defs( _MulleObjCBufferedDataOutputStream); }  *self = (void *) _self;
   
   return( self->_current - self->_start);
}

