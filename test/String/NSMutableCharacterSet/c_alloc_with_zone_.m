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
   id     value;

   @try
   {
      value = [[NSMutableCharacterSet allocWithZone:NULL] autorelease];
      mulle_printf( "%@\n", [value mulleTestDescription]);
   }
   @catch( NSException *localException)
   {
      mulle_printf( "Threw a %@ exception\n", [localException name]);
   }
   return( 0);
}


int   main( int argc, char *argv[])
{
   int   rval;

   rval = test_c_alloc_with_zone_();
   return( rval);
}

