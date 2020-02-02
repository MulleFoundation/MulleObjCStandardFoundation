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
   NSData                 *data;
   id                     decoded;
   NSPropertyListFormat   format;

   @try
   {
      format  = MullePropertyListLooseOpenStepFormat;
      data    = [value dataUsingEncoding:NSUTF8StringEncoding];
      decoded = [NSPropertyListSerialization propertyListFromData:data
                                                 mutabilityOption:0
                                                           format:&format
                                                 errorDescription:NULL];
      printf( "%s\n",
            [[decoded description] UTF8String]);
   }
   @catch( NSException *exception)
   {
      printf( "exception: %s\n", [[exception reason] UTF8String]);
   }
}


int main(int argc, const char * argv[])
{
   code_decode( @"{ root=/; }");
   code_decode( @"/");
   code_decode( @"/i/should/be/quoted/but/pbxproj/is/dumb/");
   code_decode( @"NOT_QUOTED_THOUGH_UNDERSCORE");
   code_decode( @"{ 41F6FBAF1BC3FE99000C60B2 "
"/* PBXObject+PBXEncoding.h in Headers */ = "
"{isa = PBXBuildFile; fileRef = 412167BB12D8A57E00D49F14 "
"/* PBXObject+PBXEncoding.h */; "
"settings = {ATTRIBUTES = (Public, ); };"
"} }");
   return( 0);
}
