//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


void  memset_char5( char *s, size_t len)
{
   static char  table[] =
   {
      '.', '0', '1', '2', 'A', 'C', 'E', 'I',
      'L', 'M', 'P', 'R', 'S', 'T', '_', 'a',
      'b', 'c', 'd', 'e', 'g', 'i', 'l', 'm',
      'n', 'o', 'p', 'r', 's', 't', 'u'
   };

   char           *sentinel;
   unsigned int  i;

   i        = 30;
   sentinel = &s[ len];
   while( s < sentinel)
      *s++ = table[ i++ % sizeof( table)];
}


static void  check( NSString *s, char *buf, size_t len)
{
   char   *utf8;

   if( [s length] != len)
   {
      printf( "%d failed length\n", (int) len);
      abort();
   }

   utf8 = [s UTF8String];
   if( strncmp( utf8, buf, len))
   {
      printf( "%d failed strcmp\n", (int) len);
      abort();
   }
}


int main( int argc, const char * argv[])
{
   auto char   buf[ 1024];
   NSString    *s;
   int         i;

   for( i = 0; i < 1023; i++)
   {
      memset_char5( buf, i);
      buf[ i] = 0;

      @autoreleasepool
      {
         s = [NSString stringWithUTF8String:buf];
         check( s, buf, i);

         if( i >= 2)
         {
            s = [s substringWithRange:NSMakeRange( 1, i - 2)];
            check( s, &buf[ 1], i - 2);
         }
      }
   }

   return( 0);
}
