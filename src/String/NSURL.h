/*
 *  MulleFoundation - the mulle-objc class library
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

