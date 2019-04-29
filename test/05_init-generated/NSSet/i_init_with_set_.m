#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


static int   test_i_init_with_set_( void)
{
   NSSet *obj;
   NSSet * params_1[] =
   {
      [NSSet set],
      [NSSet setWithArray:@[ @"1", @"2", @1848 ]],
      nil
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( NSSet *);

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSSet alloc] initWithSet:params_1[ i_1]] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}


int   main( int argc, char *argv[])
{
   int   rval;

   rval = test_i_init_with_set_();
   return( rval);
}

