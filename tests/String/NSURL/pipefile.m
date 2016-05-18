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
   NSURL *url;

   url = [NSURL URLWithString:@"/|.scion"];
   if( ! url)
      printf( "invalid #1\n");
   else
      printf( "%s %s\n", [[url host] UTF8String], [[url path] UTF8String]);

   url = [NSURL URLWithString:@"|.scion"];
   if( ! url)
      printf( "invalid #2\n");
   else
      printf( "%s %s\n", [[url host] UTF8String], [[url path] UTF8String]);

   return( 0);
}
