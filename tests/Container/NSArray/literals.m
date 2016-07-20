//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjCFoundation/MulleObjCFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


static void  test_count( NSArray *array, NSUInteger count)
{
   if( ! [array isKindOfClass:[NSArray class]] || [array count] != count)
      printf( "Failed\n");
}


int main(int argc, const char * argv[])
{
   NSArray  *a;

   test_count( @[], 0);
   test_count( @[ @"a"], 1);
   test_count( @[ @"a", @"b", @"c"], 3);

   return( 0);
}
