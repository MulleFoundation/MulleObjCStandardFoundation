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

#import "import-private.h"


// other files in this library
#import "mulle-foundation-universeconfiguration-private.h"

#import "MulleObjCStandardFoundation.h"

// other libraries of MulleObjCStandardFoundation

// std-c and other dependencies

#import <mulle-sprintf/mulle-sprintf.h>


//
// setup is what will be used by "startup" to initialize the runtime
//

#pragma mark - versioning

//
// this version assert is probably not used, but supplanted with
// by the enveloping Foundation
//
static void   versionassert( struct _mulle_objc_universe *universe,
                             void *friend,
                             struct mulle_objc_loadversion *version)
{
   if( (version->foundation & ~0xFF) != (MULLE_OBJC_STANDARD_FOUNDATION_VERSION & ~0xFF))
      mulle_objc_universe_fail_inconsistency( universe,
        "mulle_objc_universe %p: foundation version set to %x but "
        "universe foundation is %x",
            universe,
            version->foundation,
            MULLE_OBJC_STANDARD_FOUNDATION_VERSION);
}


#pragma mark - exception (mishandling)

extern void  _MulleObjCExceptionInitTable ( struct _mulle_objc_exceptionhandlertable *table);


#pragma mark - setup and teardown ObjC

static void   *objectfromchars( char *s)
{
   return( [NSString stringWithUTF8String:s]);
}


static char   *charsfromobject( void *obj)
{
   return( [(id) obj UTF8String]);
}


void   mulle_foundation_postcreate_objc( struct _mulle_objc_universe *universe)
{
   struct _mulle_objc_universefoundationinfo   *rootconfig;
   struct mulle_allocator                      *allocator;

   mulle_objc_postcreate_universe( universe);

   rootconfig = _mulle_objc_universe_get_foundationdata( universe);
   // will be overwritten by foundation to convert to NSString
   rootconfig->string.charsfromobject = charsfromobject;
   rootconfig->string.objectfromchars = objectfromchars;

   allocator = _mulle_objc_universe_get_foundationallocator( universe);
   mulle_allocator_set_fail( allocator,
                             MulleObjCThrowMallocException);
}


void   mulle_foundation_teardown_objc( struct _mulle_objc_universe *universe)
{
   struct mulle_allocator   *allocator;

   (*mulle_sprintf_free_storage)();

   allocator = _mulle_objc_universe_get_foundationallocator( universe);
   mulle_allocator_set_fail( allocator, 0);

   mulle_objc_teardown_universe( universe);
}


MULLE_C_NO_RETURN
static void   uncaught_exception( void *exception)
{
   struct _mulle_objc_universe   *universe;

   universe = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
   mulle_objc_universe_fprintf( universe,
                                stderr,
                                "uncaught exception: %s\n",
                                [[(id) exception description] UTF8String]);
   abort();
}


void  mulle_foundation_universeconfiguration_set_defaults( struct _mulle_objc_universeconfiguration *config)
{
   *config                            = *mulle_objc_global_get_default_universeconfiguration();
   config->universe.versionassert     = versionassert;
   config->universe.uncaughtexception = uncaught_exception;
   config->callbacks.postcreate       = mulle_foundation_postcreate_objc;
   config->callbacks.teardown         = mulle_foundation_teardown_objc;

   _MulleObjCExceptionInitTable( &config->foundation.exceptiontable);
}
