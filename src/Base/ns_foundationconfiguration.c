//
//  ns_foundation_configuration.c
//  MulleObjCFoundation
//
//  Created by Nat! on 15.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#include "ns_foundationconfiguration.h"


void   _ns_foundation_setup( struct _mulle_objc_runtime *runtime,
                             struct _ns_foundation_setupconfig *setup)
{
   struct _ns_foundationconfiguration   *foundation;

   assert( setup->config.foundation.configurationsize >= sizeof( *foundation));
   
   _ns_root_setup( runtime, &setup->config);

   
   // additional stuff ?
}
