#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


static int   test_i_init_with_objects_( void)
{
   NSArray    *obj;
   NSArray    *obj2;

   obj  = [[[NSArray alloc] initWithObjects:nil] autorelease];
   printf( "%s\n", [obj cStringDescription]);

   obj2 = [[[NSArray alloc] initWithObjects:@1, @2, @3, nil] autorelease];
   printf( "%s\n", [obj2 cStringDescription]);
   return( 0);
}


static int   test_i_init_with_array_and_array_( void)
{
   NSArray *obj;
   NSArray * params_1[] =
   {
      nil,
      [NSArray array],
      [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
   };
   unsigned int   i_1;
   unsigned int   n_1 = 3;
   NSArray * params_2[] =
   {
      nil,
      [NSArray array],
      [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
   };
   unsigned int   i_2;
   unsigned int   n_2 = 3;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSArray alloc] mulleInitWithArray:params_1[ i_1]
                                              andArray:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


//
// c-function is va_list
//
static void   _test_i_init_with_object_vararg_list_( id first, ...)
{
   va_list   args;
   NSArray  *obj;

   va_start( args, first);
   obj = [[[NSArray alloc] initWithObject:first
                               arguments:args] autorelease];
   printf( "%s\n", [obj cStringDescription]);
   va_end( args);
}


static int   test_i_init_with_object_vararg_list_( void)
{
   _test_i_init_with_object_vararg_list_( @"nix", nil);
   _test_i_init_with_object_vararg_list_( @"%@", @1, nil);
   _test_i_init_with_object_vararg_list_( @"%@ %@ %@ %@ %@", @1, @2, @3, @4, @5, nil);
   return( 0);
}

static int   test_i_init( void)
{
   NSArray *obj;

   @try
   {
      obj = [[[NSArray alloc] init] autorelease];
      printf( "%s\n", [obj cStringDescription]);
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
   }
   return( 0);
}


static int   test_i_init_with_objects_count_( void)
{
   NSArray *obj;
   id * params_1[] =
   {
      0
   };
   unsigned int   i_1;
   unsigned int   n_1 = 1;
   unsigned long long params_2[] =
   {
      0,
      1,
      1848,
      LONG_MAX
   };
   unsigned int   i_2;
   unsigned int   n_2 = 4;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSArray alloc] initWithObjects:params_1[ i_1]
                                              count:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


static int   test_i_init_with_array_and_object_( void)
{
   NSArray *obj;
   NSArray * params_1[] =
   {
      nil,
      [NSArray array],
      [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
   };
   unsigned int   i_1;
   unsigned int   n_1 = 3;
   id params_2[] =
   {
      nil,
      @"whatever",
      @1,
      @{ @"a": @1 },
      @[ @"a" ]
   };
   unsigned int   i_2;
   unsigned int   n_2 = 5;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSArray alloc] mulleInitWithArray:params_1[ i_1]
                                             andObject:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


static int   test_i_init_with_array_( void)
{
   NSArray *obj;
   NSArray * params_1[] =
   {
      nil,
      [NSArray array],
      [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
   };
   unsigned int   i_1;
   unsigned int   n_1 = 3;

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSArray alloc] initWithArray:params_1[ i_1]] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}


static int   test_i_init_with_array_copy_items_( void)
{
   NSArray *obj;
   NSArray * params_1[] =
   {
      nil,
      [NSArray array],
      [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
   };
   unsigned int   i_1;
   unsigned int   n_1 = 3;
   int params_2[] =
   {
      0,
      1,
      -1,
      1848,
      -1848,
      INT_MAX,
      INT_MIN
   };
   unsigned int   i_2;
   unsigned int   n_2 = 7;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSArray alloc] initWithArray:params_1[ i_1]
                                        copyItems:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


static int   test_i_init_with_array_range_( void)
{
   NSArray *obj;
   NSArray * params_1[] =
   {
      nil,
      [NSArray array],
      [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
   };
   unsigned int   i_1;
   unsigned int   n_1 = 3;
   NSRange params_2[] =
   {
      NSMakeRange( 0, 0),
      NSMakeRange( -1, 1),
      NSMakeRange( 0, -1),
      NSMakeRange( INT_MAX, INT_MAX)
   };
   unsigned int   i_2;
   unsigned int   n_2 = 4;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSArray alloc] mulleInitWithArray:params_1[ i_1]
                                                 range:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


//
// ObjC-function is mulle_vararg_list
//
@interface Foo : NSObject

+ (void) callWithObject:(id) obj, ...;

@end


@implementation Foo

+ (void) callWithObject:(id) first, ...
{
   mulle_vararg_list   args;
   NSArray  *obj;

   mulle_vararg_start( args, first);
   obj = [[[NSArray alloc] initWithObject:first
                               mulleVarargList:args] autorelease];
   printf( "%s\n", [obj cStringDescription]);
   mulle_vararg_end( args);
}

@end


static int   test_i_init_with_object_mulle_vararg_list_( void)
{
   [Foo callWithObject:@"nix", nil];
   [Foo callWithObject:@"%@", @1, nil];
   [Foo callWithObject:@"%@ %@ %@ %@ %@", @1, @2, @3, @4, @5, nil];
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
   errors += run_test( test_i_init_with_objects_, "-initWithObjects:");
   errors += run_test( test_i_init_with_array_and_array_, "-initWithArray:andArray:");
   errors += run_test( test_i_init_with_object_vararg_list_, "-initWithObject:arguments:");
   errors += run_test( test_i_init, "-init");
   errors += run_test( test_i_init_with_objects_count_, "-initWithObjects:count:");
   errors += run_test( test_i_init_with_array_and_object_, "-initWithArray:andObject:");
   errors += run_test( test_i_init_with_array_, "-initWithArray:");
   errors += run_test( test_i_init_with_array_copy_items_, "-initWithArray:copyItems:");
   errors += run_test( test_i_init_with_array_range_, "-initWithArray:range:");
   errors += run_test( test_i_init_with_object_mulle_vararg_list_, "-initWithObject:mulleVarargList:");

   mulle_testallocator_cancel();
   return( errors ? 1 : 0);
}
