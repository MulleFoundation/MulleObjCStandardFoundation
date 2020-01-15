//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


static void   code_decode( id value)
{
   NSData   *data;
   id       decoded;

   @try
   {
      data   = [NSPropertyListSerialization dataFromPropertyList:value
                                                          format:MullePropertyListJSONFormat
                                                errorDescription:NULL];
      decoded = [NSPropertyListSerialization propertyListFromData:data
                                                 mutabilityOption:0
                                                           format:NULL
                                                 errorDescription:NULL];
      printf( "%s->%s\n",
            [[value description] UTF8String],
            [[decoded description] UTF8String]);
   }
   @catch( NSException *exception)
   {
      printf( "exception: %s\n", [[exception reason] UTF8String]);
   }
}


int   main( int argc, char *argv[])
{
   code_decode( [NSNumber numberWithInt:1848]);
   code_decode( [NSNumber numberWithDouble:18.0e-48]);

   code_decode( @"");
   code_decode( @"bar");
   code_decode( @"/");
   code_decode( @"a space");

   return( 0);
}
