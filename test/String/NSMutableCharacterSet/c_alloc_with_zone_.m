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


static int   test_c_alloc_with_zone_( void)
{
   id value;
   struct { void * f0; } * params_1[] =
   {
      0
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( struct { void * f0; } *);

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         value = [[NSMutableCharacterSet allocWithZone:params_1[ i_1]] autorelease];
         printf( "%s\n", [[value mulleTestDescription] UTF8String]);
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

   rval = test_c_alloc_with_zone_();
   return( rval);
}

