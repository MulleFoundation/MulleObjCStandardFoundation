//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void   test( NSString *a, NSString *b)
{
   BOOL   flag1;
   BOOL   flag2;
   char   *state;

   flag1 = [a isEqual:b];
   flag2 = [[NSMutableString stringWithString:a] isEqual:b];
   if( flag1 != flag2)
      state = "failed";
   else
      state = flag1 ? "==" : "!=";

   printf( "\"%s\" %s \"%s\"\n", [a UTF8String], state, [b UTF8String]);
}


//
// try to create all possible subclasses and isEqual them. this merely
// exercises some code and finds missing implementations
//
int main( int argc, const char * argv[])
{
   // lengths preferably be same (except tps7) so isEqual can't preempt on length
   static unichar  _tps5[]    = { 'n', 'o', 'p', 'n', 'o', 'p', 'n', 'o', 'p',  0 };           /* Ascii non-TPS */
   static unichar  _tps7[]    = { '%', '/', '&', 0 };           /* Ascii non-TPS */
   static unichar  _ascii7[]  = { 'a', 'b', 'c', 'd', 'e', 'f', '%', '/', '&', 0 }; /* Ascii non-TPS */
   static unichar  _ascii15[] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', '%', '/', '&', 0 }; /* Ascii non-TPS */
   static unichar  _UTF16Unichar[] =  { 'h', 0xf6, 'h', 0xf6, 'h', 0xf6, '!', ':', ')', 0};   /* UTF8 umlaut */
   static unichar  _UTF32Unichar1[] = { 0x0001f463, 0x00000023, 0x000020ac, 0x0001f3b2,'!', '!', '!', '!', '!',  0};   /* UTF32 feet, hash, euro, dice */
   static unichar  _UTF32Unichar2[] = { 0x0001f463, 0x00000023, 0x000020ac, 0x0001f3b2, '#', '+' ,'!', '!', '+', '!', '#',  0};   /* UTF32 feet, hash, euro, dice */
   static unichar  _UTF32Unichar3[] = { 0x000020ac, 0x00000023, 0x0001f463, 0};   /* UTF32 feet, hash, euro, dice */
   unichar * strings[] =
   {
      _tps5,
      _tps7,
      _ascii7,
      _ascii15,
      _UTF16Unichar,
      _UTF32Unichar1,
      _UTF32Unichar2,
      _UTF32Unichar3
   };
   NSUInteger    i;
   NSUInteger    j;
   NSUInteger    length;
   NSString      *s1;
   NSString      *s2;

   for( i = 0; i < sizeof( strings) / sizeof( strings[ 0]); i++)
   {
      length = mulle_unichar_strlen( strings[ i]);
      s1     = [[[NSString alloc] initWithCharacters:strings[ i]
                                              length:length] autorelease];

      fprintf( stderr, "* %s (%ld,%ld)\n",
                        [[s1 debugDescription] UTF8String],
                        [s1 length],
                        [s1 mulleUTF8StringLength]);

      for( j = 0; j < sizeof( strings) / sizeof( strings[ 0]); j++)
      {
         length = mulle_unichar_strlen( strings[ j]);
         s2     = [[[NSString alloc] initWithCharacters:strings[ j]
                                                 length:length] autorelease];

         test( s1, s2);
      }
   }
   return( 0);
}
