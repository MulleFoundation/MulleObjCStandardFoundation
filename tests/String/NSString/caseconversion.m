//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


int main( int argc, const char * argv[])
{
   char       text[] = "VfL Bochum 1848";
   NSString   *s;

   s = [NSString _stringWithUTF8Characters:text
                                    length:sizeof( text)];

   printf( "%s\n", [[s lowercaseString] UTF8String]);
   printf( "%s\n", [[s capitalizedString] UTF8String]);
   printf( "%s\n", [[s uppercaseString] UTF8String]);

   return( 0);
}
