//
//  _MulleObjCUTF8StreamReader+InlineAccessors.h
//  MulleObjCFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#define MULLE_OBJC_UTF8_STREAM_READER_IVAR_VISIBILITY  @public

#import "_MulleObjCUTF8StreamReader.h"

#import "_MulleObjCUTF8StreamReader+InlineAccessors.h"
#import "_MulleObjCBufferedDataInputStream+InlineAccessors.h"

#include <ctype.h>


// always returns 0
void   _MulleObjCUTF8StreamReaderFailV( _MulleObjCUTF8StreamReader *self, NSString *format, va_list args);

long   __NSUTF8StreamReaderDecomposeUTF32Character( _MulleObjCUTF8StreamReader *self, unsigned char x);
long   __NSUTF8StreamReaderUnescapedNextUTF32Character( _MulleObjCUTF8StreamReader *self);

static inline void   _MulleObjCUTF8StreamReaderBookmark( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   _MulleObjCBufferedDataInputStreamBookmark( self->_stream);
}


static inline MulleObjCMemoryRegion   _MulleObjCUTF8StreamReaderBookmarkedRegion( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   return( _MulleObjCBufferedDataInputStreamBookmarkedRegion( self->_stream));
}


static inline long   _MulleObjCUTF8StreamReaderCurrentUTF32Character( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   return( self->_current);
}

static inline long   __NSUTF8StreamReaderFirstUTF32Character( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   assert( self->_stream);

   self->_current = _MulleObjCBufferedDataInputStreamCurrentCharacter( self->_stream);
   if( self->_current >= 128)
      self->_current = __NSUTF8StreamReaderDecomposeUTF32Character( _self, (unsigned char) self->_current);
   return( self->_current);
}


static inline long   __NSUTF8StreamReaderNextUTF32Character( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   self->_current = _MulleObjCBufferedDataInputStreamNextCharacter( self->_stream);

   if( self->_current >= 128)
      self->_current = __NSUTF8StreamReaderDecomposeUTF32Character( _self, (unsigned char) self->_current);
   return( self->_current);
}


static inline long   _MulleObjCUTF8StreamReaderNextUTF32Character( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   self->_lineNr += self->_current == '\n';
   return( __NSUTF8StreamReaderNextUTF32Character( _self));
}


static inline void   _MulleObjCUTF8StreamReaderConsumeCurrentUTF32Character( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   self->_current = _MulleObjCBufferedDataInputStreamNextCharacter( self->_stream);

   if( self->_current >= 128)
      self->_current = __NSUTF8StreamReaderDecomposeUTF32Character( _self, (unsigned char) self->_current);
}


static inline long   _MulleObjCUTF8StreamReaderSkipWhite( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   while( isspace( (int) self->_current))
      _MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   return( self->_current);
}


static inline long   _MulleObjCUTF8StreamReaderSkipNonWhite( _MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   while( self->_current > 0 && ! isspace( (int) self->_current))
      _MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   return( self->_current);
}


static inline long   _MulleObjCUTF8StreamReaderSkipUntil( _MulleObjCUTF8StreamReader *_self, long c)
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   while( self->_current > 0 && self->_current != c)
      _MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   return( self->_current);
}


static inline long   _MulleObjCUTF8StreamReaderSkipUntilUnquoted( _MulleObjCUTF8StreamReader *_self, long c)
{
   long  old;

   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   old = 0;
   while( self->_current > 0 && (self->_current != c || old == '\\'))
   {
      old = (c == '\\' && c == old) ? 0 : c;
      _MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   }
   return( self->_current);
}


static inline long   _MulleObjCUTF8StreamReaderSkipUntilTrue( _MulleObjCUTF8StreamReader *_self, BOOL (*f)( long))
{
   struct { @defs( _MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   while( self->_current > 0 && ! (*f)( self->_current))
      _MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   return( self->_current);
}



static inline void   *_MulleObjCUTF8StreamReaderFail( _MulleObjCUTF8StreamReader *self, NSString *format, ...)
{
   va_list   args;

   va_start( args, format);

   _MulleObjCUTF8StreamReaderFailV( self, format, args);

   va_end( args);

   return( NULL);
}
