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
   NSString   *back;
   NSString   *forth;

   back   = [@"VfL Bochum %1848" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   forth  = [back stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   printf( "%s <-> %s\n", [back UTF8String], [forth UTF8String]);

   return( 0);
}
