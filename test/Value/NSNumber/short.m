#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


int   main( void)
{
   NSNumber   *value;

   value = [NSNumber numberWithShort:0];
   printf( "%d\n" , [value intValue]);


   value = [NSNumber numberWithShort:-1848];
   printf( "%d\n" , [value intValue]);

   value = [NSNumber numberWithShort:+1848];
   printf( "%d\n" , [value intValue]);

   return( 0);
}
