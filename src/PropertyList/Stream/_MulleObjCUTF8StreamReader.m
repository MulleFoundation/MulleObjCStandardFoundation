//
//  _MulleObjCUTF8StreamReader.m
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
#import "_MulleObjCUTF8StreamReader+InlineAccessors.h"
#import "_MulleObjCUTF8StreamReader.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


const size_t   _MulleObjCUTF8StreamReaderDefaultBufferSize = 0x1000;


@implementation _MulleObjCUTF8StreamReader

- (instancetype) initWithBufferedInputStream:(_MulleObjCBufferedDataInputStream *) stream
{
   NSCParameterAssert( [stream isKindOfClass:[_MulleObjCBufferedDataInputStream class]]);

   [self init];

   _stream = [stream retain];

   // get first character loaded in
   __NSUTF8StreamReaderFirstUTF32Character( self);
   // set first lineNr
   self->_lineNr = 1;

   return( self);
}


- (instancetype) initWithString:(NSString *) s
{
   _MulleObjCBufferedDataInputStream  *stream;
   NSData                            *data;

   [self init];

   data   = [s dataUsingEncoding:NSUTF8StringEncoding];
   stream = [[[_MulleObjCBufferedDataInputStream alloc] initWithData:data] autorelease];

   return( [self initWithBufferedInputStream:stream]);
}


- (void) dealloc
{
   [_stream release];

   [super dealloc];
}


- (void) bookmark
{
   [_stream bookmark];
}


- (BOOL) throwExceptionOnError
{
   return( NO);
}


- (NSData *) bookmarkedData
{
   // our stop and quote characters are ASCII...

   return( [_stream bookmarkedData]);
}


- (MulleObjCMemoryRegion) bookmarkedRegion
{
   return( [_stream bookmarkedRegion]);
}


- (void) logFailure:(NSString *) format
            varargList:(va_list) args
{
   NSString   *s;

   s = [NSString stringWithFormat:format
                          varargList:args];
   fprintf( stderr, "%s\n", [s UTF8String]);
}


/*
   00000000-01111111 	00-7F 	0-127        	US-ASCII (single byte)
   10000000-10111111 	80-BF 	128-191 	Second, third, or fourth byte of a multi-byte sequence
   11000000-11000001 	C0-C1 	192-193 	Overlong encoding: start of a 2-byte sequence, but code point <= 127
   11000010-11011111 	C2-DF 	194-223 	Start of 2-byte sequence
   11100000-11101111 	E0-EF 	224-239 	Start of 3-byte sequence
   11110000-11110100 	F0-F4 	240-244 	Start of 4-byte sequence
   11110101-11110111 	F5-F7 	245-247 	Restricted by RFC 3629: start of 4-byte sequence for codepoint above 10FFFF
   11111000-11111011 	F8-FB 	248-251 	Restricted by RFC 3629: start of 5-byte sequence
   11111100-11111101 	FC-FD 	252-253 	Restricted by RFC 3629: start of 6-byte sequence
  11111110-11111111 	FE-FF 	254-255 	Invalid: not defined by original UTF-8 specification
*/

//
// sigh... bits are not very cleverly ordered in UTF8...
// what happened before this call, someone peaked at the current character
// and saw that top bit was set
//
long   __NSUTF8StreamReaderDecomposeUTF32Character( _MulleObjCUTF8StreamReader *self, unsigned char x)
{
   int    i;
   long   value;
   int    c;

   if( x < 0xC2) // invalid at start
      return( x);

   i     = 0;
   value = x & ((x < 0xE0) ? 0x1E : (x < 0xF0) ? 0xF : 0x3);

   do
   {
      c = _MulleObjCBufferedDataInputStreamNextCharacter( self->_stream);

      if( c < 0)
         return( 0xFFFD);  // replacement character for corrupted stuff at end of file
      x = (unsigned char) c;
      if( (x & 0xC0) != 0x80) // invalid in the middle
         break;
      value <<= 6;
      value  |= x & 0x3F;
   }
   while( ++i < 4);

   return( value);
}


void   _MulleObjCUTF8StreamReaderFailV( _MulleObjCUTF8StreamReader *self, NSString *format, va_list args)
{
   if( ! [self throwExceptionOnError])
      [self logFailure:format
               varargList:args];
   else
      [NSException raise:@"_MulleObjCUTF8StreamReaderException"
                  format:format
                 varargList:args];
}


@end
