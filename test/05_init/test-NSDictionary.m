#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


static int   test_i_init_with_objects_for_keys_( void)
{
   NSDictionary *obj;
   NSArray * params_1[] =
   {
      [NSArray array],
      [NSArray arrayWithObjects:@"1", @"2", @1848, nil],
      nil
   };
   unsigned int   i_1;
   unsigned int   n_1 = 3;
   NSArray * params_2[] =
   {
      [NSArray array],
      [NSArray arrayWithObjects:@"1", @"2", @1848, nil],
      nil
   };
   unsigned int   i_2;
   unsigned int   n_2 = 3;
   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSDictionary alloc] initWithObjects:params_1[ i_1]
                                                 forKeys:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


static int   test_i_init_with_objects_and_keys_( void)
{
   NSDictionary *obj;
   @try
   {
      obj = [[[NSDictionary alloc] initWithObjectsAndKeys:@{ @"a": @1 },
                                                          @"whatever",
                                                          @[ @"a" ],
                                                          @1,
                                                          nil] autorelease];
      printf( "%s\n", [obj cStringDescription]);
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
   }
   return( 0);
}


static int   test_i_init_with_dictionary_( void)
{
   NSDictionary *obj;
   id params_1[] =
   {
      @{ @"a": @1 },
      nil,
   };
   unsigned int   i_1;
   unsigned int   n_1 = 2;

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSDictionary alloc] initWithDictionary:params_1[ i_1]] autorelease];
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
   NSDictionary *obj;

   @try
   {
      obj = [[[NSDictionary alloc] init] autorelease];
      printf( "%s\n", [obj cStringDescription]);
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
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
   NSDictionary  *obj;

   @try
   {
      mulle_vararg_start( args, first);
      obj = [[[NSDictionary alloc] initWithObject:first
                                 mulleVarargList:args] autorelease];
      printf( "%s\n", [obj cStringDescription]);
      mulle_vararg_end( args);
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
   }
}

@end


static int   test_i_init_with_object_mulle_vararg_list_( void)
{
   [Foo callWithObject:@"nix", nil];
   [Foo callWithObject:@"%@", @1, nil];
   [Foo callWithObject:@"%@ %@ %@ %@ %@", @1, @2, @3, @4, @5, nil];
   return( 0);
}


static int   test_i_init_with_dictionary_copy_items_( void)
{
   NSDictionary *obj;
   id params_1[] =
   {
      @{ @"a": @1 },
      nil,
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( id);
   BOOL params_2[] =
   {
      YES,
      NO
   };
   unsigned int   i_2;
   unsigned int   n_2 = 2;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSDictionary alloc] initWithDictionary:params_1[ i_1]
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


static int   test_i_init_with_objects_for_keys_count_( void)
{
   NSDictionary *obj;
   id  _EmptyIds[] = { 0 };
   id  _1848Ids[]  = { @"VfL", @"1848", 0 };
   id  _VfLIds[]   = { @"VfL", @" ", @"Bochum", @1848, 0 };
   id * params_1[] =
   {
      _EmptyIds,
      _1848Ids,
      _VfLIds,
      NULL
   };
   unsigned int   i_1;
   unsigned int   n_1 = 4;
   NSUInteger params_3[] =
   {
      0,
      1,
      2,
      0,
   };


   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSDictionary alloc] initWithObjects:params_1[ i_1]
                                              forKeys:params_1[ i_1]
                                                count:params_3[ i_1]] autorelease];
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
   errors += run_test( test_i_init_with_objects_for_keys_, "-initWithObjects:forKeys:");
   errors += run_test( test_i_init_with_objects_and_keys_, "-initWithObjectsAndKeys:");
   errors += run_test( test_i_init_with_dictionary_, "-initWithDictionary:");
   errors += run_test( test_i_init, "-init");
   errors += run_test( test_i_init_with_object_mulle_vararg_list_, "-initWithObject:mulleVarargList:");
   errors += run_test( test_i_init_with_dictionary_copy_items_, "-initWithDictionary:copyItems:");
   errors += run_test( test_i_init_with_objects_for_keys_count_, "-initWithObjects:forKeys:count:");

   mulle_testallocator_cancel();
   return( errors ? 1 : 0);
}
