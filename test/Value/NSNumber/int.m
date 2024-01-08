#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


int   main( void)
{
   NSNumber   *value;

   value = [NSNumber numberWithInt:0];
   printf( "%d\n" , [value intValue]);

   value = [NSNumber numberWithInt:-1848];
   printf( "%d\n" , [value intValue]);

   value = [NSNumber numberWithInt:INT_MAX];
   if( [value intValue] == INT_MAX)
      printf( "INT_MAX\n");
   else
      printf( "%d\n", [value intValue]);

   return( 0);
}
