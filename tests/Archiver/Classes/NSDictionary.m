//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>


static void    clone_dictionary( int n)
{
   NSData         *data;
   id             copy;
   id             obj;
   id             *objects[ n];
   unsigned int   i;

   for( i = 0; i < n; ++i)
      objects[ i] = [NSNumber numberWithInt:i];


   obj = [NSDictionary dictionaryWithObjects:objects
                                     forKeys:objects
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
//  clone_dictionary( 0);
  clone_dictionary( 1);
//  clone_dictionary( 2);

  return( 0);
}
