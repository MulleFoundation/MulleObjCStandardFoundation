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


static int   test_c_character_set_with_characters_in_string_( void)
{
   NSCharacterSet *value;
   NSString * params_1[] =
   {
      [[@"@1848" mutableCopy] autorelease],
      [[@"" mutableCopy] autorelease],
      [[@"VfL Bochum" mutableCopy] autorelease],
      [[@"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." mutableCopy] autorelease] /* > 256 chars */,
      [[[NSString alloc] initWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */ length:20 encoding:NSUTF8StringEncoding] autorelease],
      nil
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( NSString *);

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         value = [NSMutableCharacterSet characterSetWithCharactersInString:params_1[ i_1]];
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

   rval = test_c_character_set_with_characters_in_string_();
   return( rval);
}

