//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>


static void   avg_test( NSArray *array, NSString  *keypath, long long  expect)
{
   NSNumber   *result;

   result = [array valueForKeyPath:keypath];
   if( [result longLongValue] != expect)
      printf( "failed\n");
   else
      printf( "passed\n");
}


int  main( int argc, const char * argv[])
{
   avg_test( @[], @"@count", 0);
   avg_test( @[ [NSNumber numberWithInt:1848]], @"@count", 1);
   avg_test( @[ [NSNumber numberWithInt:1846], [NSNumber numberWithInt:1850]], @"@count", 2);

   avg_test( @[], @"@avg", 0);
   avg_test( @[ [NSNumber numberWithInt:1848]], @"@avg", 1848);
   avg_test( @[ [NSNumber numberWithInt:1846], [NSNumber numberWithInt:1850]], @"@avg", 1848);

   avg_test( @[], @"@sum", 0);
   avg_test( @[ [NSNumber numberWithInt:1848]], @"@sum", 1848);
   avg_test( @[ [NSNumber numberWithInt:1846], [NSNumber numberWithInt:1850]], @"@sum", 3696);

   avg_test( @[], @"@min", 0);
   avg_test( @[ [NSNumber numberWithInt:1848]], @"@min", 1848);
   avg_test( @[ [NSNumber numberWithInt:1846], [NSNumber numberWithInt:1850]], @"@min", 1846);

   avg_test( @[], @"@max", 0);
   avg_test( @[ [NSNumber numberWithInt:1848]], @"@max", 1848);
   avg_test( @[ [NSNumber numberWithInt:1846], [NSNumber numberWithInt:1850]], @"@max", 1850);

   return( 0);
}
