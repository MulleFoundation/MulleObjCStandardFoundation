#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>

#include <stdio.h>
#include <stdlib.h>


int   main( void)
{
   NSString     *obj;
   NSUInteger   len;
   char         buf[ 256];
   char         *params_1[] =
   {
      "L\xc3\xb6\xc3\xb6\xc3\xb6\xc3\xb6orem ipsum dolor sit amet, consectetur "
      "adipisici elit, sed eiusmod "
   };
   NSUInteger  n_1 = sizeof( params_1) / sizeof( params_1[ 0]);

   obj = [[[NSString alloc] initWithUTF8String:params_1[ 0]] autorelease];
   len = [obj mulleGetUTF8Characters:buf
                           maxLength:2];
   mulle_printf( "\"%.*@\": %td %td\n", len, obj, [obj length], len);
   return( 0);
}

