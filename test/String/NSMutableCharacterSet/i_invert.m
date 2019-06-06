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


static int   test_i_invert( void)
{
   NSMutableCharacterSet   *obj;
   NSCharacterSet          *other;
   NSData                  *objData;
   NSData                  *otherData;

   @try
   {
      obj = [NSMutableCharacterSet characterSetWithCharactersInString:@"abcdefg"];
      [obj invert];
      objData   = [obj bitmapRepresentation];

      other     = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefg"] invertedSet];
      otherData = [other bitmapRepresentation];
      printf( "%s\n", [objData isEqualToData:otherData] ? "pass" : "fail");
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] UTF8String]);
   }
   return( 0);
}


int   main( int argc, char *argv[])
{
   int   rval;

   rval = test_i_invert();
   return( rval);
}

