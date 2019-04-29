//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


int main( int argc, const char * argv[])
{
   int        i;
   NSNumber   *nr;
   NSString   *s;

   // 128 creates invalid UTF8
   for( i = 32 ; i <= 128; i++)
   {  
      @try 
      {
         s  = [NSString stringWithFormat:@"%c", i];
         nr = [NSNumber numberWithDouble:(double) i / 10];
         printf( "%s:\"%s\"\n",
                   [[nr description] UTF8String],
                   [[s description] UTF8String]);
      }
      @catch( NSException *e)
      {
         printf( "exception: %s\n", [[e reason] UTF8String]);
      }
   }
   return( 0);
}
