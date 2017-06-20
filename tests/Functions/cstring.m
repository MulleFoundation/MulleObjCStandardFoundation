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

- (void) dealloc
{
//   printf( "dealloc\n");
   [super dealloc];
}


- (void) setStr:(char *) s
{
   printf( "%s -> %s\n",
      _str ? _str : "*null*",
       s ? s : "*null*");
   MulleObjCObjectDeallocateMemory( self, _str);
   _str = s ? MulleObjCObjectDuplicateCString( self, s) : NULL;
}

@end


// this test demonstrates:
//  MulleObjCObjectDuplicateCString
// and its being released properly during  dealloc
// since it's a property

int main(int argc, const char * argv[])
{
   Foo      *foo;

   foo = [[Foo new] autorelease];

   [foo setStr:"VfL"];
   [foo setStr:"Bochum"];

   return( 0);
}
