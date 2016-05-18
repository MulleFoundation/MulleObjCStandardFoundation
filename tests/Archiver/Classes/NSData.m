//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>



static id    clone( id obj)
{
   NSData   *data;
   id       copy;

   data = [NSArchiver archivedDataWithRootObject:obj];
   copy = [NSUnarchiver unarchiveObjectWithData:data];
   if( [obj isEqual:copy])
      printf( "passed\n");
   else
      printf( "failed\n");
}


static mulle_utf8_t    hoehoe[] =
{
   0x22, 0x48, 0xc3, 0xb6, 0x68, 0xc3, 0xb6, 0x68,
   0xc3, 0xb6, 0x2c, 0x20, 0x77, 0x69, 0x72, 0x20,
   0x73, 0x69, 0x6e, 0x64, 0x20, 0x64, 0x69, 0x65,
   0x20, 0x47, 0x72, 0xc3, 0xb6, 0xc3, 0x9f, 0x74,
   0x65, 0x6e, 0x2e, 0x22, 0x20, 0x2d, 0x20, 0x22,
   0x47, 0x72, 0xc3, 0xb6, 0xc3, 0x9f, 0x74, 0x65,
   0x6e, 0x20, 0x77, 0x61, 0x73, 0x20, 0x3f, 0x22,
   0
};


@implementation NSData  ( TestLazyiness)

+ (id) dataWithUTF8String:(mulle_utf8_t *) s
{
  return( [self dataWithBytes:s
                       length:mulle_utf8_strlen( s)]);
}
@end



int main(int argc, const char * argv[])
{

  clone( [NSData dataWithUTF8String:""]);
  clone( [NSData dataWithUTF8String:"a"]);
  clone( [NSData dataWithUTF8String:"ab"]);
  clone( [NSData dataWithUTF8String:"abc"]);
  clone( [NSData dataWithUTF8String:"abcd"]);
  clone( [NSData dataWithUTF8String:"abcde"]);
  clone( [NSData dataWithUTF8String:"abcdef"]);
  clone( [NSData dataWithUTF8String:"abcdefg"]);
  clone( [NSData dataWithUTF8String:"abcdefgh"]);
  clone( [NSData dataWithUTF8String:"abcdefghi"]);
  clone( [NSData dataWithUTF8String:"abcdefghij"]);
  clone( [NSData dataWithUTF8String:"abcdefghijk"]);
  clone( [NSData dataWithUTF8String:"abcdefghijkl"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklm"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmn"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmno"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnop"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnopr"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnoprs"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnoprst"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnoprstu"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnoprstuv"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnoprstuvw"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnoprstuvwx"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnoprstuvwxy"]);
  clone( [NSData dataWithUTF8String:"abcdefghijklmnoprstuvwxyz"]);
  clone( [NSData dataWithUTF8String:hoehoe]);

  return( 0);
}
