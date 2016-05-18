//
//  MulleObjCArchiver.h
//  MulleObjCFoundation
//
//  Created by Nat! on 20.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import <MulleObjC/MulleObjC.h>


#import <mulle_container/mulle_container.h>
#import "ns_map_table.h"


struct MulleObjCPointerHandleMap
{
   struct mulle_map             map;
   struct mulle_pointerarray    array;
};


@class NSData;
@class NSMutableData;

extern NSString  *NSInconsistentArchiveException;


//
// the MulleObjCArchiver supplies the mechanics but actually does not
// do the NSCoder protocol stuff except "encodeRootObject"
//
@interface MulleObjCArchiver : NSCoder
{
   struct mulle_buffer                      _buffer;
   
   struct MulleObjCPointerHandleMap         _objects;
   struct MulleObjCPointerHandleMap         _conditionalObjects;
   struct MulleObjCPointerHandleMap         _classes;
   struct MulleObjCPointerHandleMap         _selectors;
   
   struct mulle_container_keyvaluecallback  _callback;
   
   struct MulleObjCPointerHandleMap         _blobs;
   struct mulle_container_keyvaluecallback  _blob_callback;
   
   NSMapTable                               *_classNameSubstitutions;
   NSMapTable                               *_objectSubstitutions;
   NSMapTable                               *_offsets;
   
   intptr_t                                 _objectHandle;
   
   struct mulle_allocator                   _allocator;
}


+ (NSData *) archivedDataWithRootObject:(id) rootObject;

- (void) encodeRootObject:(id) rootObject;
- (NSString *) classNameEncodedForTrueClassName:(NSString *) trueName;
- (void) encodeClassName:(NSString *) runtime
           intoClassName:(NSString *) archive;


- (NSMutableData *) archiverData;

@end
