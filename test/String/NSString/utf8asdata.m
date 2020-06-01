#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>

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



static void   test( char *testname, mulle_utf32_t text[ 4], size_t expect)
{
   struct buffer   buffer8;
   NSString        *s;

   printf( "test %s ", testname);

   memset( &buffer8, 0, sizeof( buffer8));
   mulle_utf32_bufferconvert_to_utf8( text,
                                      4,
                                      &buffer8,
                                     (void *) buffer_add);

   s = [[[NSString  alloc] initWithBytes:buffer8.text._8
                                  length:0
                                encoding:NSUTF8StringEncoding] autorelease];
   if( ! s || [s length])
   {
      printf( "zero length failed\n");
      return;
   }

   s = [[[NSString  alloc] initWithBytes:NULL
                                  length:0
                                encoding:NSUTF8StringEncoding] autorelease];
   if( ! s || [s length])
   {
      printf( "NULL failed\n");
      return;
   }

   s = [[[NSString  alloc] initWithBytes:buffer8.text._8
                                  length:buffer8.n
                                encoding:NSUTF8StringEncoding] autorelease];
   if( [s length] != expect)
   {
      printf( "string length failed (%ld<>%ld)\n", (long) [s length], (long) expect);
      return;
   }

   printf( "passed\n");
}


int  main()
{
   mulle_utf32_t   killer[ 4] = { 65279, 47177, 29938, 18497 };
   mulle_utf32_t   utf15[ 4]  = { 23589, 21787, 15173, 15909 };
   mulle_utf32_t   big[ 4]    = { 0x0000c67c, 0x000e49d5, 0x000c3154, 0x000d303d };
   mulle_utf32_t   zero[ 4]   = { 0, 87, 21, 51 };

   test( "big", big, 4);
   test( "killer", killer, 3);
   test( "utf15", utf15, 4);
   test( "zero", zero, 0);
}

