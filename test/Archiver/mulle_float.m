//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#import <MulleObjCStandardFoundation/mulle-buffer-archiver.h>

#include <limits.h>
#include <float.h>


static void   test_float( float value)
{
   struct mulle_buffer   buffer;
   float                 read;

   mulle_buffer_init( &buffer, NULL);
   mulle_buffer_add_float( &buffer, value);
   mulle_buffer_set_seek( &buffer, 0, SEEK_SET);
   read = mulle_buffer_next_float( &buffer);
   if( read == value)
      printf( "passed\n");
  else
      printf( "failed: %f vs. %f\n", value, read);

   mulle_buffer_done( &buffer);
}


static void   test_double( double value)
{
   struct mulle_buffer   buffer;
   double                read;

   mulle_buffer_init( &buffer, NULL);
   mulle_buffer_add_double( &buffer, value);
   mulle_buffer_set_seek( &buffer, 0, SEEK_SET);
   read = mulle_buffer_next_double( &buffer);
   if( read == value)
      printf( "passed\n");
  else
      printf( "failed: %f vs. %f\n", value, read);

   mulle_buffer_done( &buffer);
}



int   main( int argc, const char * argv[])
{
  test_float( 0);
  test_double( 0);

  test_float( (float) ~0LL);
  test_double( (double)  ~0LL);

  test_float((float) FLT_MIN);
  test_double((double) FLT_MIN);

  test_float((float) FLT_MAX);
  test_double((double) FLT_MAX);

  test_float((float) DBL_MIN);
  test_double((double) DBL_MIN);

  test_float((float) DBL_MAX);
  test_double((double) DBL_MAX);

  return( 0);
}
