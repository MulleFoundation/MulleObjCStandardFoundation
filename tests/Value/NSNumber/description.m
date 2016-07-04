#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>
#endif


main()
{
   NSNumber   *value;

   printf( "bool\n");
   value = [NSNumber numberWithBool:YES];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nchar\n");
   value = [NSNumber numberWithChar:1];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nshort\n");
   value = [NSNumber numberWithShort:1848];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nint\n");
   value = [NSNumber numberWithInt:1848];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nlong\n");
   value = [NSNumber numberWithLong:1848];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nlong long\n");
   value = [NSNumber numberWithLongLong:1848];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nNSInteger\n");
   value = [NSNumber numberWithInteger:1848];
   printf( "%s\n", [[value description] UTF8String]);


   printf( "\nfloat\n");
   value = [NSNumber numberWithFloat:18.48];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\ndouble\n");
   value = [NSNumber numberWithDouble:18.48];
   printf( "%s\n", [[value description] UTF8String]);
   
   printf( "\nlong double\n");
   value = [NSNumber numberWithLongDouble:18.48];
   printf( "%s\n", [[value description] UTF8String]);
}
