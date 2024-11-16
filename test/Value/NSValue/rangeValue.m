#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif



static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}



int   main( void)
{
   NSValue   *value;

   value = [NSValue valueWithRange:NSRangeMake( INTPTR_MAX, INTPTR_MIN)];
   print_bool( NSEqualRanges( [value rangeValue], NSRangeMake( INTPTR_MAX, INTPTR_MIN)));

   value = [NSValue valueWithRange:NSRangeMake( 0, INTPTR_MIN)];
   print_bool( NSEqualRanges( [value rangeValue], NSRangeMake( 0, INTPTR_MIN)));


   value = [NSValue valueWithRange:NSRangeMake( 1848, -1848)];
   print_bool( NSEqualRanges( [value rangeValue], NSRangeMake( 1848, -1848)));
}
