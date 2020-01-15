#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

#include <stdio.h>


static int   fail( char *title, NSNumber *a, NSNumber *b, int index)
{
   printf( "%d: %s Number FAIL %lld vs. %lld",
         index, title,
         [a longLongValue], [b longLongValue]);
#ifdef PRINT_ENCODE
   printf( " (%s vs. %s)", [a objCType], [b objCType]);
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


static void   test( char value)
{
   int       index = 1;
   NSNumber  *nr;
   int       fails;

   nr = [NSNumber numberWithChar:value];
   fails  = 0;
   fails += check( "char",               nr, [NSNumber numberWithChar:value], &index);
   fails += check( "unsigned char",      nr, [NSNumber numberWithUnsignedChar:value], &index);
   fails += check( "short",              nr, [NSNumber numberWithShort:value], &index);
   fails += check( "unsigned short",     nr, [NSNumber numberWithUnsignedShort:value], &index);
   fails += check( "int",                nr, [NSNumber numberWithInt:value], &index);
   fails += check( "unsigned int",       nr, [NSNumber numberWithUnsignedInt:value], &index);
   fails += check( "long",               nr, [NSNumber numberWithLong:value], &index);
   fails += check( "unsigned long",      nr, [NSNumber numberWithUnsignedLong:value], &index);
   fails += check( "long long",          nr, [NSNumber numberWithLongLong:value], &index);
   fails += check( "unsigned long long", nr, [NSNumber numberWithUnsignedLongLong:value], &index);
   fails += check( "NSInteger",          nr, [NSNumber numberWithInteger:value], &index);
   fails += check( "NSUInteger",         nr, [NSNumber numberWithUnsignedInteger:value], &index);
   fails += check( "float",              nr, [NSNumber numberWithFloat:value], &index);
   fails += check( "double",             nr, [NSNumber numberWithDouble:value], &index);
#ifdef __MULLE_OBJC__
   fails += check( "long double",        nr, [NSNumber numberWithLongDouble:value], &index);
#endif
   if( fails == 0)
      printf( "%d PASSED\n", value);
}



int  main( void)
{
   test( CHAR_MIN);
   test( NO);
   test( YES);
   test( CHAR_MAX);
   return( 0);
}
