//
//  NSDictionary+PropertyListPrinting.m
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
#import "NSDictionary+PropertyListPrinting.h"

// other files in this library
#import "MulleObjCPropertyListPrinting.h"

// std-c and dependencies


BOOL   _MulleObjCPropertyListSortedDictionary;
BOOL   _MulleObjCJSONSortedDictionary;

@interface NSObject( _NS)

- (BOOL) __isNSString;
- (BOOL) __isNSNull;

@end


@implementation NSDictionary( PropertyListPrinting)

struct format_info
{
   char   empty[ 2];
   char   separator[ 2];
   char   separator2[ 1];
   char   opener[ 2];
   char   closer[ 1];
   char   divider[ 3];
   char   *(*indentFunction)(NSUInteger);
   SEL    memberMethod;
   SEL    keyMethod;
   BOOL   ignoreNSNull;
};


static struct format_info   plist_format_info =
{
   { '{', '}'      },  // empty
   { ';', '\n'     },  // separator
   { '\n'          },  // separator2
   { '{', '\n'     },  // opener
   { '}'           },  // closer
   { ' ', '=', ' ' },  // divider
   MulleObjCPropertyListUTF8DataIndentation,
   @selector( propertyListUTF8DataToStream:indent:),
   @selector( self),
   YES
};


static struct format_info   json_format_info =
{
   { '{', '}'    },    // empty
   { ',', '\n'   },    // separator
   { '\n'        },    // separator2
   { '{', '\n'   },    // opener
   { '}'         },    // closer
   { ':', ' ', 0 },    // divider
   MulleObjCJSONUTF8DataIndentation,
   @selector( jsonUTF8DataToStream:indent:),
   @selector( description),
   NO
};


//
// driven by formatInfo to support propertyList and JSON format
//
- (void) _UTF8DataToStream:(id <MulleObjCOutputStream>) handle
                    indent:(NSUInteger) indent
                formatInfo:(struct format_info *) info
                      sort:(BOOL) sort
{
   char         *indentation;
   id           key, value;
   NSArray      *keys;
   NSUInteger   n;
   size_t       length;

   n = [self count];
   if( ! n)
   {
      [handle mulleWriteBytes:info->empty
                       length:sizeof( info->empty)];
      return;
   }

   [handle mulleWriteBytes:info->opener
                    length:2];

   ++indent; // inside '{'
   indentation = (*info->indentFunction)( indent);
   length      = strlen( indentation);

   //
   // don't really care if sorted or not but WTF.. :)
   // + consistent output, easier to diff
   // - obviously slower, possibly a bottleneck for huge plists
   // thought: use plists for "huge" data ?
   //
   keys = [self allKeys];
   if( sort)
      keys = [keys sortedArrayUsingSelector:@selector( mulleCompareDescription:)];
   for( key in keys)
   {
      value = [self objectForKey:key];
      if( info->ignoreNSNull && [value __isNSNull])
         continue;

      [handle mulleWriteBytes:indentation
                       length:length];
      //[key propertyListUTF8DataToStream:handle
      //                           indent:0];
      key = MulleObjCObjectPerformSelector0( key, info->keyMethod);
      MulleObjCObjectPerformSelector2( key, info->memberMethod, handle, (id) (intptr_t) indent);
      [handle mulleWriteBytes:info->divider
                       length:info->divider[ 2] ? 3 : 2];
      //[value propertyListUTF8DataToStream:handle
      //                           indent:0];
      MulleObjCObjectPerformSelector2( value, info->memberMethod, handle, (id) (intptr_t) indent);
      if( --n)
         [handle mulleWriteBytes:info->separator
                          length:sizeof( info->separator)];
      else
         [handle mulleWriteBytes:info->separator2
                          length:sizeof( info->separator2)];
   }

   indentation = (*info->indentFunction)( indent - 1);
   [handle mulleWriteBytes:indentation
                    length:-1];
   [handle mulleWriteBytes:info->closer
                    length:sizeof( info->closer)];
}


- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                                indent:(NSUInteger) indent
{
   [self _UTF8DataToStream:handle
                    indent:indent
                formatInfo:&plist_format_info
                      sort:_MulleObjCPropertyListSortedDictionary];
}


- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   [self _UTF8DataToStream:handle
                    indent:indent
                formatInfo:&json_format_info
                      sort:_MulleObjCJSONSortedDictionary];
}

@end
