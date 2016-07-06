#ifndef __MULLE_OBJC_RUNTIME__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCFoundation/MulleObjCFoundation.h>
#endif



static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}



main()
{
   NSValue   *value;

   value = [NSValue valueWithRange:NSMakeRange( INTPTR_MAX, INTPTR_MIN)];
   print_bool( NSEqualRanges( [value rangeValue], NSMakeRange( INTPTR_MAX, INTPTR_MIN)));

   value = [NSValue valueWithRange:NSMakeRange( 0, INTPTR_MIN)];
   print_bool( NSEqualRanges( [value rangeValue], NSMakeRange( 0, INTPTR_MIN)));


   value = [NSValue valueWithRange:NSMakeRange( 1848, -1848)];
   print_bool( NSEqualRanges( [value rangeValue], NSMakeRange( 1848, -1848)));
}
