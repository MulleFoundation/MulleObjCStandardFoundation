#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


// valgrind doesn't do long double so this won't pass

#include <stdio.h>
#include <limits.h>
#include <float.h>

//#define PRINT_ENCODE
//#define PRINT_CLASS

static int   fail( char *title, NSNumber *a, NSNumber *b, int index)
{
   printf( "%d: %s Number FAIL %s vs. %s",
         index, title,
         [[a description] UTF8String],
         [[b description] UTF8String]);
#ifdef PRINT_ENCODE
   printf( " (%s vs. %s)", [a objCType], [b objCType]);
#endif
#ifdef PRINT_ENCODE
   printf( " (%s vs. %s)", [NSStringFromClass( [a class]) UTF8String],
                           [NSStringFromClass( [b class]) UTF8String]);
#endif
   printf( "\n");
   return( 1);
}


static int   check( char *title, NSNumber *a, NSNumber *b, int *index)
{
   int   fails;

   fails = 0;
   if( ! [a isEqualToNumber:b])
      fails += fail( title, a, b, *index);
   ++*index;

   if( ! [a isEqual:b])
      fails += fail( title, a, b, *index);
   ++*index;

   return( fails);
}


static void   test( long double value)
{
   int       index = 1;
   NSNumber  *nr;
   int       fails;

   nr = [NSNumber numberWithLongDouble:value];

   fails  = 0;
   fails += check( "float",       nr, [NSNumber numberWithFloat:value], &index);
   fails += check( "double",      nr, [NSNumber numberWithDouble:value], &index);
#ifdef __MULLE_OBJC__
   fails += check( "long double", nr, [NSNumber numberWithLongDouble:value], &index);
#endif

   if( fails == 0)
      printf( "%Lg PASSED\n\n", value);
   else
      printf( "%Lg FAILED\n\n", value);
}



int  main( void)
{
   test( LDBL_MIN);
   test( DBL_MIN);
   test( FLT_MIN);
   test( 0);
   test( 1);
   test( FLT_MAX);
   test( DBL_MAX);
   test( LDBL_MAX);

   return( 0);
}
