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
#import "NSArray.h"

#import "MulleObjCPropertyListPrinting.h"

// std-c and dependencies


@implementation NSDictionary( PropertyListPrinting)


typedef struct
{
    NSString   *keyDescription;
    NSString   *valueDescription;
} __KeyValueDescription;


- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                               indent:(NSUInteger) indent
{
   id              key, value;
   NSData          *keyData;
   NSData          *valueData;
   NSData          *indentation1;
   NSArray         *keys;
   unsigned        indent1;

   indent1 = indent + 1;

   if( ! [self count])
   {
      [handle writeBytes:"{}"
                  length:2];
      return;
   }

   [handle writeBytes:"{\n"
               length:2];
   indentation1 = [self propertyListUTF8DataIndentation:indent1];

   // don't really care if sorted or not but WTF.. :)
   keys = [[self allKeys] sortedArrayUsingSelector:@selector( mulleCompareDescription:)];
   for( key in keys)
   {
      value = [self objectForKey:key];

      keyData   = [key propertyListUTF8DataWithIndent:indent1];
      valueData = [value propertyListUTF8DataWithIndent:indent1];

      [handle writeData:indentation1];
      [handle writeData:keyData];
      [handle writeBytes:" = "
                  length:3];
      [handle writeData:valueData];
      [handle writeBytes:";\n"
                  length:1];
   }

   [handle writeData:[self propertyListUTF8DataIndentation:indent]];
   [handle writeBytes:"}"
               length:1];
}

@end
