//
//  NSObject+PropertyListPrinting.h
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
#import "MulleObjCFoundationCore.h"
#import "MulleObjCStandardFoundationContainer.h"
#import "MulleObjCStandardFoundationString.h"

#import "MulleObjCStream.h"


// TODO: prefix with mulle, this is all incompatible

PROTOCOLCLASS_INTERFACE0( MulleObjCPropertyListPrinting)

// you need to implement some, but not all ... use the source

@optional

// simple conveniences to just get a list or json

- (NSString *) mullePropertyListDescription;
- (NSString *) mulleJSONDescription;

//
// this is what is called at the top. the idea is that
// MulleObjCOutputStream can be a NSFileHandle or a NSMutableData
// and that the plist or json is printed into
//
- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle;
- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle;

//
// This is what participating classes should implement
//
- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                               indent:(NSUInteger) indent;
- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent;


//
// For some classes, it may be more convenient to convert into an intermediate
// NSData first.
//
- (NSData *) propertyListUTF8DataWithIndent:(NSUInteger) indent;
- (NSData *) jsonUTF8DataWithIndent:(NSUInteger) indent;

PROTOCOLCLASS_END()


// these helper methods produce indentation
MULLE_C_NONNULL_RETURN
char   *MulleObjCPropertyListUTF8DataIndentation( NSUInteger level);

MULLE_C_NONNULL_RETURN
char   *MulleObjCJSONUTF8DataIndentation( NSUInteger level);


extern unsigned int   _MulleObjCPropertyListUTF8DataIndentationPerLevel;  //   = 1;
extern char           _MulleObjCPropertyListUTF8DataIndentationCharacter; //  = '\t';
extern BOOL           _MulleObjCPropertyListSortedDictionary; //  = YES
extern NSDictionary  *_MulleObjCPropertyListCanonicalPrintingLocale;

extern unsigned int   _MulleObjCJSONUTF8DataIndentationPerLevel;  //   = 1;
extern char           _MulleObjCJSONUTF8DataIndentationCharacter; //  = '\t';
extern BOOL           _MulleObjCJSONSortedDictionary; //  = YES
extern NSDictionary  *_MulleObjCJSONCanonicalPrintingLocale;
