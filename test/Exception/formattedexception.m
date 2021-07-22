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
   @try
   {
    [NSException raise:NSInvalidArgumentException
                format:@"%@,%lu: %@", @"filename", (long) 1234, @"whatever"];
   }
   @catch( NSException *localException)
   {
      printf( "%s: %s\n", [[localException name] UTF8String],
                          [[localException reason] UTF8String]);
      return( 0);
   }
   return( 1);
}
