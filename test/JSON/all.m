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
      data = [NSPropertyListSerialization dataFromPropertyList:value
                                                        format:MullePropertyListJSONFormat
                                              errorDescription:NULL];
      printf( "%s->%.*s\n",
            [[value description] UTF8String],
            (int) [data length], [data bytes]);
   }
   @catch( NSException *exception)
   {
      printf( "exception: %s\n", [[exception reason] UTF8String]);
   }
}


int   main( int argc, char *argv[])
{
   code_decode( @[ @{ @"a": [NSNumber numberWithBool:YES], @"b": [NSNumber numberWithBool:NO], @"c": @{ @"e":@[ @"f", @1848], @"h": [NSNull null]}}]);

   return( 0);
}
