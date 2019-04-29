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

   @try
   {
      obj  = [[[NSSet alloc] initWithObjects:nil] autorelease];
      printf( "%s\n", [obj cStringDescription]);
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
   }

   @try
   {
      obj2 = [[[NSSet alloc] initWithObjects:@1, @2, @3, nil] autorelease];
      printf( "%s\n", [obj2 cStringDescription]);
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
   }
   return( 0);
}


int   main( int argc, char *argv[])
{
   int   rval;

   rval = test_i_init_with_objects_();
   return( rval);
}

