//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"



int main( int argc, const char * argv[])
{
   auto char   buf[ 1024];
   NSString    *s;
   int         i;

   for( i = 0; i < 1023; i++)
   {
      memset( buf, '.', i);
      buf[ i] = 0;

      @autoreleasepool
      {
         s = [NSString stringWithUTF8String:buf];
         if( [s length] != i || strcmp( [s UTF8String], buf))
         {
            printf( "%d failed\n", i);
            abort();
         }
      }
   }

   return( 0);
}
