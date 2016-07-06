//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


#define RED   " " // "\033[01;31m"
#define NONE  " " // "\033[00m"

int main( int argc, const char * argv[])
{
   NSString   *s;

   s = [NSString stringWithFormat:@"%.*s" RED "%c" NONE "%.*s",
         (int) 12, "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
         (unsigned char) '{',
         (int) 7, "0123456789"];

   printf( "%s\n", [s UTF8String]);

   return( 0);
}
