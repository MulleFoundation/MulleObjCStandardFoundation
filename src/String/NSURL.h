//
//  NSURL.h
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
#import <MulleObjC/MulleObjC.h>


@class NSString;
@class NSNumber;
@class NSArray;

//
// the URL will "preparse" the urlString. This makes URL objects
// fairly "fat". To store many URLs just keep them as strings and
// convert to NSURL as necessary
// WARNING!! NOT MUCH WORKING YET!
@interface NSURL : NSObject < NSCopying>

@property( copy) NSString   *scheme;
@property( copy) NSString   *user;
@property( copy) NSString   *password;
@property( copy) NSString   *host;
@property( copy) NSNumber   *port;
@property( copy) NSString   *path;
@property( copy) NSString   *fragment;
@property( copy) NSString   *query;
@property( copy) NSString   *parameterString;

+ (instancetype) URLWithString:(NSString *) s;

- (instancetype) initWithScheme:(NSString *) scheme
                           host:(NSString *) host
                           path:(NSString *) path;
- (instancetype) initWithString:(NSString *) URLString;
- (instancetype) initWithString:(NSString *) URLString
                  relativeToURL:(NSURL *) baseURL;

- (NSString *) absoluteString;
- (NSString *) parameterString;
- (NSString *) relativePath;
- (NSString *) relativeString;
- (NSString *) resourceSpecifier;

- (NSArray *) pathComponents;
- (NSString *) lastPathComponent;
- (NSString *) pathExtension;

- (NSURL *) absoluteURL;
- (NSURL *) baseURL;
- (NSURL *) standardizedURL;

#pragma mark -

- (BOOL) isFileURL;
- (BOOL) isAbsolutePath;

@end
