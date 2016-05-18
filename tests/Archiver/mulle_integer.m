//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>
#import <MulleObjCFoundation/mulle_buffer_archiver.h>

#include <limits.h>


static void   test_uinteger( uint64_t value)
{
   struct mulle_buffer   buffer;
   uint64_t              read;

   mulle_buffer_init( &buffer, NULL);
   mulle_buffer_add_integer( &buffer, value);
   mulle_buffer_set_seek( &buffer, 0, SEEK_SET);
   read = mulle_buffer_next_integer( &buffer);
   if( read == value)
      printf( "passed\n");
  else
      printf( "failed: %llu vs. %llu\n", value, read);

   mulle_buffer_done( &buffer);
}


static void   test_integer( int64_t value)
{
   struct mulle_buffer   buffer;
   int64_t               read;

   mulle_buffer_init( &buffer, NULL);
   mulle_buffer_add_integer( &buffer, (uint64_t) value);
   mulle_buffer_set_seek( &buffer, 0, SEEK_SET);
   read = (int64_t) mulle_buffer_next_integer( &buffer);
   if( read == value)
      printf( "passed\n");
  else
      printf( "failed: %lld vs. %lld\n", value, read);

   mulle_buffer_done( &buffer);
}



int   main( int argc, const char * argv[])
{
  test_integer( 0);
  test_uinteger( 0);

  test_integer( ~0LL);
  test_uinteger( ~0LL);

  test_integer((int64_t) LONG_MAX);
  test_uinteger((uint64_t) LONG_MAX);

  test_integer((int64_t) LONG_MIN);
  test_uinteger((uint64_t) LONG_MIN);

  test_integer((int64_t) LONG_LONG_MIN);
  test_uinteger((uint64_t) LONG_LONG_MIN);

  test_integer((int64_t) LONG_LONG_MAX);
  test_uinteger((uint64_t) LONG_LONG_MAX);

  return( 0);
}
