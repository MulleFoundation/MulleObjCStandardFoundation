//
//  MulleObjCUnarchiver.h
//  MulleObjCFoundation
//
//  Created by Nat! on 20.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import <MulleObjC/MulleObjC.h>

#import <mulle_container/mulle_container.h>
#import "ns_map_table.h"
#import "ns_hash_table.h"

@class NSData;

extern NSString  *NSInconsistentArchiveException;


@interface MulleObjCUnarchiver : NSCoder
{
   struct mulle_buffer   _buffer;
   
   NSMapTable            *_objects;
   NSMapTable            *_offsets;
   NSMapTable            *_classes;
   NSMapTable            *_selectors;
   NSMapTable            *_blobs;
   
   NSMapTable            *_classNameSubstitutions;
   NSMapTable            *_objectSubstitutions;
   
   NSData                *_data;
   NSUInteger            _decoded;

   BOOL                  _inited;
}


- (instancetype) initForReadingWithData:(NSData *)data;

- (BOOL) atEnd;
- (NSInteger) systemVersion;

+ (id) unarchiveObjectWithData:(NSData *) data;

- (void) decodeClassName:(NSString *) inArchiveName
             asClassName:(NSString *) trueName;

- (NSString *) classNameDecodedForArchiveClassName:(NSString *) inArchiveName;

- (void) replaceObject:(id) object
            withObject:(id) newObject;

@end
