//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"



int main(int argc, const char * argv[])
{
   NSString         *s;
   NSString         *copy;
   unichar          buf[ 128];
   unsigned int     i;

   for( i = 0; i <= 26; i++)
   {
      s = [NSString _stringWithUTF8Characters:"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                       length:i];
      [s getCharacters:buf];
      copy = [NSString stringWithCharacters:buf
                                     length:[s length]];
      printf( "%s (%ld/%ld) -> %s (%ld/%ld)\n",
                  [s UTF8String], [s length], [s _UTF8StringLength],
                  [copy UTF8String], [copy length], [copy _UTF8StringLength]);
   }

   return( 0);
}
