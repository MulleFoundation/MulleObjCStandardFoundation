//
//  NSPropertyListSerialization.h
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
#import "MulleObjCFoundationParent.h"


@class NSData;
@class NSString;


typedef enum
{
    NSPropertyListImmutable,
    NSPropertyListMutableContainers,
    NSPropertyListMutableContainersAndLeaves
} NSPropertyListMutabilityOptions;


typedef enum
{
    NSPropertyListOpenStepFormat    = 1, //,
    NSPropertyListXMLFormat_v1_0    = 100  // read, support with expat
//    NSPropertyListBinaryFormat_v1_0 = 200   // no support
} NSPropertyListFormat;


typedef NSUInteger   NSPropertyListReadOptions;
typedef NSUInteger   NSPropertyListWriteOptions;


@interface NSPropertyListSerialization : NSObject
{
@private
   struct mulle_pointerpairarray   _stack;          // useful for XML
   id                              _textStorage;    // useful for XML
   id                              _dateFormatter;  // ephemeral usage in XML
}

+ (NSData *) dataFromPropertyList:(id) plist
                           format:(NSPropertyListFormat) format
                 errorDescription:(NSString **)errorString;

+ (BOOL) propertyList:(id) plist
     isValidForFormat:(NSPropertyListFormat) format;

+ (id) propertyListFromData:(NSData *) data
           mutabilityOption:(NSPropertyListMutabilityOptions) opt
                     format:(NSPropertyListFormat *) format
           errorDescription:(NSString **) errorString;

@end


// supplied by expat.. (check OS specific Foundation)

@interface NSPropertyListSerialization (Future)

- (id) _parseXMLData:(NSData *) data;

@end
