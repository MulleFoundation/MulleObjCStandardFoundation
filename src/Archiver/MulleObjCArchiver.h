//
//  MulleObjCArchiver.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "NSCoder.h"

#include <mulle_buffer/mulle_buffer.h>
#include "ns_map_table.h"


struct MulleObjCPointerHandleMap
{
   struct mulle_map             map;
   struct mulle_pointerarray    array;
};


@class NSData;
@class NSMutableData;

extern NSString  *NSInconsistentArchiveException;
extern NSString  *NSInvalidArchiveOperationException;

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
