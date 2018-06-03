//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


static void    clone_array( int n)
{
   NSData         *data;
   id             copy;
   id             obj;
   id             *objects[ n];
   unsigned int   i;

   for( i = 0; i < n; ++i)
      objects[ i] = [NSNumber numberWithInt:i];

   obj = [NSMutableArray arrayWithObjects:objects
                                    count:n];

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
  clone_array( 0);
  clone_array( 1);
  clone_array( 2);

  return( 0);
}
