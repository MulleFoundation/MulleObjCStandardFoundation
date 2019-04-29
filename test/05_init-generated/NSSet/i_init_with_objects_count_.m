#ifdef __MULLE_OBJC__
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
# include <mulle-testallocator/mulle-testallocator.h>
#else
# import <Foundation/Foundation.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


static int   test_i_init_with_objects_count_( void)
{
   NSSet *obj;
   id  _EmptyIds[] = { 0 };
   id  _1848Ids[]  = { @"1848", 0 };
   id  _VfLIds[]   = { @"VfL", @" ", @"Bochum", @1848, 0 };
   id * params_1[] =
   {
      _EmptyIds,
      _1848Ids,
      _VfLIds,
      NULL,
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( id *);
   NSUInteger params_2[] =
   {
      0,
      1,
      4,
      0
   };

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSSet alloc] initWithObjects:params_1[ i_1]
                                         count:params_2[ i_1]] autorelease];
         printf( "%s\n", [[obj description] UTF8String]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] UTF8String]);
      }
   }
   return( 0);
}


int   main( int argc, char *argv[])
{
   int   rval;

   rval = test_i_init_with_objects_count_();
   return( rval);
}

