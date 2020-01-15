//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


int main(int argc, const char * argv[])
{
   id   obj;

   for( obj in @[ @"a", @"b", @"c", @"d"])
      printf( "%s\n", [obj cStringDescription]);

   return( 0);
}
