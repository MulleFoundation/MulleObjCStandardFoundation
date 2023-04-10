// std-c and other dependencies
#import <MulleObjC/mulle-objc-universeconfiguration-private.h>
#include <MulleObjC/mulle-objc-startup-private.inc>
#include <stdlib.h>


static inline void
   MulleObjCStandardFoundationBang( struct _mulle_objc_universe *universe,
                                    struct mulle_allocator *allocator,
                                    struct _mulle_objc_universeconfiguration *config)
{
   MulleObjCBang( universe, allocator, config);
}



