//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC_RUNTIME__
# import <MulleObjCFoundation/MulleObjCFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


static void  test( NSArray *array)
{
   NSString  *s;
   char      *c_s;

   s   = [array description];
   c_s = [s UTF8String];
   printf( "%s\n", c_s);   
}


int main(int argc, const char * argv[])
{
   NSArray  *a;

   test( @[]);
   test( @[ @"a"]);
   test( @[ @"a", @"b", @"c"]);

   return( 0);
}
