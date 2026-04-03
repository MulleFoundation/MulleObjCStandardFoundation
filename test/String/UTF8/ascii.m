//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"



int main(int argc, const char * argv[])
{
   NSString         *s;
   NSString         *copy;
   unichar          buf[ 128];
   unsigned int     i;

   for( i = 0; i <= 26; i++)
   {
      s = [NSString mulleStringWithUTF8Characters:(void *) "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                       length:i];
      [s getCharacters:buf];
      copy = [NSString stringWithCharacters:buf
                                     length:[s length]];
      mulle_printf( "%s (%td/%td) -> %s (%td/%td)\n",
                  [s UTF8String], (ptrdiff_t) [s length], (ptrdiff_t) [s mulleUTF8StringLength],
                  [copy UTF8String], (ptrdiff_t) [copy length], (ptrdiff_t) [copy mulleUTF8StringLength]);
   }

   return( 0);
}
