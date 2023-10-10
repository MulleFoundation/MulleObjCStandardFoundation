//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"



static unsigned char    hoehoe[] =
{
   0x22, 0x48, 0xc3, 0xb6, 0x68, 0xc3, 0xb6, 0x68,
   0xc3, 0xb6, 0x2c, 0x20, 0x77, 0x69, 0x72, 0x20,
   0x73, 0x69, 0x6e, 0x64, 0x20, 0x64, 0x69, 0x65,
   0x20, 0x47, 0x72, 0xc3, 0xb6, 0xc3, 0x9f, 0x74,
   0x65, 0x6e, 0x2e, 0x22, 0x20, 0x2d, 0x20, 0x22,
   0x47, 0x72, 0xc3, 0xb6, 0xc3, 0x9f, 0x74, 0x65,
   0x6e, 0x20, 0x77, 0x61, 0x73, 0x20, 0x3f, 0x22
};


int   main( int argc, const char * argv[])
{
   NSString       *s;
   NSString       *copy;
   unichar        buf[ 128];
   unsigned int   i;

   for( i = 0; i <= sizeof( hoehoe); i++)
   {
      if( ! [NSString mulleAreValidUTF8Characters:hoehoe
                                           length:i])
      {
         continue;
      }
      s = [NSString mulleStringWithUTF8Characters:hoehoe
                                           length:i];
      [s getCharacters:buf];
      copy = [NSString stringWithCharacters:buf
                                     length:[s length]];
      printf( "%s (%ld/%ld) -> %s (%ld/%ld)\n",
                  [s UTF8String], [s length], [s mulleUTF8StringLength],
                  [copy UTF8String], [copy length], [copy mulleUTF8StringLength]);
   }

   return( 0);
}
