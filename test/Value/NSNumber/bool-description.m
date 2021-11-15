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
   printf( "%s\n", [value UTF8String]);

   value = [NSNumber numberWithBool:NO];
   printf( "%s\n", [value UTF8String]);
   return( 0);
}
