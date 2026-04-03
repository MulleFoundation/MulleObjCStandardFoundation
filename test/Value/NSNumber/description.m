#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
# import <MulleObjCValueFoundation/_MulleObjCValueTaggedPointer.h>
# import <MulleObjCValueFoundation/_MulleObjCTaggedPointerIntegerNumber.h>
# import <MulleObjCValueFoundation/NSString+Substring-Private.h>
#endif

//#define VALGRIND_COMPLAINT

int  main( void)
{
   NSNumber   *value;

#ifndef VALGRIND_COMPLAINT
   mulle_printf( "bool\n");
   value = [NSNumber numberWithBool:YES];
   mulle_printf( "%s\n", [[value description] UTF8String]);

   mulle_printf( "\nchar\n");
   value = [NSNumber numberWithChar:1];
   mulle_printf( "%s\n", [[value description] UTF8String]);
#endif

   mulle_printf( "\nshort\n");
   value = [NSNumber numberWithShort:1848];
   mulle_printf( "%s\n", [[value description] UTF8String]);

#ifndef VALGRIND_COMPLAINT
   mulle_printf( "\nint\n");
   value = [NSNumber numberWithInt:1848];
   mulle_printf( "%s\n", [[value description] UTF8String]);

   mulle_printf( "\nlong\n");
   value = [NSNumber numberWithLong:1848];
   mulle_printf( "%s\n", [[value description] UTF8String]);

   mulle_printf( "\nlong long\n");
   value = [NSNumber numberWithLongLong:1848];
   mulle_printf( "%s\n", [[value description] UTF8String]);

   mulle_printf( "\nNSInteger\n");
   value = [NSNumber numberWithInteger:1848];
   mulle_printf( "%s\n", [[value description] UTF8String]);


   mulle_printf( "\nfloat\n");
   value = [NSNumber numberWithFloat:18.48];
   mulle_printf( "%s\n", [[value description] UTF8String]);

   mulle_printf( "\ndouble\n");
   value = [NSNumber numberWithDouble:18.48];
   mulle_printf( "%s\n", [[value description] UTF8String]);

#ifdef _C_LNG_DBL
   mulle_printf( "\nlong double\n");
   value = [NSNumber numberWithLongDouble:18.48];
   mulle_printf( "%s\n", [[value description] UTF8String]);
#endif
#endif

   return( 0);
}
