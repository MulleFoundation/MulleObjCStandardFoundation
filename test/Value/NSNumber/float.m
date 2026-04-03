#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


int   main( void)
{
   NSNumber   *value;

   value = [NSNumber numberWithFloat:0.0];
   mulle_printf( "%.1f\n" , [value floatValue]);

   value = [NSNumber numberWithFloat:18.48];
   mulle_printf( "%.2f\n" , [value floatValue]);

   return( 0);
}
