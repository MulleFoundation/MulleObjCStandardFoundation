#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif



static void print_bool( BOOL flag)
{
   mulle_printf( "%s\n", flag ? "YES" : "NO");
}


int   main( void)
{
   NSNumber   *value;

   value = [NSNumber numberWithBool:YES];
   mulle_printf( "%s\n", [value UTF8String]);

   value = [NSNumber numberWithBool:NO];
   mulle_printf( "%s\n", [value UTF8String]);
   return( 0);
}
