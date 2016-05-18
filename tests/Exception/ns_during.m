//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>
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
      printf( "start\n");
      exception = nil;
      printf( "before\n");
   NS_DURING
      printf( "NS_DURING\n");

   NS_HANDLER
      printf( "NS_HANDLER\n");
      exception = localException;
   NS_ENDHANDLER
      printf( "after\n");
      [exception raise];
      printf( "done\n");
   }
   [pool release];
}

@end


int main(int argc, const char * argv[])
{
   [Foo test];
   return( 0);
}
