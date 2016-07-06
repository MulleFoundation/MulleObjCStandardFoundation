//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import <MulleObjCFoundation/MulleObjCFoundation.h>


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
   NSUInteger   len;
   void         *buf;

   [self init];

   _d = [aDecoder decodeDoubleForKey:@"d"];
   _i = [aDecoder decodeIntForKey:@"i"];

   buf = [aDecoder decodeBytesForKey:@"str"
                      returnedLength:&len];
   if( buf)
      _str = MulleObjCObjectDuplicateCString( self, buf);
   else
      _str = NULL;

   return( self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   [coder encodeInt:_i
             forKey:@"i"];
   [coder encodeDouble:_d
                forKey:@"d"];
   [coder encodeBytes:_str
               length:strlen( _str) + 1
               forKey:@"str"];
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

   _foo = [[decoder decodeObjectForKey:@"foo"] retain];

   return( self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   [coder encodeObject:_foo
                forKey:@"foo"];
}

@end


int   main( int argc, const char * argv[])
{
   Foo      *foo;
   Foo      *foo2;
   Bar      *bar;
   Bar      *bar2;
   NSData   *data;

   @autoreleasepool
   {
      foo = [[Foo new] autorelease];

      [foo setStr:"VfL Bochum 1848"];
      [foo setD:18.48];
      [foo setI:1848];

      bar = [[Bar new] autorelease];
      [bar setFoo:foo];

      bar2 = nil;
      @try
      {
         data = [NSKeyedArchiver archivedDataWithRootObject:bar];
         bar2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
      }
      @catch( NSException *localException)
      {
         NSLog( @"Exception: %@", localException);
         return( 1);
      }

      if( ! bar2)
      {
         printf( "Failed\n");
         return( 1);
      }

      foo2 = [bar2 foo];
      printf( "%s\n", [foo2 str]);
      printf( "%f\n", [foo2 d]);
      printf( "%d\n", [foo2 i]);
   }
   return( 0);
}
