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
   if( range.location != NSNotFound)
      substring = [s substringWithRange:range];

   printf( "%s %s of %s = %s (%ld %ld)\n",
      [s UTF8String], name, [other UTF8String], [substring UTF8String],
      (long) ((range.location == NSNotFound) ? -1 : range.length),
      (long) range.length);
}


static void  test( NSString *s, NSString *other)
{
   //  Returns {NSNotFound, 0} if searchString is not found or is empty ("")
   _test( s, other, 0, "default");
   _test( s, other, NSAnchoredSearch, "NSAnchoredSearch");
   _test( s, other, NSBackwardsSearch, "NSBackwardsSearch");
   _test( s, other, NSAnchoredSearch|NSBackwardsSearch, "NSAnchoredSearch|NSBackwardsSearch");
}



int main( int argc, const char * argv[])
{
   static unichar  _UTF32Unichar[] = { 0x0001f463, 0x00000023, 'A', 'B', 'C', 0x000020ac, 0x0001f3b2 };   /* UTF32 feet, hash, euro, dice */
   NSString         *strings[ 2];

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

   // longer strings to hit different subclass
   test( @"xxxABCxxxABCxxxABCxxx", @"xxxABCxxxABCxxx");

   strings[ 0] = @"AxBy";
   strings[ 1] = @"xxxABCxxxABCxxxABCxxx";

   test( [[[NSMutableString alloc] initWithStrings:strings
                                             count:2] autorelease], @"ABC");
   test( [[[NSString alloc] initWithUTF8String:"xxx\303\266ABCxxxABCxxxABCxxx"] autorelease], @"ABC"); // utf15 with '&ouml;'
   test( [[[NSString alloc] initWithCharacters:_UTF32Unichar
                                        length:7] autorelease], @"ABC");


   return( 0);
}
