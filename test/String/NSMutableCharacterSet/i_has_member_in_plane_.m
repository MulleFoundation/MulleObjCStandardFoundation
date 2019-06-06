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


static int   test_i_has_member_in_plane_( void)
{
   NSMutableCharacterSet *obj;
   BOOL value;
   unsigned long long params_1[] =
   {
      0,
      1,
      1848
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( unsigned long long);

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj   = [[[NSMutableCharacterSet alloc] init] autorelease];
         value = [obj hasMemberInPlane:params_1[ i_1]];
         printf( "%s\n", value ? "YES" : "NO");
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

   rval = test_i_has_member_in_plane_();
   return( rval);
}

