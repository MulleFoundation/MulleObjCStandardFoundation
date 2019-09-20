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
   NSCharacterSet   *charSet;

   charSet = [NSCharacterSet characterSetWithCharactersInString:@"ABC"];

   test( @"AxB", charSet);
   test( @"xAxB", charSet);
   test( @"AxBy", charSet);
   test( @"xAxBx", charSet);

   return( 0);
}
