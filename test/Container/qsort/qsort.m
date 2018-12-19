//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/mulle-qsort-pointers.h>


static int  cmp( void *a, void *b, void *userinfo)
{
   if( userinfo != (void *) 1848)
   {
      printf( "fail\n");
      return( 0);
   }
   if( a >= b)
      return( a != b);
   return( -1);
}


static void  test( void **array, size_t n)
{
   unsigned int  i;

   mulle_qsort_pointers( array, n, cmp, (void *) 1848);
   printf( "[");
   for( i = 0; i < n; i++)
      printf( " %p", array[ i]);
   printf( "]\n");
}


int   main(int argc, const char * argv[])
{
   void   *empty[ 1];
   void   *one[]       = { 1 };
   void   *two_21[]    = { 2, 1 };
   void   *two_12[]    = { 1, 2 };
   void   *three_123[] = { 1, 2, 3 };
   void   *three_132[] = { 1, 3, 2 };
   void   *three_213[] = { 2, 1, 3 };
   void   *three_231[] = { 2, 3, 1 };
   void   *three_312[] = { 3, 1, 2 };
   void   *three_321[] = { 3, 2, 1 };
   void   *three_331[] = { 3, 3, 1 };
   void   *three_313[] = { 3, 1, 3 };
   void   *three_133[] = { 1, 3, 3 };
   void   *sixteen[]   = { 15, 1, 11, 12,  8, 7, 14, 9,  2, 13, 6, 5,  3, 10, 16, 4 };
   void   *seventeen[] = { 15, 1, 13, 12,  13, 7, 13, 9,  13, 13, 13, 5,  13, 10, 13, 4 };


   test( NULL, 0);
   test( empty, 0);

   test( one, 1);

   test( two_21, 2);
   test( two_21, 2);

   test( three_123, 3);
   test( three_132, 3);
   test( three_213, 3);
   test( three_231, 3);
   test( three_312, 3);
   test( three_321, 3);
   test( three_313, 3);
   test( three_133, 3);

   test( sixteen, 16);
   test( seventeen, 16);

   return( 0);
}
