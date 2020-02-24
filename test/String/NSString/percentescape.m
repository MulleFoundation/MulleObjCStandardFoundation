//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void    test( NSString *s, NSCharacterSet *set)
{
   NSString   *escaped;
   NSString   *unescaped;

   escaped   = [s stringByAddingPercentEncodingWithAllowedCharacters:set];
   unescaped = [escaped stringByRemovingPercentEncoding];
   printf( "%s -> %s -> %s",
            s ? [s UTF8String] : "*nil*",
            escaped ? [escaped UTF8String] : "*nil*",
            unescaped ? [unescaped UTF8String] : "*nil*");

   if( s && ! [s isEqualToString:unescaped])
      printf( " FAIL");
   printf( "\n");
}


static void    torture( NSString *s, NSCharacterSet *set)
{
   NSString   *unescaped;

   unescaped = [s stringByRemovingPercentEncoding];
   printf( "%s -> %s\n",
            s ? [s UTF8String] : "*nil*",
            unescaped ? [unescaped UTF8String] : "*nil*");
}


int main( int argc, const char * argv[])
{
   NSCharacterSet   *set;

   set = [NSCharacterSet characterSetWithCharactersInString:@"a"];

   printf( "Nil CharacterSet:\n");
   test( nil, nil);
   test( @"", nil);
   test( @"a", nil);
   test( @"b", nil);
   test( @"abba", nil);

   printf( "\nValid CharacterSet:\n");
   test( nil, set);
   test( @"", set);
   test( @"a", set);
   test( @"b", set);
   test( @"abba", set);

   printf( "\nDecode broken stuff:\n");
   torture( @"%6", set);
   torture( @"%00", set);
   torture( @"%F0%A4%AD%A2", set);
   torture( @"%F0 ", set);

   return( 0);
}
