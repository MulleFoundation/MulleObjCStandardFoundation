#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


int   main( void)
{
   NSNumber   *value;

   value = [NSNumber numberWithInt:0];
   mulle_printf( "%d\n" , [value intValue]);

   value = [NSNumber numberWithInt:-1848];
   mulle_printf( "%d\n" , [value intValue]);

   value = [NSNumber numberWithInt:INT_MAX];
   if( [value intValue] == INT_MAX)
      mulle_printf( "INT_MAX\n");
   else
      mulle_printf( "%d\n", [value intValue]);

   return( 0);
}
