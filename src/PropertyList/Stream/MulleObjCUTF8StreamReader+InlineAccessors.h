//
//  MulleObjCUTF8StreamReader+InlineAccessors.h
//  MulleObjCStandardFoundation
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

#import "MulleObjCUTF8StreamReader.h"

#import "MulleObjCUTF8StreamReader+InlineAccessors.h"
#import "MulleObjCBufferedInputStream+InlineAccessors.h"

#include <ctype.h>


// always returns 0
void   MulleObjCUTF8StreamReaderFailV( MulleObjCUTF8StreamReader *self, NSString *format, va_list args);

long   __MulleObjCUTF8StreamReaderComposeUTF32Character( MulleObjCUTF8StreamReader *self, unsigned char x);
long   __MulleObjCUTF8StreamReaderUnescapedNextUTF32Character( MulleObjCUTF8StreamReader *self);

//
// if a stray '/' is encountered, then the return value
// will be '/', but the return value of ...CurrentUTF32Character will
// be the character behind it. It can not be a '/' as this would be the
// comment. So this is easy, though inconvenient, to test against.
//
long   MulleObjCUTF8StreamReaderSkipWhiteAndComments( MulleObjCUTF8StreamReader *_self);

static inline void
   MulleObjCUTF8StreamReaderBookmark( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   MulleObjCBufferedInputStreamBookmark( self->_stream);
}


static inline MulleObjCMemoryRegion
   MulleObjCUTF8StreamReaderBookmarkedRegion( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   return( MulleObjCBufferedInputStreamBookmarkedRegion( self->_stream));
}


static inline long
   MulleObjCUTF8StreamReaderCurrentUTF32Character( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   return( self->_current);
}


static inline long
   __MulleObjCUTF8StreamReaderFirstUTF32Character( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   assert( self->_stream);

   self->_current = MulleObjCBufferedInputStreamCurrentCharacter( self->_stream);
   if( self->_current >= 128)
      self->_current = __MulleObjCUTF8StreamReaderComposeUTF32Character( _self, (unsigned char) self->_current);
   return( self->_current);
}


static inline long
   __MulleObjCUTF8StreamReaderNextUTF32Character( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   self->_current = MulleObjCBufferedInputStreamNextCharacter( self->_stream);

   if( self->_current >= 128)
      self->_current = __MulleObjCUTF8StreamReaderComposeUTF32Character( _self, (unsigned char) self->_current);
   return( self->_current);
}


static inline long
   MulleObjCUTF8StreamReaderNextUTF32Character( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   self->_lineNr += self->_current == '\n';
   return( __MulleObjCUTF8StreamReaderNextUTF32Character( _self));
}


static inline void
   MulleObjCUTF8StreamReaderConsumeCurrentUTF32Character( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   self->_current = MulleObjCBufferedInputStreamNextCharacter( self->_stream);

   if( self->_current >= 128)
      self->_current = __MulleObjCUTF8StreamReaderComposeUTF32Character( _self, (unsigned char) self->_current);
}


static inline long
   MulleObjCUTF8StreamReaderSkipWhite( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   while( isspace( (int) self->_current))
      MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   return( self->_current);
}



static inline long
   MulleObjCUTF8StreamReaderSkipNonWhite( MulleObjCUTF8StreamReader *_self)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   while( self->_current > 0 && ! isspace( (int) self->_current))
      MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   return( self->_current);
}


static inline long
   MulleObjCUTF8StreamReaderSkipUntil( MulleObjCUTF8StreamReader *_self,
                                        long c)
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   while( self->_current > 0 && self->_current != c)
      MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   return( self->_current);
}


static inline long
   MulleObjCUTF8StreamReaderSkipUntilUnquoted( MulleObjCUTF8StreamReader *_self,
                                                long c)
{
   long  old;

   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   old = 0;
   while( self->_current > 0 && (self->_current != c || old == '\\'))
   {
      old = (c == '\\' && c == old) ? 0 : c;
      MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   }
   return( self->_current);
}


static inline long
   MulleObjCUTF8StreamReaderSkipUntilTrue( MulleObjCUTF8StreamReader *_self,
                                            BOOL (*f)( MulleObjCUTF8StreamReader *, long))
{
   struct { @defs( MulleObjCUTF8StreamReader); }  *self = (void *) _self;

   while( self->_current > 0 && ! (*f)( _self, self->_current))
   while( self->_current > 0 && ! (*f)( _self, self->_current))
      MulleObjCUTF8StreamReaderNextUTF32Character( _self);
   return( self->_current);
}



static inline void   *
   MulleObjCUTF8StreamReaderFail( MulleObjCUTF8StreamReader *self,
                                   NSString *format, ...)
{
   va_list   args;

   va_start( args, format);
   MulleObjCUTF8StreamReaderFailV( self, format, args);
   va_end( args);

   return( NULL);
}
