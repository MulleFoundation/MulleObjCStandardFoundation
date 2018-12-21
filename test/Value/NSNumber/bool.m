#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif



static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}


main()
{
   NSNumber   *value;

   value = [NSNumber numberWithBool:YES];
   print_bool( [value boolValue]);

   value = [NSNumber numberWithBool:NO];
   print_bool( [value boolValue]);

   return( 0);
}
