#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


static int   test_i_init_with_bytes_no_copy_length_allocator_( void)
{
   NSData *obj;
   void * params_1[] =
   {
      NULL,
      "",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "1848",
      "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;


   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSData alloc] mulleInitWithBytesNoCopy:params_1[ i_1]
                                                  length:params_1[ i_1]  ? strlen( params_1[ i_1]) : 0
                                               allocator:&mulle_stdlib_nofree_allocator] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}


static int   test_i_init_with_bytes_no_copy_length_free_when_done_( void)
{
   NSData *obj;
   void * params_1[] =
   {
      NULL,
      "",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "1848",
      "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;
   BOOL params_3[] =
   {
      YES,
      NO
   };
   unsigned int   i_3;
   unsigned int   n_3 = 2;
   char           *s;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_3 = 0; i_3 < n_3; i_3++)
      {
         @try
         {
            s = params_1[ i_1];
            if( s && params_3[ i_3])
               s = mulle_allocator_strdup( &mulle_stdlib_allocator, s);
            obj = [[[NSData alloc] initWithBytesNoCopy:s
                                                length:s ? strlen( s) : 0
                                          freeWhenDone:params_3[ i_3]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


static int   test_i_init( void)
{
   NSData *obj;

   @try
   {
      obj = [[[NSData alloc] init] autorelease];
      printf( "%s\n", [obj cStringDescription]);
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
   }
   return( 0);
}


static int   test_i_init_with_bytes_no_copy_length_( void)
{
   NSData *obj;
   void * params_1[] =
   {
      NULL,
      "",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "1848",
      "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;
   char           *s;

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         s = params_1[ i_1];
         if( s)
            s = mulle_allocator_strdup( &mulle_stdlib_allocator, s);
         obj = [[[NSData alloc] initWithBytesNoCopy:s
                                             length:s ? strlen( s) : 0] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}


static int   test_i_init_with_data_( void)
{
   NSData *obj;
   NSData * params_1[] =
   {
      nil,
      [NSData data],
      [NSData dataWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" length:19] // emoji comet, snowman, thumbs-up brown
   };
   unsigned int   i_1;
   unsigned int   n_1 = 3;

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSData alloc] initWithData:params_1[ i_1]] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}


static int   test_i_init_with_bytes_no_copy_length_owner_( void)
{
   NSData *obj;
   void * params_1[] =
   {
      NULL,
      "",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "1848",
      "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;
   id params_3[] =
   {
      nil,
      @"whatever",
      @1,
      @{ @"a": @1 },
      @[ @"a" ]
   };
   unsigned int   i_3;
   unsigned int   n_3 = 5;
   char           *s;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_3 = 0; i_3 < n_3; i_3++)
      {
         @try
         {
            s = params_1[ i_1];
            if( s)
               s = mulle_allocator_strdup( &mulle_stdlib_allocator, s);
            obj = [[[NSData alloc] mulleInitWithBytesNoCopy:s
                                                     length:s ? strlen( s) : 0
                                              sharingObject:params_3[ i_3]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
            if( s)
               mulle_allocator_free( &mulle_stdlib_allocator, s);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


static int   test_i_init_with_bytes_length_( void)
{
   NSData *obj;
   void * params_1[] =
   {
      NULL,
      "",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "1848",
      "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSData alloc] initWithBytes:params_1[ i_1]
                                       length:params_1[ i_1] ? strlen( params_1[ i_1]) : 0] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}



static int   run_test( int (*f)( void), char *name)
{
   mulle_testallocator_discard();  //  w
   @autoreleasepool                //  i
   {                               //  l  l
      printf( "%s\n", name);       //  l  e  c
      if( (*f)())                  //     a  h
         return( 1);               //     k  e
   }                               //        c
   mulle_testallocator_reset();    //        k
   return( 0);
}


int   main( int argc, char *argv[])
{
   int   errors;

#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      _exit( 1);
#endif
   errors = 0;
   errors += run_test( test_i_init_with_bytes_no_copy_length_allocator_, "-initWithBytesNoCopy:length:allocator:");
   errors += run_test( test_i_init_with_bytes_no_copy_length_free_when_done_, "-initWithBytesNoCopy:length:freeWhenDone:");
   errors += run_test( test_i_init, "-init");
   errors += run_test( test_i_init_with_bytes_no_copy_length_, "-initWithBytesNoCopy:length:");
   errors += run_test( test_i_init_with_data_, "-initWithData:");
   errors += run_test( test_i_init_with_bytes_no_copy_length_owner_, "-initWithBytesNoCopy:length:owner:");
   errors += run_test( test_i_init_with_bytes_length_, "-initWithBytes:length:");

   mulle_testallocator_cancel();
   return( errors ? 1 : 0);
}
