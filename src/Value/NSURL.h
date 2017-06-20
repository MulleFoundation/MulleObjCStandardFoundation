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


@class NSArray;
@class NSData;
@class NSNumber;
@class NSString;
@class NSMutableString;


@interface NSURL : NSObject < NSCopying>
{
   NSString   *_scheme;
   NSString   *_user;
   NSString   *_password;
   NSString   *_host;
   NSNumber   *_port;
   NSString   *_path;
   NSString   *_fragment;
   NSString   *_query;
   NSString   *_parameterString;
}

- (id) initWithScheme:(NSString *) scheme
                 host:(NSString *) host
                 path:(NSString *) path;
- (id) initWithString:(NSString *) URLString;
- (id) initWithString:(NSString *) URLString
        relativeToURL:(NSURL *) baseURL;

- (NSNumber *) port;

- (NSString *) absoluteString;
- (NSString *) fragment;
- (NSString *) host;
- (NSString *) parameterString;
- (NSString *) password;
- (NSString *) path;
- (NSString *) query;
- (NSString *) relativePath;
- (NSString *) relativeString;
- (NSString *) resourceSpecifier;
- (NSString *) scheme;

- (NSArray *) pathComponents;
- (NSString *) lastPathComponent;
- (NSString *) pathExtension;

- (NSURL *) absoluteURL;
- (NSURL *) baseURL;
- (NSURL *) standardizedURL;

@end
