// std-c and other dependencies
#import <MulleObjC/ns_objc_setup.h>
#include <stdlib.h>


static void   bang( struct _mulle_objc_universe *universe,
                    void (*crunch)( void),
                    void *userinfo)
{
   struct _ns_foundation_setupconfig   setup;

   MulleObjCFoundationGetDefaultSetupConfig( &setup, universe);
#ifdef FOUNDATION_VERSION_ASSERT
   setup.config.universe.versionassert = versionassert;
#endif
   ns_objc_universe_setup( universe, &setup.config);
}


MULLE_C_CONST_RETURN  // always returns same value (in same thread)
struct _mulle_objc_universe  *__get_or_create_mulle_objc_universe( void)
{
   struct _mulle_objc_universe   *universe;

   universe = __mulle_objc_get_universe();
   if( ! _mulle_objc_universe_is_initialized( universe))
      _mulle_objc_universe_bang( universe, bang, NULL, NULL);

   return( universe);
}


#ifdef __APPLE__

#pragma mark -
#pragma mark logging

//
// see: https://stackoverflow.com/questions/35998488/where-is-the-eprintf-symbol-defined-in-os-x-10-11/36010972#36010972
//
__attribute__((visibility("hidden")))
void __eprintf( const char* format, const char* file,
               unsigned line, const char *expr)
{
   fprintf( stderr, format, file, line, expr);
   abort();
}

#endif
