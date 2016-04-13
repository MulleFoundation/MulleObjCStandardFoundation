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


//
// used to be used for foundation specific stuff, but currently there is
// none...
//
struct _ns_foundationconfiguration
{
   struct _ns_rootconfiguration   root;
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
