//
//  MulleObjCFoundation.m
//  MulleObjCFoundation
//
//  Created by Nat! on 15.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundation.h"

// other files in this library
#import "MulleObjCFoundationSetup.h"

// other libraries of MulleObjCFoundation

// std-c and other dependencies
#import <MulleObjC/ns_objc_setup.h>
#import <MulleObjC/ns_test_allocation.h>
#import <mulle_sprintf/mulle_sprintf.h>


__attribute__((const))  // always returns same value (in same thread)
struct _mulle_objc_runtime  *__get_or_create_objc_runtime( void)
{
   struct _mulle_objc_runtime  *runtime;
   
   runtime = __mulle_objc_get_runtime();
   if( runtime->version)
      return( runtime);
   
   {
      struct _ns_foundation_setupconfig   setup;
      
      MulleObjCFoundationGetDefaultSetupConfig( &setup);
      return( ns_objc_create_runtime( &setup.config));
   }
}


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
