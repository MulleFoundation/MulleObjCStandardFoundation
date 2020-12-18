//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"



//
// try to create all possible subclasses and isEqual them. this merely
// exercises some code and finds missing implementations
//
int main( int argc, const char * argv[])
{
   printf( "%s", [[[NSCharacterSet letterCharacterSet] mulleTestDescription] UTF8String]);

   return( 0);
}
