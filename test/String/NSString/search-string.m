//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void  _test( NSString *s, NSString *other, NSUInteger options, char *name)
{
   NSRange   range;
   NSString  *substring;

   range = [s rangeOfString:other
                    options:options];
   substring = @"";
   if( range.length)
      substring = [s substringWithRange:range];

   printf( "%s %s of %s = %s\n",
      [s UTF8String], name, [other UTF8String], [substring UTF8String]);
}


static void  test( NSString *s, NSString *other)
{
   _test( s, other, 0, "default");
   _test( s, other, NSAnchoredSearch, "NSAnchoredSearch");
   _test( s, other, NSBackwardsSearch, "NSBackwardsSearch");
   _test( s, other, NSAnchoredSearch|NSBackwardsSearch, "NSAnchoredSearch|NSBackwardsSearch");
}



int main( int argc, const char * argv[])
{
   // empty string
   test( @"AxB", @"");

   // single letters
   test( @"AxB", @"A");
   test( @"AxB", @"B");
   test( @"xAxBx", @"A");
   test( @"xAxBx", @"B");

   // multiple letters
   test( @"ABCxxx", @"ABC");
   test( @"xxxABC", @"ABC");
   test( @"xxxABCxxx", @"ABC");

   return( 0);
}
