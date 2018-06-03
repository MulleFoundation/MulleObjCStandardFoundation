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
@property double  d;
@property int     i;

@end


@interface Bar : NSObject <NSCoding>

@property(retain) Foo *foo;

@end


@implementation Foo

- (id) initWithCoder:(NSCoder *) aDecoder
{
   [self init];

   [aDecoder decodeValueOfObjCType:@encode( int)
                                at:&_i];
   [aDecoder decodeValueOfObjCType:@encode( double)
                                at:&_d];
   [aDecoder decodeValueOfObjCType:@encode( char *)
                                at:&_str];  // malloced ?
   return(self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   [coder encodeValueOfObjCType:@encode( int)
                             at:&_i];
   [coder encodeValueOfObjCType:@encode( double)
                             at:&_d];
   [coder encodeValueOfObjCType:@encode( char *)
                             at:&_str];
}


- (void) setStr:(char *) s
{
   MulleObjCObjectDeallocateMemory( self, _str);
   _str = s ? MulleObjCObjectDuplicateCString( self, s) : s;
}

@end


@implementation Bar

- (id) initWithCoder:(NSCoder *) decoder
{
   [self init];

   _foo = [[decoder decodeObject] retain];

   return(self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   [coder encodeObject:_foo];
}

@end


int main(int argc, const char * argv[])
{
   Foo      *foo;
   Foo      *foo2;
   Bar      *bar;
   Bar      *bar2;
   NSData   *data;

   foo = [[Foo new] autorelease];

   [foo setStr:"VfL Bochum 1848"];
   [foo setD:18.48];
   [foo setI:1848];

   bar = [[Bar new] autorelease];
   [bar setFoo:foo];

   data = [NSArchiver archivedDataWithRootObject:bar];
   bar2 = [NSUnarchiver unarchiveObjectWithData:data];
   if( ! bar2)
   {
      printf( "Failed\n");
      return( 1);
   }

   foo2 = [bar2 foo];
   printf( "%s\n", [foo2 str]);
   printf( "%f\n", [foo2 d]);
   printf( "%d\n", [foo2 i]);

   return( 0);
}
