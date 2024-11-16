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


static int   test_i_add_characters_in_range_( void)
{
   NSMutableCharacterSet *obj;
   NSRange params_1[] =
   {
      NSRangeMake( 0, 0),
      NSRangeMake( 0, 2),
      NSRangeMake( 1, 1),
      NSRangeMake( -1, 1),
      NSRangeMake( 0, -1),
      NSRangeMake( INT_MAX, INT_MAX)
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( NSRange);

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSMutableCharacterSet alloc] init] autorelease];
         [obj addCharactersInRange:params_1[ i_1]];
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

   rval = test_i_add_characters_in_range_();
   return( rval);
}

