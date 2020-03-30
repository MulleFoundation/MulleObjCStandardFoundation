//
//  _MulleObjCPropertyListReader+InlineAccessors.h
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
#import "_MulleObjCPropertyListReader.h"

#import "_MulleObjCPropertyListReader+InlineAccessors.h"
#import "MulleObjCUTF8StreamReader+InlineAccessors.h"


static inline void
   _MulleObjCPropertyListReaderBookmark( _MulleObjCPropertyListReader *self)
{
   MulleObjCUTF8StreamReaderBookmark( (MulleObjCUTF8StreamReader *) self);
}


static inline MulleObjCMemoryRegion
   _MulleObjCPropertyListReaderBookmarkedRegion( _MulleObjCPropertyListReader *self)
{
   return( MulleObjCUTF8StreamReaderBookmarkedRegion( (MulleObjCUTF8StreamReader *) self));
}


static inline long
   _MulleObjCPropertyListReaderCurrentUTF32Character( _MulleObjCPropertyListReader *self)
{
   return( MulleObjCUTF8StreamReaderCurrentUTF32Character( (MulleObjCUTF8StreamReader *) self));
}


static inline long
   __NSPropertyListReaderNextUTF32Character( _MulleObjCPropertyListReader *self)
{
   return( __MulleObjCUTF8StreamReaderNextUTF32Character( (MulleObjCUTF8StreamReader *) self));
}


static inline long
   _MulleObjCPropertyListReaderNextUTF32Character( _MulleObjCPropertyListReader *self)
{
   return( MulleObjCUTF8StreamReaderNextUTF32Character( (MulleObjCUTF8StreamReader *) self));
}


static inline void
   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( _MulleObjCPropertyListReader *self)
{
   MulleObjCUTF8StreamReaderConsumeCurrentUTF32Character( (MulleObjCUTF8StreamReader *) self);
}


static inline long
   _MulleObjCPropertyListReaderSkipWhite( _MulleObjCPropertyListReader *self)
{
   return( MulleObjCUTF8StreamReaderSkipWhite( (MulleObjCUTF8StreamReader *) self));
}


static inline long
   _MulleObjCPropertyListReaderSkipWhiteAndComments( _MulleObjCPropertyListReader *self)
{
   return( MulleObjCUTF8StreamReaderSkipWhiteAndComments( (MulleObjCUTF8StreamReader *) self));
}


static inline long
   _MulleObjCPropertyListReaderSkipNonWhite( _MulleObjCPropertyListReader *self)
{
   return( MulleObjCUTF8StreamReaderSkipNonWhite( (MulleObjCUTF8StreamReader *) self));
}


static inline long
   _MulleObjCPropertyListReaderSkipUntil( _MulleObjCPropertyListReader *self,
                                          long c)
{
   return( MulleObjCUTF8StreamReaderSkipUntil( (MulleObjCUTF8StreamReader *) self, c));
}


static inline long
   _MulleObjCPropertyListReaderSkipUntilUnquoted( _MulleObjCPropertyListReader *self,
                                                  long c)
{
   return( MulleObjCUTF8StreamReaderSkipUntilUnquoted( (MulleObjCUTF8StreamReader *) self, c));
}


static inline long
   _MulleObjCPropertyListReaderSkipUntilTrue( _MulleObjCPropertyListReader *self,
                                              BOOL (*f)( _MulleObjCPropertyListReader *self, long))
{
   return( MulleObjCUTF8StreamReaderSkipUntilTrue( (MulleObjCUTF8StreamReader *) self,
                                                    (BOOL (*)( MulleObjCUTF8StreamReader *, long)) f));
}


static inline void   *
   _MulleObjCPropertyListReaderFail( _MulleObjCPropertyListReader *self,
                                     NSString *format, ...)
{
   va_list   args;

   va_start( args, format);

   MulleObjCUTF8StreamReaderFailV( (MulleObjCUTF8StreamReader *) self, format, args);

   va_end( args);

   return( NULL);
}


extern BOOL   _MulleObjCPropertyListReaderIsUnquotedStringEndChar(
            _MulleObjCPropertyListReader *reader, long _c);
extern BOOL   _MulleObjCPropertyListReaderIsUnquotedStringStartChar(
         _MulleObjCPropertyListReader *reader, long _c);
