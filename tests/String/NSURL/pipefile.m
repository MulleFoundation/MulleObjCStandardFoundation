//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"

char  *safe_string( char *s)
{
   return( s ? s : "*null*");
}


int main( int argc, const char * argv[])
{
   NSURL   *url;
   char    *a, *b;

   url = [NSURL URLWithString:@"/|.scion"];
   if( url)
   {
      a = safe_string( [[url host] UTF8String]);
      b = safe_string( [[url path] UTF8String]);
      printf( "%s %s\n", a, b);
   }
   else
      printf( "invalid #1\n");

   url = [NSURL URLWithString:@"|.scion"];
   if( url)
   {
      a = safe_string( [[url host] UTF8String]);
      b = safe_string( [[url path] UTF8String]);
      printf( "%s %s\n", a, b);
   }
   else
      printf( "invalid #1\n");

   return( 0);
}
