#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif



int  main( void)
{
   NSValue   *value;
   SEL       sel;

   sel   = @selector(a:b:c:);
#if 0
   printf( "%s\n",
      [[NSString stringWithFormat:@"@( @selector( %@))", NSStringFromSelector( sel)] UTF8String]);
   return( 0);
#endif
   value = [NSValue valueWithBytes:&sel
                          objCType:@encode( SEL)];

   printf( "%s\n", [[value description] UTF8String]);
   return( 0);
}
