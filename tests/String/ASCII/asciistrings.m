//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"



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


   memset( buf, 0, sizeof( buf));
   s = [NSString stringWithUTF8String:buf];
   check( s, buf, 0);

   for( i = 1; i < 1023; i++)
   {
      buf[ i - 1] = ' ' + (i & 0x5F);

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
