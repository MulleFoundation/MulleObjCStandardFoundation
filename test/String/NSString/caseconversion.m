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
   char       text[] = "VfL Bochum 1848";
   NSString   *s;

   s = [NSString mulleStringWithUTF8Characters:(void *) text
                                        length:sizeof( text)];

   mulle_printf( "%s\n", [[s lowercaseString] UTF8String]);
   mulle_printf( "%s\n", [[s capitalizedString] UTF8String]);
   mulle_printf( "%s\n", [[s uppercaseString] UTF8String]);
   mulle_printf( "%s\n", [[s mulleDecapitalizedString] UTF8String]);

   return( 0);
}
