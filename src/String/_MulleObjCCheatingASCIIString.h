//
//  _MulleObjCCheatingUTF8String.h
//  MulleObjCFoundation
//
//  Created by Nat! on 17.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCASCIIString.h"


@interface _MulleObjCCheatingASCIIString : _MulleObjCReferencingASCIIString
@end


//
// the cheating ASCII String is used internally for "on stack" objects
// for these very special moments
//
struct _MulleObjCCheatingASCIIStringStorage
{
   struct _mulle_objc_objectheader   _header;
   @defs( _MulleObjCCheatingASCIIString);
};



static inline id   _MulleObjCCheatingASCIIStringStorageGetObject( struct _MulleObjCCheatingASCIIStringStorage *p)
{
   return( (id) _mulle_objc_objectheader_get_object( &p->_header));
}


static inline char  *_MulleObjCCheatingASCIIStringStorageGetStorage( struct _MulleObjCCheatingASCIIStringStorage *p)
{
   return( p->_storage);
}


static inline size_t  _MulleObjCCheatingASCIIStringStorageGetLength( struct _MulleObjCCheatingASCIIStringStorage *p)
{
   return( p->_length);
}


static inline id   _MulleObjCCheatingASCIIStringStorageInit( struct _MulleObjCCheatingASCIIStringStorage *storage,
                                                             char *buf,
                                                             NSUInteger length)
{
   _MulleObjCCheatingASCIIString   *p;
   
   p = _MulleObjCCheatingASCIIStringStorageGetObject( storage);
   
   _mulle_objc_object_infinite_retain( p);
   _mulle_objc_object_set_isa( p, [_MulleObjCCheatingASCIIString class]);
   
   storage->_storage = buf;
   storage->_length  = length;

   return( p);
}
