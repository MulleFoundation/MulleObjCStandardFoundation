#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>

#include <stdio.h>
#include <stdlib.h>


static int   test( unsigned int size)
{
   NSString       *obj;
   NSUInteger     len;
   mulle_utf8_t   buf[ 256];
   char           *params_1[] =
   {
      "",
      "1848",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod "
      "tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim "
      "veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex "
      "ea commodi consequat. Quis aute iure reprehenderit in voluptate velit "
      "esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "L\xc3\xb6\xc3\xb6\xc3\xb6\xc3\xb6orem ipsum dolor sit amet, consectetur "
      "adipisici elit, sed eiusmod "
      "tempor incidunt ut lab\xc3\xb6re et d\xc3\xb6l\xc3\xb6re magna aliqua. "
      "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi "
      "ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in "
      "voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars 16 bit*/,
      "L\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbeorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod "
      "tempor incidunt ut lab\xc3\xb6re et d\xc3\xb6l\xc3\xb6re magna aliqua. "
      "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi "
      "ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in "
      "voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars 32 bit*/
   };
   NSUInteger  i_1;
   NSUInteger  n_1 = sizeof( params_1) / sizeof( params_1[ 0]);

   assert( size < sizeof( buf));

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSString alloc] initWithUTF8String:params_1[ i_1]] autorelease];
         len = [obj mulleGetUTF8Characters:buf
                                 maxLength:size];
         mulle_printf( "<%@> \"%.*@\": %td %td\n", [obj class], len, obj, [obj length], len);
      }
      @catch( NSException *localException)
      {
         printf( "*** Threw a %s exception\n", [[localException name] UTF8String]);
         return( 1);
      }
   }

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSString alloc] mulleInitWithUTF8CharactersNoCopy:params_1[ i_1]
                                                             length:-1
                                                          allocator:NULL] autorelease];
         len = [obj mulleGetUTF8Characters:buf
                                 maxLength:sizeof( buf)];
         mulle_printf( "<%@> \"%.*@\": %td %td\n", [obj class], len, obj, [obj length], len);
      }
      @catch( NSException *localException)
      {
         printf( "*** Threw a %s exception\n", [[localException name] UTF8String]);
         return( 1);
      }
   }
   return( 0);
}


int   main( void)
{
   unsigned int  i;

   for( i = 2; i <= 128; i *= 2)
   {
      if( test( i))
         return( 1);
      if( test( i + 1))
         return( 1);
   }
   return( 0);
}

