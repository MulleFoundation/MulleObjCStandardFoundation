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

   mulle_printf( "start\n");
   exception = nil;
   mulle_printf( "before exception%snil\n", exception ? "!=" : "==");
   @try
   {
      mulle_printf( "@try\n");
   }
   @catch( NSException *localException)
   {
      mulle_printf( "@catch\n");
      exception = localException;
   }
   mulle_printf( "after exception%snil\n", exception ? "!=" : "==");
   [exception raise];
   mulle_printf( "done\n");
}

@end


int main(int argc, const char * argv[])
{
   [Foo test];
   return( 0);
}
