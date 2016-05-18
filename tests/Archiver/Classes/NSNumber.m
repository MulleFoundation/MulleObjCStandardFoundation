//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>

#include <limits.h>
#include <float.h>


static void    clone_bool( BOOL value)
{
   NSData   *data;
   id       copy;
   id       obj;


   obj  = [NSNumber numberWithBool:value];
   data = [NSArchiver archivedDataWithRootObject:obj];
   copy = [NSUnarchiver unarchiveObjectWithData:data];
   if( [obj isEqual:copy])
      printf( "passed\n");
   else
      printf( "failed: %s != %s\n",
          [[obj description] UTF8String],
          [[copy description] UTF8String]);
}


static void    clone_integer( NSInteger value)
{
   NSData   *data;
   id       copy;
   id       obj;


   obj  = [NSNumber numberWithInteger:value];
   data = [NSArchiver archivedDataWithRootObject:obj];
   copy = [NSUnarchiver unarchiveObjectWithData:data];
   if( [obj isEqual:copy])
      printf( "passed\n");
   else
      printf( "failed: %s != %s\n",
          [[obj description] UTF8String],
          [[copy description] UTF8String]);
}


static void    clone_unsigned_integer( NSUInteger value)
{
   NSData   *data;
   id       copy;
   id       obj;


   obj  = [NSNumber numberWithUnsignedInteger:value];
   data = [NSArchiver archivedDataWithRootObject:obj];
   copy = [NSUnarchiver unarchiveObjectWithData:data];
   if( [obj isEqual:copy])
      printf( "passed\n");
   else
      printf( "failed: %s != %s\n",
          [[obj description] UTF8String],
          [[copy description] UTF8String]);
}


static void    clone_double( double value)
{
   NSData   *data;
   id       copy;
   id       obj;

   obj  = [NSNumber numberWithDouble:value];
   data = [NSArchiver archivedDataWithRootObject:obj];
   copy = [NSUnarchiver unarchiveObjectWithData:data];
   if( [obj isEqual:copy])
      printf( "passed\n");
   else
      printf( "failed: %s != %s\n",
          [[obj description] UTF8String],
          [[copy description] UTF8String]);
}



int main(int argc, const char * argv[])
{
  clone_bool( YES);
  clone_bool( NO);

  clone_unsigned_integer( 0);
  clone_unsigned_integer( ~0LL);
  clone_unsigned_integer( (NSUInteger) NSIntegerMin);
  clone_unsigned_integer( (NSUInteger) NSIntegerMax);

  clone_integer( 0);
  clone_integer( ~0LL);
  clone_integer( NSIntegerMin);
  clone_integer( NSIntegerMax);


  clone_double( 0);
  clone_double( DBL_MIN);
  clone_integer( DBL_MAX);

  return( 0);
}
