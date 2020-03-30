#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif



int  main( void)
{
   NSValue   *value;
   struct
   {
      SEL   sel1;
      SEL   sel2;
      SEL   sel3;
   } local;

   memset( &local, 0, sizeof( local));

   local.sel1  = @selector( self);
   value = [NSValue valueWithBytes:&local.sel1
                          objCType:@encode( SEL)];

   [value getValue:&local.sel2];
   if( local.sel3 != 0)
      return( -2);
   return( local.sel1 == local.sel2 ? 0 : -1);
}
