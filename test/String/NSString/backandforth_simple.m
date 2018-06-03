#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>

#include <stdio.h>
#include <stdlib.h>


static void   test( mulle_utf32_t text[ 4])
{
   NSString   *s32;
   NSData     *data;


   s32 = [NSString stringWithCharacters:text
                                 length:4];

   data = [s32 dataUsingEncoding:NSUTF32StringEncoding];
   s32  = [[[NSString alloc] initWithData:data
                                 encoding:NSUTF32StringEncoding] autorelease];
}


int  main()
{
   mulle_utf32_t   big[ 4]    = { 0x0000c67c, 0x000e49d5, 0x000c3154, 0x000d303d };

   test( big);
}

