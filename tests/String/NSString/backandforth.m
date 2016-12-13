#import <MulleObjCFoundation/MulleObjCFoundation.h>

#include <stdio.h>
#include <stdlib.h>


static mulle_utf32_t   random_char( mulle_utf32_t mask)
{
   mulle_utf32_t  c;

   do
   {
      c = rand() % mulle_utf32_max + 1;
      c &= mask;
      if( ! c)
         continue;
   }
   while( mulle_utf32_is_bomcharacter( c) || mulle_utf32_is_noncharacter( c) || mulle_utf32_is_privatecharacter( c));

   return( c);
}



static void   random_text( mulle_utf32_t *text, size_t n, mulle_utf32_t mask)
{
   mulle_utf32_t   *sentinel;

   sentinel = &text[ n];
   while( text < sentinel)
      *text++ = random_char( mask);
}


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
   struct buffer   buffer32;
   struct buffer   buffer16;
   struct buffer   buffer8;
   NSString        *s32;
   NSString        *s16;
   NSString        *s8;
   NSData          *data;


   memset( &buffer32, 0, sizeof( buffer32));
   memset( &buffer16, 0, sizeof( buffer16));
   memset( &buffer8, 0, sizeof( buffer8));

   mulle_utf32_bufferconvert_to_utf16( text, 4, &buffer16, (void *) buffer_add);
   mulle_utf16_bufferconvert_to_utf8( buffer16.text._16, buffer16.n / sizeof( mulle_utf16_t), &buffer8, (void *) buffer_add);

   s8  = [NSString _stringWithUTF8Characters:buffer8.text._8
                                      length:buffer8.n];
   s16 = [[[NSString alloc] _initWithUTF16Characters:buffer16.text._16
                                              length:buffer16.n / sizeof( mulle_utf16_t)] autorelease];
   s32 = [NSString stringWithCharacters:text
                                 length:4];

   if( ! [s8 isEqual:s16])
   {
      printf( "%.4S failed\n", text);
      return;
   }

   if( ! [s32 isEqual:s16])
   {
      printf( "%.4S failed\n", text);
      return;
   }

   data = [s32 dataUsingEncoding:NSUTF8StringEncoding];
   s32  = [[[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding] autorelease];

   if( ! [s8 isEqual:s16])
   {
      printf( "%.4S failed\n", text);
      return;
   }

   data = [s32 dataUsingEncoding:NSUTF16StringEncoding];
   s32  = [[[NSString alloc] initWithData:data
                                 encoding:NSUTF16StringEncoding] autorelease];

   if( ! [s8 isEqual:s16])
   {
      printf( "%.4S failed\n", text);
      return;
   }

   data = [s32 dataUsingEncoding:NSUTF32StringEncoding];
   s32  = [[[NSString alloc] initWithData:data
                                 encoding:NSUTF32StringEncoding] autorelease];
   if( ! [s8 isEqual:s16])
   {
      printf( "%.4S failed\n", text);
      return;
   }
}


static void   stress_test()
{
   mulle_utf32_t   text[ 4];
   unsigned int    i;
   mulle_utf32_t   mask;

   mask = 0;
   for( i = 0; i < 100000; i++)
   {
      if( i % 100 == 0)
         fprintf( stderr, "%ld\n", i);

      switch( rand() % 5)
      {
      case 0 : mask = 0x7F; break;
      case 1 : mask = 0xFF; break;
      case 2 : mask = 0x7FFF; break;
      case 3 : mask = 0xFFFF; break;
      case 4 : mask = 0x1FFFFF; break;
      }

      random_text( text, 4, mask);

      @autoreleasepool
      {
         test( text);
      }
   }
}



int  main()
{
   mulle_utf32_t   killer[ 4] = { 65279, 47177, 29938, 18497 };
   mulle_utf32_t   utf15[ 4]  = { 23589, 21787, 15173, 15909 };
   mulle_utf32_t   big[ 4]    = { 0x0000c67c, 0x000e49d5, 0x000c3154, 0x000d303d };
   mulle_utf32_t   zero[ 4]   = { 0, 87, 21, 51 };

   test( zero);
   test( big);
   test( utf15);
   test( killer);

   stress_test();
}

