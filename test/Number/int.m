#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

#include <stdio.h>


static int   fail( char *title, SEL sel, NSNumber *a, NSNumber *b, int index)
{
   mulle_printf( "%*d %- 19s: -[<%s %@> %s <%s %@>] FAIL (%lld vs. %lld / %Lg vs. %Lg)",
         2,
         index,
         title,
         MulleObjCInstanceGetClassNameUTF8String( a),
         a,
         MulleObjCSelectorUTF8String( sel),
         MulleObjCInstanceGetClassNameUTF8String( b),
         b,
         [a longLongValue],
         [b longLongValue],
         [a longDoubleValue],
         [b longDoubleValue]);

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
      fails += fail( title, @selector( isEqualToNumber:), a, b, *index);
   ++*index;

   if( ! [a isEqual:b])
      fails += fail( title, @selector( isEqual:), a, b, *index);
   ++*index;

   return( fails);
}


static void   test( int value)
{
   int       index = 1;
   NSNumber  *nr;
   int       fails;

   nr = [NSNumber numberWithInt:value];

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
      printf( "%d PASSED", value);
   printf( "\n");
}



int  main( void)
{
   test( INT_MIN);
   test( SHRT_MIN);
   test( CHAR_MIN);
   test( NO);
   test( YES);
   test( CHAR_MAX);
   test( SHRT_MAX);
   test( INT_MAX);
   return( 0);
}
