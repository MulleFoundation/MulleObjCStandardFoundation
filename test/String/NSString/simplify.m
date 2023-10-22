//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


static void  test( NSString *s)
{
   NSString   *simplified;

   simplified = [s mulleStringBySimplifyingComponentsSeparatedByString:@"/"
                                                          simplifyDots:YES];
   printf( "\"%s\" simplifies to \"%s\"\n",
            [s UTF8String],
            [simplified UTF8String]);
}

int main( int argc, const char * argv[])
{
   test( @"");

   // single char
   test( @"/");
   test( @".");
   test( @"..");
   test( @"a");

   // / prefix
   test( @"//");
   test( @"/.");
   test( @"/..");
   test( @"/a");

   // suffix
   test( @"./");
   test( @"../");
   test( @"a/");

   // infix
   test( @"///");
   test( @"/./");
   test( @"/../");
   test( @"/a/");

   // combinations
   test( @"/a/.");
   test( @"/./a");
   test( @"/a/./");
   test( @"/./a/");

   test( @"a/.");
   test( @"./a");
   test( @"a/./");
   test( @"./a/");

   test( @"/a/..");
   test( @"/../a");
   test( @"/a/../");
   test( @"/../a/");

   test( @"a/..");
   test( @"../a");
   test( @"a/../");
   test( @"../a/");

   test( @"a/../b");
   test( @"a/./b");
   test( @"a/../b/");
   test( @"a/./b/");
   test( @"/a/../b");
   test( @"/a/./b");
   test( @"/a/../b/");
   test( @"/a/./b/");

   test( @"/Volumes/Source/srcO/MulleFoundation/MulleObjCOSFoundation/test/NSBundle");

   test( @"../..");
   test( @"a/../..");
   test( @"/a/../..");

   return( 0);
}
