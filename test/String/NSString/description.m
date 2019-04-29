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

   s = [NSString mulleStringWithUTF8Characters:text
                                    length:sizeof( text)];

   printf( "%s\n", [[s description] UTF8String]);

   s = [NSString mulleStringWithUTF8CharactersNoCopy:text
                                          length:sizeof( text)
                                       allocator:NULL];
   printf( "%s\n", [[s description] UTF8String]);

   return( 0);
}
