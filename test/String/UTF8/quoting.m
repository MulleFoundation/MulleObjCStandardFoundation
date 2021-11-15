//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"



static mulle_utf8_t    hoehoe[] =
{
   'T', 'A', 'B', ':', '\t',   '\n',
   '\\', '1',     ':', '\001', '\n',
   '\\', 'f',     ':', '\f',   '\n',
   '\\', 'e',     ':', '\e',   '\n',
   'D', 'E', 'L', ':',  127,   '\n',
   '?', '\n',
   '\xe2', '\x98', '\x84', '\xef', '\xb8', '\x8f', '\xe2', '\x98',
   '\x83', '\xef', '\xb8', '\x8f', '\xf0', '\x9f', '\x91', '\x8d',
   '\xf0', '\x9f', '\x8f', '\xbe'
};


int   main( int argc, const char * argv[])
{
   NSString   *s;
   NSString   *quoted;
   NSString   *unquoted;

   s = [NSString mulleStringWithUTF8Characters:hoehoe
                                        length:sizeof( hoehoe)];
   if( ! s)
      return( 1);

   quoted   = [s mulleQuotedString];
   unquoted = [quoted mulleUnquotedString];
   printf( "C        : %s\n", hoehoe);
   printf( "Original : %s\n", [s UTF8String]);
   printf( "Quoted   : %s\n", [quoted UTF8String]);
   printf( "Unquoted : %s\n", [unquoted UTF8String]);

   return( [unquoted isEqualToString:s] == YES ? 0 : -1);
}
