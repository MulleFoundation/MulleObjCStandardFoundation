//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


@interface Foo : NSObject
@end

@implementation Foo

+ (void) test
{
   NSAutoreleasePool        *pool;
   NSException              *exception;

   pool = [NSAutoreleasePool new];
   {
      mulle_printf( "start\n");
      exception = nil;
      mulle_printf( "before\n");
   NS_DURING
      mulle_printf( "NS_DURING\n");

   NS_HANDLER
      mulle_printf( "NS_HANDLER\n");
      exception = localException;
   NS_ENDHANDLER
      mulle_printf( "after\n");
      [exception raise];
      mulle_printf( "done\n");
   }
   [pool release];
}

@end


int main(int argc, const char * argv[])
{
   [Foo test];
   return( 0);
}
