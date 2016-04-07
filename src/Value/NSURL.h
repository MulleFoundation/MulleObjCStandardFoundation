/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSURL.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
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

