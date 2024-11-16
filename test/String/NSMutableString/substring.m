//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


   static unichar  _UTF32Unichar[] = { 0x0001f463, 0x00000023, 'A', 'B', 'C', 0x000020ac, 0x0001f3b2 };   /* UTF32 feet, hash, euro, dice */

int main(int argc, const char * argv[])
{
   NSMutableString   *s;
   NSString          *other;
   NSMutableString   *clone;
   NSCharacterSet    *charSet;
   NSString          *strings[ 2];
   NSUInteger        i;

   s = [NSMutableString string];

   [s appendString:@"VfL"];
   [s appendString:@" "];
   [s appendString:@"Bochum"];
   [s appendString:@" "];
   [s appendString:@"1848"];
   [s appendString:@" "];
   [s appendString:[[[NSString alloc] initWithUTF8String:"m\303\266hp"] autorelease]];
   [s appendString:@" "];
   [s appendString:[[[NSString alloc] initWithCharacters:_UTF32Unichar
                                                  length:7] autorelease]];
   other = [s substringWithRange:NSRangeMake( 2, 10)];
   printf( "%s\n", [other UTF8String]);

   other = [s substringWithRange:NSRangeMake( 0, 0)];
   printf( "%s\n", [other UTF8String]);

   for( i = [s length] / 2; i; i--)
   {
      if( i * 2 <= [s length])
      {
         other = [s substringWithRange:NSRangeMake( i, [s length] - i * 2)];
         printf( "%s\n", [other UTF8String]);
      }
   }
   return( 0);
}
