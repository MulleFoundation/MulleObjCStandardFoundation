#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


main()
{
   NSNumber   *value;

   value = [NSNumber numberWithChar:0];
   printf( "%d\n" , [value intValue]);

   value = [NSNumber numberWithInt:-1];
   printf( "%d\n" , [value intValue]);

   value = [NSNumber numberWithInt:+1];
   printf( "%d\n" , [value intValue]);

   return( 0);
}
