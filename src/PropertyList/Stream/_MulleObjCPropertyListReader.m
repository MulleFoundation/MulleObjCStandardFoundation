//
//  _MulleObjCPropertyListReader.m
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

// other files in this library
#import "_MulleObjCPropertyListReader+InlineAccessors.h"
#import "MulleObjCBufferedInputStream.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation _MulleObjCPropertyListReader

- (id) init
{
   nsArrayClass      = [NSMutableArray class];
   nsSetClass        = [NSMutableSet class];
   nsDictionaryClass = [NSMutableDictionary class];
   nsStringClass     = [NSString class];
   nsDataClass       = [NSData class];
   nsNull            = [[NSNull null] retain];
   return( self);
}


- (void) dealloc
{
   [nsNull release];
   [super dealloc];
}


- (instancetype) initWithBufferedInputStream:(MulleObjCBufferedInputStream *) stream
{
   //
   // this will consume first character
   //
   self = [super initWithBufferedInputStream:stream];
   if( self)
   {
      [self setThrowsException:YES];
      _MulleObjCPropertyListReaderSkipWhite( self); // dial up to first interesting char
   }
   return( self);
}

//- (instancetype) init
//{
//   [super init];
//
//   [self setMutableContainers:NO];
//   [self setMutableLeaves:NO];
//
//   return( self);
//}

BOOL   _MulleObjCPropertyListReaderIsUnquotedStringEndChar(
            _MulleObjCPropertyListReader *reader, long _c)
{
   // mostly compatible to Apple (which is good for us)
   // except, that we support +-. Ee  for doubles
   if( [reader decodesPBX] &&
         (
            _c  == '_' ||
            _c == '/'  ||
            _c == '.'  ||
            _c == '$'
         )
      )
      return( NO);

   // still want those but not as a number
   if( /* [reader decodesNumber]  && */
         (
            _c == '+'  ||
            _c  == '-' ||
            _c == '.'
         )
      )
      return( NO);

   if( _c < 127 && isalnum( _c))
      return( NO);
   return( YES);
}


BOOL  _MulleObjCPropertyListReaderIsUnquotedStringStartChar(
         _MulleObjCPropertyListReader *reader, long _c)
{
   // mostly compatible to Apple (which is good for us)
   // except, that we support +-. Ee  for doubles
   if( [reader decodesPBX] &&
         (
            _c == '_' ||
            _c == '/' ||
            _c == '.' ||
            _c == '$'
         )
      )
      return( YES);

   if( [reader decodesNumber] &&
         (
            _c == '+' ||
            _c == '-'
         )
      )
      return( YES);

   if( _c < 127 && isalnum( _c))
      return( YES);
   return( NO);
}

@end
