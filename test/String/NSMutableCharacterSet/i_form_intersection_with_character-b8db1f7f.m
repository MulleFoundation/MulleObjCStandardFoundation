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


static int   test_i_form_intersection_with_character_set_( void)
{
   NSMutableCharacterSet *obj;
   NSCharacterSet * params_1[] =
   {
      nil,
      [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFG"],
      [NSCharacterSet characterSetWithCharactersInString:@"abcdefg"]
   };

   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( NSCharacterSet *);

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [NSMutableCharacterSet characterSetWithCharactersInString:@"ABC"];
         [obj formIntersectionWithCharacterSet:params_1[ i_1]];
         printf( "---\n%s\n---\n", [[obj mulleTestDescription] UTF8String]);
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

   rval = test_i_form_intersection_with_character_set_();
   return( rval);
}

