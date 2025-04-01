//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


int main(int argc, const char * argv[])
{
   NSMutableData       *data;
   NSData              *copy;
   NSMutableData       *clone;
   unsigned int        i;
   unsigned char       *p;

   data = [NSMutableData dataWithCapacity:0x100];
   p = [data mutableBytes];
   for( i = 0; i < 0x100; i++)
      *p++ = i & 0xFF;

   printf( "%ld\n", [data length]);

   copy  = [data immutableInstance];
   clone = [NSMutableData dataWithData:copy];

   p = [clone mutableBytes];
   for( i = 0; i < 0x100; i++)
      if( *p++ != (i & 0xFF))
      {
         printf( "failed at %u with %d\n", i, p[ -1]);
         return( 1);
      }

   printf( "passed\n");

   return( 0);
}
