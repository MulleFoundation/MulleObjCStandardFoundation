//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void  _test( NSString *s, NSCharacterSet *set, NSUInteger options, char *name)
{
   NSRange   range;
   NSString  *substring;

   range = [s rangeOfCharacterFromSet:set
                              options:options];
   substring = @"";
   if( range.length)
      substring = [s substringWithRange:range];

   printf( "%s %s = %s\n", [s UTF8String], name, [substring UTF8String]);
}


static void  test( NSString *s, NSCharacterSet *set)
{
   _test( s, set, 0, "default");
   _test( s, set, NSAnchoredSearch, "NSAnchoredSearch");
   _test( s, set, NSBackwardsSearch, "NSBackwardsSearch");
   _test( s, set, NSAnchoredSearch|NSBackwardsSearch, "NSAnchoredSearch|NSBackwardsSearch");
}



int main( int argc, const char * argv[])
{
   static unichar  _UTF32Unichar[] = { 0x0001f463, 0x00000023, 'A', 'B', 'C', 0x000020ac, 0x0001f3b2 };   /* UTF32 feet, hash, euro, dice */
   NSCharacterSet   *charSet;
   NSString         *strings[ 2];

   charSet = [NSCharacterSet characterSetWithCharactersInString:@"ABC"];

   test( @"AxB", charSet);
   test( @"xAxB", charSet);
   test( @"AxBy", charSet);
   test( @"xAxBx", charSet);
   test( @"xxxABCxxxABCxxxABCxxx", charSet); // longish ascii

   strings[ 0] = @"AxBy";
   strings[ 1] = @"xxxABCxxxABCxxxABCxxx";

   test( [[[NSMutableString alloc] initWithStrings:strings
                                             count:2] autorelease], charSet);
   test( [[[NSString alloc] initWithUTF8String:"xxx\303\266ABCxxxABCxxxABCxxx"] autorelease], charSet); // utf15 with '&ouml;'
   test( [[[NSString alloc] initWithCharacters:_UTF32Unichar
                                        length:7] autorelease], charSet);

   return( 0);
}
