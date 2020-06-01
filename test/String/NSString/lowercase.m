//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void   test( NSString *a)
{
   NSString   *b;
   NSString   *c;
   NSString   *d;
   NSString   *e;

   b = [a lowercaseString];
   c = [a uppercaseString];
   d = [a capitalizedString];
   e = [a mulleDecapitalizedString];

   printf( "\"%s\" -> \"%s\" -> \"%s\" -> \"%s\"-> \"%s\"\n",
         [a UTF8String], [b UTF8String], [c UTF8String], [d UTF8String], [e UTF8String]);
}


//
// try to create all possible subclasses and isEqual them. this merely
// exercises some code and finds missing implementations
//
int main( int argc, const char * argv[])
{
   static unichar  _tps5[]         = { 'n', 'o', 'p', 'n', 'o', 'p', 'n', 'o', 'p',  0 };          /* Ascii non-TPS */
   static unichar  _tps7[]         = { '%', '/', '&', 0 };                                         /* Ascii non-TPS */
   static unichar  _ascii7[]       = { 'a', 'b', 'c', 'D', '%', '/', '&', 0 };                     /* Ascii non-TPS */
   static unichar  _ascii15[]      = { 'a', 'B', 'c', 'd', 'e', 'f', 'g', 'h', '%', '/', '&', 0 }; /* Ascii non-TPS */
   static unichar  _UTF16Unichar[] = { 'h', 0xf6, 'h', 0xf6, 'h', 0xf6, 0};                        /* UTF8 umlaut */
   static unichar  _UTF32Unichar[] = { 0x0001f463, 0x00000023,0x000020ac, 0x0001f3b2, 0};          /* UTF32 feet, hash, euro, dice */
   unichar * strings[] =
   {
      _tps5,
      _tps7,
      _ascii7,
      _ascii15,
      _UTF16Unichar,
      _UTF32Unichar
   };
   NSUInteger    i;
   NSUInteger    length;
   NSString      *s1;

   for( i = 0; i < sizeof( strings) / sizeof( strings[ 0]); i++)
   {
      length = mulle_unichar_strlen( strings[ i]);
      s1     = [[[NSString alloc] initWithCharacters:strings[ i]
                                              length:length] autorelease];

      fprintf( stderr, "* %s\n", [[s1 debugDescription] UTF8String]);

      test( s1);
   }
   return( 0);
}
