//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


static void  code_decode( id value)
{
   NSData                  *data;
   id                      decoded;
   NSPropertyListFormat    format;

   printf( "%s->",
      [[value description] UTF8String]);
   fflush( stdout);

   @try
   {
      data = [NSPropertyListSerialization dataFromPropertyList:value
                                                        format:MullePropertyListJSONFormat
                                              errorDescription:NULL];
      printf( "%.*s\n", (int) [data length], [data bytes]);
   }
   @catch( NSException *exception)
   {
      printf( "exception: %s\n", [[exception reason] UTF8String]);
   }
}



int main(int argc, const char * argv[])
{
   int   i;

   for( i = 7; i <= 13; i++)
      code_decode( @{ [NSNumber numberWithDouble:(double) i / 10]: [NSString stringWithFormat:@"%c", i] });
   for( i = 27; i <= 27; i++)
      code_decode( @{ [NSNumber numberWithDouble:(double) i / 10]: [NSString stringWithFormat:@"%c", i] });
   for( i = 32; i <= 126; i++)
      code_decode( @{ [NSNumber numberWithDouble:(double) i / 10]: [NSString stringWithFormat:@"%c", i] });
   return( 0);
}
