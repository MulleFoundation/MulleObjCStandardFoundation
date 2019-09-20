//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


// hunt for strange bug
NSString  *AStringVariable = @"WithAConstantString";
NSString  *BStringVariable = @"WithBConstantString";

@interface Foo : NSObject
@end

@implementation Foo

MULLE_OBJC_DEPENDS_ON_LIBRARY( MulleObjCStandardFoundation);

+ (void) passAStringVariable:(NSString *) a
                     another:(NSString *) b
{
   printf( "%s\n", [a UTF8String]);
   printf( "%s\n", [b UTF8String]);
}

+ (void) load
{
   [Foo passAStringVariable:AStringVariable
	            another:BStringVariable];
}

@end


int   main( int argc, const char * argv[])
{
   return( 0);
}
