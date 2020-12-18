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
   NSString               *errorString;
   NSString               *description;

   @try
   {
      format  = MullePropertyListLooseOpenStepFormat;
      data    = [value dataUsingEncoding:NSUTF8StringEncoding];
      decoded = [NSPropertyListSerialization mullePropertyListFromData:data
                                                      mutabilityOption:0
                                                                format:&format
                                                          formatOption:MullePropertyListFormatOptionPrefer];
      if( decoded)
      {
         description = [decoded description];
         printf( "%s\n", [description UTF8String]);
      }
      else
         printf( "Error: %s\n",
                  [[[NSError mulleExtract] description] UTF8String]);

   }
   @catch( NSException *exception)
   {
      printf( "exception: %s\n", [[exception reason] UTF8String]);
   }
}


int main(int argc, const char * argv[])
{
#if 1
   code_decode( @"{ root=/; }");
   code_decode( @"/");
   code_decode( @"/i/should/be/quoted/but/pbxproj/is/dumb/");
   code_decode( @"NOT_QUOTED_THOUGH_UNDERSCORE");
#endif

#if 0
//   code_decode( @"{ settings = {ATTRIBUTES = (Public,); }; };");
//   code_decode( @"ATTRIBUTES = (Public, );");
   code_decode( @""
"{\n"
"   41F6FBAF1BC3FE99000C60B2 =\n"
"   {\n"
"      isa = PBXBuildFile;\n"
"      fileRef = 412167BB12D8A57E00D49F14;\n"
"      settings =\n"
"      {\n"
"         ATTRIBUTES = (Public, );\n"
"      };\n"
"   };\n"
"};\n"
);
#endif

#if 1
   code_decode( @"{ 41F6FBAF1BC3FE99000C60B2 "
"/* PBXObject+PBXEncoding.h in Headers */ = "
"{isa = PBXBuildFile; fileRef = 412167BB12D8A57E00D49F14 "
"/* PBXObject+PBXEncoding.h */; "
"settings = {ATTRIBUTES = (Public, ); };"
"} }");
#endif
   return( 0);
}
