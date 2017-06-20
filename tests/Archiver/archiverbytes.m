//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


@interface Foo : NSObject <NSCoding>
@end




@implementation Foo

- (id) initWithCoder:(NSCoder *) aDecoder
{
   char         *s;
   NSUInteger   length;

   s = [aDecoder decodeBytesWithReturnedLength:&length];
   printf( "%ld: %s\n", length, s);

   return(self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
  static char   text[] =  "VfL Bochum 1848";

  [coder encodeBytes:text
              length:sizeof( text)];
}


@end



int   main( int argc, const char * argv[])
{
   Foo      *foo;
   Foo      *foo2;
   NSData   *data;

   foo  = [[Foo new] autorelease];

   data = [NSArchiver archivedDataWithRootObject:foo];
   foo2 = [NSUnarchiver unarchiveObjectWithData:data];

   return( 0);
}
