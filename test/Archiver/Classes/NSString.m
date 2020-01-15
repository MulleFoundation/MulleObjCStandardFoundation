//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>



static void    clone( id obj)
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


int main(int argc, const char * argv[])
{

  clone( @"");
  clone( @"VfL Bochum 1848");
  clone( [NSString stringWithUTF8String:""]);
  clone( [NSString stringWithUTF8String:"a"]);
  clone( [NSString stringWithUTF8String:"ab"]);
  clone( [NSString stringWithUTF8String:"abc"]);
  clone( [NSString stringWithUTF8String:"abcd"]);
  clone( [NSString stringWithUTF8String:"abcde"]);
  clone( [NSString stringWithUTF8String:"abcdef"]);
  clone( [NSString stringWithUTF8String:"abcdefg"]);
  clone( [NSString stringWithUTF8String:"abcdefgh"]);
  clone( [NSString stringWithUTF8String:"abcdefghi"]);
  clone( [NSString stringWithUTF8String:"abcdefghij"]);
  clone( [NSString stringWithUTF8String:"abcdefghijk"]);
  clone( [NSString stringWithUTF8String:"abcdefghijkl"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklm"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmn"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmno"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnop"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnopr"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnoprs"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnoprst"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnoprstu"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnoprstuv"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnoprstuvw"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnoprstuvwx"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnoprstuvwxy"]);
  clone( [NSString stringWithUTF8String:"abcdefghijklmnoprstuvwxyz"]);
  clone( [NSString stringWithUTF8String:hoehoe]);
  return( 0);
}
