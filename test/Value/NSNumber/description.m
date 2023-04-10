#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
# import <MulleObjCValueFoundation/_MulleObjCTaggedPointerIntegerNumber.h>
# import <MulleObjCValueFoundation/NSString+Substring-Private.h>
#endif

//#define VALGRIND_COMPLAINT

int  main( void)
{
   NSNumber   *value;

#ifndef VALGRIND_COMPLAINT
   printf( "bool\n");
   value = [NSNumber numberWithBool:YES];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nchar\n");
   value = [NSNumber numberWithChar:1];
   printf( "%s\n", [[value description] UTF8String]);
#endif

   printf( "\nshort\n");
   value = [NSNumber numberWithShort:1848];
   printf( "%s\n", [[value description] UTF8String]);

#ifndef VALGRIND_COMPLAINT
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
#endif

   return( 0);
}
