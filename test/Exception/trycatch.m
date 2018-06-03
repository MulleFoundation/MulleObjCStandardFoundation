//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//#import "MulleStandaloneObjCFoundation.h"


@interface Foo : NSObject
@end


@implementation Foo

+ (void) test
{
   NSException   *exception;

   printf( "start\n");
   exception = nil;
   printf( "before exception%snil\n", exception ? "!=" : "==");
   @try
   {
      printf( "@try\n");
   }
   @catch( NSException *localException)
   {
      printf( "@catch\n");
      exception = localException;
   }
   printf( "after exception%snil\n", exception ? "!=" : "==");
   [exception raise];
   printf( "done\n");
}

@end


int main(int argc, const char * argv[])
{
   [Foo test];
   return( 0);
}
