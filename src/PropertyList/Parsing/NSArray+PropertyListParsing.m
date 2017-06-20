//
//  NSArray+PropertyListParsing.m
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
#import "NSArray+PropertyListParsing.h"

// other files in this library
#import "NSObject+PropertyListParsing.h"
#import "_MulleObjCPropertyListReader+InlineAccessors.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation NSArray ( NSPropertyListParsing)

NSArray   *_MulleObjCNewArrayFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   NSMutableArray   *result;
   id               element;
   long             x;

   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader);
   if (x != '(')
      return( _MulleObjCPropertyListReaderFail( reader, @"did not find array (expected '(')"));


   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '('
   x = _MulleObjCPropertyListReaderSkipWhite( reader);

   if( x == ')')
   { // an empty array
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip ')'
      return( [reader->nsArrayClass new]);
   }

   result = [NSMutableArray new];
   for(;;)
   {
      element = _MulleObjCNewFromPropertyListWithStreamReader( reader);
      if( ! element)
      {
         [result release];  // NSParse already complained
         return( nil);
      }
      [result addObject:element];
      [element release];

      _MulleObjCPropertyListReaderSkipWhite( reader);
      x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader); // check 4 ')'
      if( x == ',')
      {
         _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
         _MulleObjCPropertyListReaderSkipWhite( reader);
         continue;
      }

      if( x == ')')
      {
         _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
         break;
      }

      [result release];
      return( _MulleObjCPropertyListReaderFail( reader, x < 0
                                       ? @"array was not closed (expected ')')"
                                       : @"expected ')' or ',' after array element"));
   }
   return( result);
}

@end
