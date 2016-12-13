#import <MulleObjCFoundation/MulleObjCFoundation.h>

#include <stdio.h>
#include <stdlib.h>


struct buffer
{
   union
   {
      mulle_utf32_t   _32[ 8];
      mulle_utf16_t   _16[ 16];
      mulle_utf8_t    _8[ 32];
   } text;
   size_t         n;
};


static void  buffer_add( struct buffer *p, void *bytes, size_t len)
{
   memcpy( &p->text._8[ p->n], bytes, len);
   p->n += len;
}



static void   test( mulle_utf32_t text[ 4])
{
   struct buffer   buffer8;
   NSString        *s8;

   memset( &buffer8, 0, sizeof( buffer8));
   mulle_utf32_bufferconvert_to_utf8( text, 4, &buffer8, (void *) buffer_add);

   s8 = [NSString _stringWithUTF8Characters:buffer8.text._8
                                     length:buffer8.n];
}


int  main()
{
   mulle_utf32_t   big[ 4] = { 0x0000c67c, 0x000e49d5, 0x000c3154, 0x000d303d };

   test( big);
}

