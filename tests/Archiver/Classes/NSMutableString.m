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
      printf( "failed: %s != %s\n", [obj UTF8String], [copy UTF8String]);
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


int main(int argc, const char * argv[])
{

  clone( [NSMutableString stringWithString:@""]);
  clone( [NSMutableString stringWithString:@"VfL Bochum 1848"]);
  clone( [NSMutableString stringWithUTF8String:""]);
  clone( [NSMutableString stringWithUTF8String:"a"]);
  clone( [NSMutableString stringWithUTF8String:"ab"]);
  clone( [NSMutableString stringWithUTF8String:"abc"]);
  clone( [NSMutableString stringWithUTF8String:"abcd"]);
  clone( [NSMutableString stringWithUTF8String:"abcde"]);
  clone( [NSMutableString stringWithUTF8String:"abcdef"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefg"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefgh"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghi"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghij"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijk"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijkl"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklm"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmn"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmno"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnop"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnopr"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnoprs"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnoprst"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnoprstu"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnoprstuv"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnoprstuvw"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnoprstuvwx"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnoprstuvwxy"]);
  clone( [NSMutableString stringWithUTF8String:"abcdefghijklmnoprstuvwxyz"]);
  clone( [NSMutableString stringWithUTF8String:hoehoe]);

  return( 0);
}
