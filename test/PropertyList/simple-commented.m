//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


static void  decode( NSString *s)
{
   NSData        *data;
   id            decoded;
   NSPropertyListFormat   format;

   @try
   {
      format  = MullePropertyListLooseOpenStepFormat;
      data    = [s dataUsingEncoding:NSUTF8StringEncoding];
      decoded = [NSPropertyListSerialization propertyListFromData:data
                                                 mutabilityOption:0
                                                           format:&format
                                                 errorDescription:NULL];

      printf( "%s->%s\n\n",
                 [[s description] UTF8String],
                 [[decoded description] UTF8String]);
   }
   @catch( NSException *exception)
   {
      printf( "exception: %s\n", [[exception reason] UTF8String]);
   }
}


int main(int argc, const char * argv[])
{
   decode( @"1848// nothing");
   decode( @"1848/* nothing */");
   decode( @"// nothing\n1848");
   decode( @"/* nothing */1848");

   decode( @"/");
   decode( @"///");
   return( 0);
}
