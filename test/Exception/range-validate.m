//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif

//#import "MulleStandaloneObjCFoundation.h"


static void   test( NSRange range, NSUInteger length)
{
   printf( "{ %ld %ld } : %ld = ", (long) range.location, (long) range.length, (long) length);
   @try
   {
      range = MulleObjCValidateRangeAgainstLength( range, length);
      printf( "{ %ld, %ld } OK\n", (long) range.location, (long) range.length);
   }
   @catch( NSException *exception)
   {
      printf( "{ %ld, %ld } FAIL\n", (long) range.location, (long) range.length);
   }
}


int   main( int argc, char *argv[])
{
   long  i, j, k;

   for( k = -2 ; k <= 2; k++)
      for( j = -2 ; j <= 2; j++)
         for( i = -2 ; i <= 2; i++)
            test( NSRangeMake( i, j), k);

   return( 0);
}
