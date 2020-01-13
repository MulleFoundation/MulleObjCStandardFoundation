//
//  NSData+PropertyListPrinting.m
//  MulleObjCStandardFoundation
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

#import "NSData+PropertyListPrinting.h"

// other files in this library
#import "MulleObjCPropertyListPrinting.h"

// std-c and dependencies
#include <ctype.h>


@implementation NSData ( PropertyListPrinting)

static inline unsigned char   toHex( unsigned char c)
{
   return( c >= 10 ? c + 'a' - 10 : c + '0');
}


- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                               indent:(NSUInteger) indent
{
   size_t          i, len;
   size_t          out_len;
   unsigned char   *p;
   unsigned char   *q;
   NSMutableData   *buffer;

   len     = [self length];
   out_len = 1 + len * 2 + ((len + 3) / 4) - 1 + 1;
   buffer  = [NSMutableData dataWithLength:out_len];

   p = (unsigned char *) [self bytes];
   q = (unsigned char *) [buffer bytes];

   *q++ = '<';
   for( i = 0; i < len; i++)
   {
      *q++ = toHex( *p >> 4);
      *q++ = toHex( *p & 0xF);
      ++p;
      if( (i & 0x3) == 3 && i != len -1)
         *q++ = ' ';
   }
   *q = '>';

   [handle writeData:buffer];
}



- (void) jsonUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                       indent:(NSUInteger) indent
{
   size_t          i, len;
   size_t          out_len;
   unsigned char   *p;
   unsigned char   *q;
   NSMutableData   *buffer;

   len     = [self length];
   out_len = 2 + 1 + len * 2 + ((len + 3) / 4) - 1 + 1;
   buffer  = [NSMutableData dataWithLength:out_len];

   p = (unsigned char *) [self bytes];
   q = (unsigned char *) [buffer bytes];

   *q++ = '"';
   *q++ = '<';
   for( i = 0; i < len; i++)
   {
      *q++ = toHex( *p >> 4);
      *q++ = toHex( *p & 0xF);
      ++p;
      if( (i & 0x3) == 3 && i != len -1)
         *q++ = ' ';
   }
   *q++ = '>';
   *q++ = '"';

   [handle writeData:buffer];
}


@end
