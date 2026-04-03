#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


int   main( void)
{
   NSNumber   *value;

   value = [NSNumber numberWithLong:0];
   mulle_printf( "%ld\n" , [value longValue]);

   value = [NSNumber numberWithLong:-1848];
   mulle_printf( "%ld\n" , [value longValue]);

   value = [NSNumber numberWithLong:LONG_MAX];
   if( [value longValue] == LONG_MAX)
      mulle_printf( "LONG_MAX\n");
   else
      mulle_printf( "%ld\n", [value longValue]);

   return( 0);
}
