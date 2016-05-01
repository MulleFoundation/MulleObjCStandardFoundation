//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>

int main(int argc, const char * argv[])
{
   NSMutableData       *data;
   NSData              *copy;
   NSMutableData       *clone;
   unsigned int        i;
   unsigned char       *p;

   data = [NSMutableData dataWithLength:0x400];

   p = [data mutableBytes];
   for( i = 0; i < 0x400; i++)
      *p++ = i & 0xFF;

   printf( "%ld\n", [data length]);
   [data appendData:data];
   printf( "%ld\n", [data length]);
   [data appendBytes:[data mutableBytes]
              length:0x400];
   printf( "%ld\n", [data length]);

   copy  = [[data copy] autorelease];
   clone = [NSMutableData dataWithData:copy];

   p = [clone mutableBytes];
   for( i = 0; i < 0x400 * 3; i++)
      if( *p++ != (i & 0xFF))
      {
         printf( "failed at %u with %d\n", i, p[ -1]);
         return( 1);
      }

   printf( "passed\n");

   return( 0);
}
