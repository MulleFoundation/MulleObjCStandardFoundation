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


static int   test_i_character_is_member_( void)
{
   NSMutableCharacterSet *obj;
   int value;
   int params_1[] =
   {
      0,
      1,
      -1,
      'a',
      'A',
      '1',
      18481848,
      -18481848
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( int);

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj   = [NSMutableCharacterSet letterCharacterSet];
         value = [obj characterIsMember:params_1[ i_1]];
         printf( "%d\n", value);
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

   rval = test_i_character_is_member_();
   return( rval);
}

