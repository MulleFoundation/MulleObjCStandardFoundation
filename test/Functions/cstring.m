//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


@interface Foo : NSObject <NSCoding>

@property char    *str;

@end


@implementation Foo


- (void) finalize
{
   fprintf( stderr, "finalize\n");
   [super finalize];
}


- (void) dealloc
{
   fprintf( stderr, "dealloc\n");
   [super dealloc];
}


- (void) setStr:(char *) s
{
   printf( "%s -> %s\n",
      _str ? _str : "*null*",
       s ? s : "*null*");
   MulleObjCInstanceDeallocateMemory( self, _str);
   _str = s ? MulleObjCInstanceDuplicateCString( self, s) : NULL;
}

@end


// this test demonstrates:
//  MulleObjCInstanceDuplicateCString
// and its being released properly during  dealloc
// since it's a property

int   main( int argc, const char * argv[])
{
   Foo   *foo;

   // the automatic autoreleasepool is optimized away
   // when test_allocator is not set, which is confusing

   @autoreleasepool
   {
      foo = [[Foo new] autorelease];

      [foo setStr:"VfL"];
      [foo setStr:"Bochum"];
   }
   return( 0);
}
