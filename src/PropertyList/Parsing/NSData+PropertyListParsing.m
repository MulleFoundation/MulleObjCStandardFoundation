//
//  NSData+PropertyListParsing.m
//  MulleObjCFoundation
//
//  Copyright (c) 2009 Nat! - Mulle kybernetiK.
//  Copyright (c) 2009 Codeon GmbH.
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
#import "NSData+PropertyListParsing.h"

// other files in this library
#import "NSObject+PropertyListParsing.h"
#import "_MulleObjCPropertyListReader.h"
#import "_MulleObjCPropertyListReader+InlineAccessors.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSData ( NSPropertyListParsing)


static inline int   hex( _MulleObjCPropertyListReader *reader, char c)
{
    switch( c) 
    {
    case '0': 
    case '1': 
    case '2': 
    case '3': 
    case '4':
    case '5': 
    case '6': 
    case '7': 
    case '8': 
    case '9':
        return( c - '0'); 
    
    case 'A': 
    case 'B': 
    case 'C':
    case 'D': 
    case 'E':
    case 'F':
        return( c - 'A' + 10); 
    
    case 'a': 
    case 'b': 
    case 'c':
    case 'd': 
    case 'e': 
    case 'f':
        return( c - 'a' + 10); 

    default:
        _MulleObjCPropertyListReaderFail( reader, @"invalid hex nybble '%c' ($%X)", c, c);
        return( 0);
   }
}


NSData   *_MulleObjCNewDataFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   MulleObjCMemoryRegion  region;
   NSMutableData   *buffer;
   long            x;
   unsigned char   *src;
   unsigned char   *dst;
   unsigned char   *start;
   unsigned char   *srcSentinel;
   //unsigned char   *dstSentinel;
   size_t          len;
   
   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader); // skip '<'
   if( x != '<')
      return( nil);
      
   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '<'
   x = _MulleObjCPropertyListReaderSkipWhite( reader);
   if( x == '>')
   {
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '<'
      return( [reader->nsDataClass new]);
   }
   
   [reader bookmark];
   
   _MulleObjCPropertyListReaderSkipUntil( reader, '>');
   
   region = _MulleObjCPropertyListReaderBookmarkedRegion( reader);
   
   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader);
   if( x != '>')
      return( (id) _MulleObjCPropertyListReaderFail( reader, @"unexpected garbage at end of NSData"));
      
   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '>'
   
   len         = region.length;
   buffer      = [[NSMutableData alloc] initWithLength:len / 2];
   
   src         = region.bytes;
   srcSentinel = &src[ len];   

   dst         = (unsigned char *) [buffer mutableBytes];
   //dstSentinel = &dst[ len / 2];   
   start       = dst;
   
   while( src < srcSentinel)
   {
      if( *src == ' ')
      {
         ++src;
         continue;
      }
         
      *dst++ = (unsigned char) ((hex( reader,  src[ 0]) << 4) | hex( reader, src[ 1]));
      src   += 2;
   }
   
   [buffer setLength:dst-start];
   
   return( buffer);
}


@end
