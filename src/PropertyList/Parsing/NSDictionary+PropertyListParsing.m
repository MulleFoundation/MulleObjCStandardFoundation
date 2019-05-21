//
//  NSDictionary+PropertyListParsing.m
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
#import "NSDictionary+PropertyListParsing.h"

// other files in this library
#import "_MulleObjCPropertyListReader+InlineAccessors.h"
#import "NSObject+PropertyListParsing.h"
#import "NSString+PropertyListParsing.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation NSDictionary ( NSPropertyListParsing)

NSDictionary   *_MulleObjCNewDictionaryFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   NSMutableDictionary   *result;
   id                    key;
   long                  x;
   id                    value;

   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader);
   if (x != '{')
      return( (id) _MulleObjCPropertyListReaderFail( reader, @"did not find dictionary (expected '{')"));


   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '{'
   x = _MulleObjCPropertyListReaderSkipWhiteAndComments( reader);

   if( x == '}')
   { // an empty dictionary
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '}'
      return( [reader->nsDictionaryClass new]); //
   }

   result = [NSMutableDictionary new];
   for(;;)
   {
      key = _MulleObjCNewStringFromPropertyListWithReader( reader);
      if( ! key)
      {
         [result release];  // NSParse already complained
         return( nil);
      }

      if( key == [NSNull null])
         break;

      _MulleObjCPropertyListReaderSkipWhiteAndComments( reader);
      x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader); // check 4 '='
      if( x != '=')
      {
         [key release];
         [result release];
         return( (id) _MulleObjCPropertyListReaderFail( reader, @"expected '=' after key in dictionary"));
      }
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);

      //
      // BUG: we don't support comments after the '='
      // Proper fix: put readahead character into the "reader", but this
      // slows everything down for no appreciable gain and supporting an
      // optional feature (and Xcode doesn't write comments after ' = ')
      // 
      _MulleObjCPropertyListReaderSkipWhite( reader);

      value = _MulleObjCNewFromPropertyListWithStreamReader( reader);
      if( ! value)
      {
         [key release];
         [result release];  // NSParse already complained
         return( nil);
      }

      NSCParameterAssert( ! [result objectForKey:key]);

      [result setObject:value
                 forKey:key];
      [value release];
      [key release];

      _MulleObjCPropertyListReaderSkipWhiteAndComments( reader);
      x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader); // check 4 ';}'
      if( x != ';')
      {
         if( x != '}')  // lenient, can skip last ';' but then must get '}''
         {
            [result release];
            return( (id) _MulleObjCPropertyListReaderFail( reader, @"expected ';' after value in dictionary"));
         }
      }
      else
      {
         _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
         x = _MulleObjCPropertyListReaderSkipWhiteAndComments( reader);
      }

      if( x == '}')
      {
         _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
         break;
      }

      if( x < 0)
      {
         [result release];
         return( (id) _MulleObjCPropertyListReaderFail( reader, @"dictionary was not closed (expected '}')"));
      }
   }

   return( result);
}

@end
