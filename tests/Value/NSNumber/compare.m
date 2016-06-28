#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>
#endif

#include <limits.h>
#include <float.h>

#ifndef LONG_LONG_MAX
# define LONG_LONG_MAX   ((long long) (~0ULL >> 1))
# define LONG_LONG_MIN   ((long long) (~0ULL ^ (~0ULL >> 1)))
#endif


static void   printf_comparison( NSComparisonResult result)
{
   switch( result)
   {
   case  NSOrderedAscending  : printf( "NSOrderedAscending\n"); break;
   case  NSOrderedDescending : printf( "NSOrderedDescending\n"); break;
   case  NSOrderedSame       : printf( "NSOrderedSame\n"); break;
   default                   : printf( "???\n"); break;
   }
}


void   compare( NSNumber *a, NSNumber *b)
{
   printf_comparison( [a compare:a]);
   printf_comparison( [a compare:b]);
   printf_comparison( [b compare:a]);
   printf_comparison( [b compare:b]);
}


int   main( void)
{
   NSNumber   *a;
   NSNumber   *b;

   printf( "bool\n");
   a = [NSNumber numberWithBool:YES];
   b = [NSNumber numberWithBool:NO];
   compare( a, b);

   printf( "\nchar\n");
   a = [NSNumber numberWithChar:CHAR_MAX];
   b = [NSNumber numberWithChar:CHAR_MIN];
   compare( a, b);

   printf( "\nshort\n");
   a = [NSNumber numberWithShort:SHRT_MAX];
   b = [NSNumber numberWithShort:SHRT_MIN];
   compare( a, b);

   printf( "\nint\n");
   a = [NSNumber numberWithInt:INT_MAX];
   b = [NSNumber numberWithInt:INT_MIN];
   compare( a, b);

   printf( "\nlong\n");
   a = [NSNumber numberWithLong:LONG_MAX];
   b = [NSNumber numberWithLong:LONG_MIN];
   compare( a, b);

   printf( "\nlong long\n");
   a = [NSNumber numberWithLongLong:LONG_LONG_MAX];
   b = [NSNumber numberWithLongLong:LONG_LONG_MIN];
   compare( a, b);

   printf( "\nNSInteger\n");
   a = [NSNumber numberWithInteger:NSIntegerMax];
   b = [NSNumber numberWithInteger:NSIntegerMin];
   compare( a, b);

/* unsigned, sometimes UCHAR_MAX is not defined, so fuck it */

   printf( "\nunsigned char\n");
   a = [NSNumber numberWithUnsignedChar:CHAR_MAX];
   b = [NSNumber numberWithUnsignedChar:CHAR_MIN];
   compare( a, b);

   printf( "\nunsigned short\n");
   a = [NSNumber numberWithUnsignedShort:SHRT_MAX];
   b = [NSNumber numberWithUnsignedShort:SHRT_MIN];
   compare( a, b);


   printf( "\nunsigned int\n");
   a = [NSNumber numberWithUnsignedInt:INT_MAX];
   b = [NSNumber numberWithUnsignedInt:INT_MIN];
   compare( a, b);

   printf( "\nunsigned long\n");
   a = [NSNumber numberWithUnsignedLong:LONG_MAX];
   b = [NSNumber numberWithUnsignedLong:LONG_MIN];
   compare( a, b);

   printf( "\nunsigned long long\n");
   a = [NSNumber numberWithUnsignedLongLong:LONG_LONG_MAX];
   b = [NSNumber numberWithUnsignedLongLong:LONG_LONG_MIN];
   compare( a, b);

   printf( "\nNSUInteger\n");
   a = [NSNumber numberWithUnsignedInteger:NSIntegerMax];
   b = [NSNumber numberWithUnsignedInteger:NSIntegerMin];
   compare( a, b);


   printf( "\nfloat\n");
   a = [NSNumber numberWithFloat:FLT_MAX];
   b = [NSNumber numberWithFloat:FLT_MIN];
   compare( a, b);

   printf( "\ndouble\n");
   a = [NSNumber numberWithDouble:DBL_MAX];
   b = [NSNumber numberWithDouble:DBL_MIN];
   compare( a, b);


   printf( "\nunsigned char, char\n");
   a = [NSNumber numberWithUnsignedShort:CHAR_MIN];
   b = [NSNumber numberWithShort:CHAR_MIN];
   compare( a, b);

   printf( "\nunsigned short, short\n");
   a = [NSNumber numberWithUnsignedShort:SHRT_MIN];
   b = [NSNumber numberWithShort:SHRT_MIN];
   compare( a, b);

   printf( "\nunsigned int, int\n");
   a = [NSNumber numberWithUnsignedInt:INT_MIN];
   b = [NSNumber numberWithInt:INT_MIN];
   compare( a, b);

   printf( "\ndouble, int\n");
   a = [NSNumber numberWithDouble:INT_MIN];
   b = [NSNumber numberWithInt:INT_MIN];
   compare( a, b);
}
