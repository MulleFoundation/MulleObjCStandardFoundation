#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>
#endif

#include <limits.h>
#include <float.h>


static void print_bool( char *title, BOOL flag)
{
   printf( "%s: %s\n", title, flag ? "YES" : "NO");
}


void   check_long_long( NSNumber *value, long long expect)
{
   print_bool( "boolValue", [value boolValue] == (expect ? YES : NO));

   print_bool( "boolValue", [value charValue] == (char) expect);
   print_bool( "shortValue", [value shortValue] == (short) expect);
   print_bool( "intValue", [value intValue] == (int) expect);
   print_bool( "longValue", [value longValue] == (long) expect);
   print_bool( "longLongValue", [value longLongValue] == (long long) expect);

   print_bool( "unsignedCharValue", [value unsignedCharValue] == (unsigned char) expect);
   print_bool( "unsignedShortValue", [value unsignedShortValue] == (unsigned short) expect);
   print_bool( "unsignedIntValue", [value unsignedIntValue] == (unsigned int) expect);
   print_bool( "unsignedLongValue", [value unsignedLongValue] == (unsigned long) expect);
   print_bool( "unsignedLongLongValue", [value unsignedLongLongValue] == (unsigned long long) expect);
}


void   check_double( NSNumber *value, double expect)
{
   print_bool( "integerValue", [value integerValue] == (NSInteger) expect);
   print_bool( "longLongValue", [value longLongValue] == (long long) expect);
   print_bool( "floatValue", [value floatValue] == (float) expect);
   print_bool( "doubleValue", [value doubleValue] == (double) expect);
}


main()
{
   NSNumber   *value;

   printf( "bool\n");
   value = [NSNumber numberWithBool:YES];
   check_long_long( value, YES);

   value = [NSNumber numberWithBool:NO];
   check_long_long( value, NO);

   printf( "\nchar\n");
   value = [NSNumber numberWithChar:CHAR_MAX];
   check_long_long( value, CHAR_MAX);
   value = [NSNumber numberWithChar:CHAR_MIN];
   check_long_long( value, CHAR_MIN);

   printf( "\nshort\n");
   value = [NSNumber numberWithShort:SHRT_MAX];
   check_long_long( value, SHRT_MAX);
   value = [NSNumber numberWithShort:SHRT_MIN];
   check_long_long( value, SHRT_MIN);

   printf( "\nint\n");
   value = [NSNumber numberWithInt:INT_MAX];
   check_long_long( value, INT_MAX);
   value = [NSNumber numberWithInt:INT_MIN];
   check_long_long( value, INT_MIN);

   printf( "\nlong\n");
   value = [NSNumber numberWithLong:LONG_MAX];
   check_long_long( value, LONG_MAX);
   value = [NSNumber numberWithLong:LONG_MIN];
   check_long_long( value, LONG_MIN);

   printf( "\nlong long\n");
   value = [NSNumber numberWithLongLong:LONG_LONG_MAX];
   check_long_long( value, LONG_LONG_MAX);
   value = [NSNumber numberWithLongLong:LONG_LONG_MIN];
   check_long_long( value, LONG_LONG_MIN);

   printf( "\nNSInteger\n");
   value = [NSNumber numberWithInteger:NSIntegerMax];
   check_long_long( value, NSIntegerMax);
   value = [NSNumber numberWithInteger:NSIntegerMin];
   check_long_long( value, NSIntegerMin);

/* unsigned, sometimes UCHAR_MAX is not defined, so fuck it */

   printf( "\nunsigned char\n");
   value = [NSNumber numberWithUnsignedChar:CHAR_MAX];
   check_long_long( value, (unsigned char) CHAR_MAX);
   value = [NSNumber numberWithUnsignedChar:CHAR_MIN];
   check_long_long( value, (unsigned char) CHAR_MIN);

   printf( "\nunsigned short\n");
   value = [NSNumber numberWithUnsignedShort:SHRT_MAX];
   check_long_long( value, (unsigned short) SHRT_MAX);
   value = [NSNumber numberWithUnsignedShort:SHRT_MIN];
   check_long_long( value, (unsigned short) SHRT_MIN);

   printf( "\nunsigned int\n");
   value = [NSNumber numberWithUnsignedInt:INT_MAX];
   check_long_long( value, (unsigned int) INT_MAX);
   value = [NSNumber numberWithUnsignedInt:INT_MIN];
   check_long_long( value, (unsigned int) INT_MIN);

   printf( "\nunsigned long\n");
   value = [NSNumber numberWithUnsignedLong:LONG_MAX];
   check_long_long( value, (unsigned long) LONG_MAX);
   value = [NSNumber numberWithUnsignedLong:LONG_MIN];
   check_long_long( value, (unsigned long) LONG_MIN);

   printf( "\nunsigned long long\n");
   value = [NSNumber numberWithUnsignedLongLong:LONG_LONG_MAX];
   check_long_long( value, (unsigned long long) LONG_LONG_MAX);
   value = [NSNumber numberWithUnsignedLongLong:LONG_LONG_MIN];
   check_long_long( value, (unsigned long long) LONG_LONG_MIN);

   printf( "\nNSUInteger\n");
   value = [NSNumber numberWithUnsignedInteger:NSUIntegerMax];
   check_long_long( value, NSUIntegerMax);
   value = [NSNumber numberWithUnsignedInteger:NSUIntegerMin];
   check_long_long( value, NSUIntegerMin);


   printf( "\nfloat\n");
   value = [NSNumber numberWithFloat:FLT_MAX];
   check_double( value, FLT_MAX);
   value = [NSNumber numberWithFloat:FLT_MIN];
   check_double( value, FLT_MIN);

   printf( "\ndouble\n");
   value = [NSNumber numberWithDouble:DBL_MAX];
   check_double( value, DBL_MAX);
   value = [NSNumber numberWithDouble:DBL_MIN];
   check_double( value, DBL_MIN);

}
