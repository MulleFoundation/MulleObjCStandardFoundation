// std-c and other dependencies
#import <MulleObjC/private/mulle-objc-universeconfiguration-private.h>
#include <stdlib.h>


static void   bang( struct _mulle_objc_universe *universe,
                    void *userinfo)
{
   struct _mulle_objc_universeconfiguration   config;

   mulle_foundation_universeconfiguration_set_defaults( &config);
   mulle_objc_universe_configure( universe, &config);
}


