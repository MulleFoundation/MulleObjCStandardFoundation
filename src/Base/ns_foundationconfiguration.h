//
//  ns_foundation_configuration.h
//  MulleObjCFoundation
//
//  Created by Nat! on 15.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifndef ns_foundationconfiguration_h__
#define ns_foundationconfiguration_h__

#include <MulleObjC/ns_type.h>
#include <MulleObjC/ns_rootconfiguration.h>


#define MULLE_OBJC_ALLOC_PLACEHOLDER         0
#define MULLE_OBJC_INSTANTIATE_PLACEHOLDER   1


struct _ns_empty
{
   void   *emptyArray;
   void   *emptyDictionary;
   void   *emptySet;
   void   *emptyNull;
};


struct _ns_foundationconfiguration
{
   struct _ns_rootconfiguration   root;
   struct _ns_empty               empty;
};


struct _ns_foundation_setupconfig
{
   struct _ns_root_setupconfig   config;
};



void   _ns_foundation_setup( struct _mulle_objc_runtime *runtime,
                             struct _ns_foundation_setupconfig *config);



__attribute__((const, returns_nonnull))  // always returns same value (in same thread)
static inline struct _ns_foundationconfiguration   *_ns_get_foundationconfiguration( void)
{
   return( (struct _ns_foundationconfiguration *) _ns_get_rootconfiguration());
}

#endif
