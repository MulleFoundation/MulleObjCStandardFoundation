//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>


static void    test_dictionary( int n)
{
   NSData         *data;
   id             *objects[ n];
   unsigned int   i;

   for( i = 0; i < n; ++i)
      objects[ i] = [NSNumber numberWithInt:i];

   [NSDictionary dictionaryWithObjects:objects
                               forKeys:objects
                                 count:n];
}


// just fishing for leaks

int main(int argc, const char * argv[])
{
   test_dictionary( 0);
   test_dictionary( 1);
   test_dictionary( 2);

   return( 0);
}
