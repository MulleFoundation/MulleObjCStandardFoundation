/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSPropertyListSerialization.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "MulleObjCFoundationCore.h"


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
   struct mulle_pointerarray    _objStack;     // useful for XML (autoreleased)
   struct mulle_pointerarray    _keyStack;     // useful for XML (autoreleased)
   id                           _textStorage;  // useful for XML
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

// supplied by expat...
- (id) _parseXMLData:(NSData *) data;

@end

