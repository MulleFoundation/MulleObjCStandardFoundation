//
//  MulleObjCFoundationSetup.m
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
#import "MulleObjCStandardFoundationSetup.h"

// other files in this library
#import "MulleObjCStandardFoundation.h"

// other libraries of MulleObjCStandardFoundation

// std-c and other dependencies
#import <MulleObjC/ns_objc_setup.h>
#import <MulleObjC/ns_test_allocation.h>
#import <mulle-sprintf/mulle-sprintf.h>


#pragma mark -
#pragma mark versioning

//
// this version assert is probably not used, but supplanted with
// by the enveloping Foundation
//
static void   versionassert( struct _mulle_objc_universe *universe,
                             void *friend,
                             struct mulle_objc_loadversion *version)
{
   if( (version->foundation & ~0xFF) != (MULLE_OBJC_STANDARD_FOUNDATION_VERSION & ~0xFF))
      _mulle_objc_universe_raise_inconsistency_exception( universe, "mulle_objc_universe %p: foundation version set to %x but universe foundation is %x",
                                                        universe,
                                                        version->foundation,
                                                        MULLE_OBJC_STANDARD_FOUNDATION_VERSION);
}


#pragma mark -
#pragma mark exception (mishandling)

extern void  _MulleObjCExceptionInitTable ( struct _ns_exceptionhandlertable *table);


#pragma mark -
#pragma mark setup and teardown ObjC

static void   tear_down()
{
   ns_objc_universe_tear_down();

   if( mulle_objc_getenv_yes_no( "MULLE_OBJC_TEST_ALLOCATOR"))
   {
      (*mulle_sprintf_free_storage)();
      mulle_test_allocator_objc_reset();
   }
}


__attribute__(( noreturn))
static void   uncaught_exception( void *exception)
{
   extern void   mulle_objc_dotdump_to_tmp( void);

   fprintf( stderr, "uncaught exception: %s", [[(id) exception description] UTF8String]);
   mulle_objc_dotdump_to_tmp();
   abort();
}


void  MulleObjCFoundationGetDefaultSetupConfig( struct _ns_foundation_setupconfig *setup,
                                                struct _mulle_objc_universe *universe)
{
   if( universe->debug.trace.universe)
      fprintf( stderr, "MulleObjCStandardFoundation: install exceptions and callbacks\n");

   setup->config                              = *ns_objc_get_default_setupconfig();
   setup->config.universe.versionassert       = versionassert;
   setup->config.universe.uncaughtexception   = uncaught_exception;
   setup->config.foundation.configurationsize = sizeof( struct _ns_foundationconfiguration);
   setup->config.callbacks.setup              = (void (*)()) _ns_foundation_setup;
   setup->config.callbacks.tear_down          = tear_down;
   _MulleObjCExceptionInitTable( &setup->config.foundation.exceptiontable);
}
