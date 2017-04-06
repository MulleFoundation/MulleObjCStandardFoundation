//
//  NSString+PropertyListPrinting.m
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

#import "NSString+PropertyListPrinting.h"

// other files in this library
#import "NSData+PropertyListPrinting.h"

// std-c and dependencies


@implementation NSString ( PropertyListPrinting)

//
// this is probably too slow
//
- (NSData *) propertyListUTF8DataWithIndent:(unsigned int) indent
{
   NSData          *data;
   unsigned char   *s, *start;
   unsigned char   *q, *sentinel;
   size_t          len;
   NSMutableData   *target;

   // don't do this for larger strings
   data = [self dataUsingEncoding:NSUTF8StringEncoding];
   if( ! [data propertyListUTF8DataNeedsQuoting])
      return( data);

   // do proper quoting and escaping
   len    = [data length];
   target = [NSMutableData dataWithLength:len * 2 + 2];
   start  = (unsigned char *) [target mutableBytes];
   s      = start;
   q      = (unsigned char *) [data bytes];

   sentinel = &q[ len];
   *s++     = '\"';

   do
   {
      switch( *q)
      {
      default   : *s++ = *q; break;
      case '\a' : *s++ = '\\'; *s++ = 'a'; break;
      case '\b' : *s++ = '\\'; *s++ = 'b'; break;
      case '\f' : *s++ = '\\'; *s++ = 'f'; break;
      case '\n' : *s++ = '\\'; *s++ = 'n'; break;
      case '\r' : *s++ = '\\'; *s++ = 'r'; break;
      case '\t' : *s++ = '\\'; *s++ = 't'; break;
      case '\v' : *s++ = '\\'; *s++ = 'v'; break;
      case '\\' : *s++ = '\\'; *s++ = '\\'; break;
      case '\"' : *s++ = '\\'; *s++ = '\"'; break;
#if ESCAPED_ZERO_IN_UTF8_STRING_IS_A_GOOD_THING
      case 0    : *s++ = '\\'; *s++ = '0'; break;
#endif
      }
   }
   while( ++q < sentinel);

   *s++   = '\"';

   [target setLength:s - start];
   return( target);
}


@end
