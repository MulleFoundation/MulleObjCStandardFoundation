//
//  MulleObjCFoundationSetup.m
//  MulleObjCFoundation
//
//  Created by Nat! on 16.08.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "MulleObjCFoundationSetup.h"

// other files in this library
#import "MulleObjCFoundation.h"

// other libraries of MulleObjCFoundation

// std-c and other dependencies
#import <MulleObjC/ns_objc_setup.h>
#import <MulleObjC/ns_test_allocation.h>
#import <mulle_sprintf/mulle_sprintf.h>


#pragma mark -
#pragma mark versioning

static void   versionassert( struct _mulle_objc_runtime *runtime,
                            void *friend,
                            struct mulle_objc_loadversion *version)
{
   if( (version->foundation & ~0xFF) != (MULLE_OBJC_FOUNDATION_VERSION & ~0xFF))
      _mulle_objc_runtime_raise_inconsistency_exception( runtime, "mulle_objc_runtime %p: foundation version set to %x but runtime foundation is %x",
                                                        runtime,
                                                        version->foundation,
                                                        MULLE_OBJC_FOUNDATION_VERSION);
}



#pragma mark -
#pragma mark exception (mishandling)

extern void  _MulleObjCExceptionInitTable ( struct _ns_exceptionhandlertable *table);


#pragma mark -
#pragma mark setup and teardown ObjC

static void  tear_down()
{
   _NSThreadResignAsMainThread();
   
   // No Objective-C available anymore
}


static void  tear_down_and_check()
{
   tear_down();
   
   // clear up storage of sprintf library
   (*mulle_sprintf_free_storage)();
   
   mulle_test_allocator_objc_reset();
}


__attribute__(( noreturn))
static void   uncaught_exception( void *exception)
{
   extern void   mulle_objc_runtime_dump_to_tmp( void);
   
   fprintf( stderr, "uncaught exception: %s", [[(id) exception description] UTF8String]);
   mulle_objc_runtime_dump_to_tmp();
   abort();
}


void  MulleObjCFoundationGetDefaultSetupConfig( struct _ns_foundation_setupconfig *setup)
{
   setup->config                               = *ns_objc_get_default_setupconfig();
   setup->config.runtime.versionassert         = versionassert;
   setup->config.runtime.uncaughtexception     = uncaught_exception;
   setup->config.foundation.configurationsize  = sizeof( struct _ns_foundationconfiguration);
   setup->config.callbacks.setup               = (void (*)()) _ns_foundation_setup;
   setup->config.callbacks.tear_down_and_check = tear_down_and_check;
   setup->config.callbacks.tear_down          = tear_down;
   
   _MulleObjCExceptionInitTable( &setup->config.foundation.exceptiontable);
}

