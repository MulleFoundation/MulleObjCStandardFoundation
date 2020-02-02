//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#ifdef __MULLE_OBJC__
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


static void  parse_strings( NSDictionary *dict, BOOL expect)
{
   NSString       *s;
   NSData         *data;
   NSDictionary   *check;
   NSPropertyListFormat   format;

   s    = [dict descriptionInStringsFileFormat];
   data = [s dataUsingEncoding:NSUTF16StringEncoding];

   format = NSPropertyListOpenStepFormat;
   check  = [NSPropertyListSerialization propertyListWithData:data
                                                      options:0
                                                       format:&format
                                                        error:NULL];

   printf( "%s\n", [dict isEqual:check] == expect ? "PASS" : "FAIL");
   if( [dict isEqual:check] != expect)
   {
      fprintf( stderr, "i: %s\n", dict ?  [[dict description] UTF8String] : "nil");
      fprintf( stderr, "o: %s\n", check ? [[check description] UTF8String] : "nil");
      fprintf( stderr, "d: %s\n", data ?  [[data description] UTF8String] : "nil");
   }
}


int main( int argc, const char * argv[])
{
   parse_strings( @{ @"a": @"A",  @"b": @"B" }, YES);
   parse_strings( @{}, NO);  // will create empty string, so will produce nil
   parse_strings( @{ @"a.lf.b": @"A\nB" }, YES);
   parse_strings( @{ @"b": @12 }, NO);   // Apple can print this, but parses as string
   parse_strings( @{ @"b": @[] }, YES);  // Apple prints this as ()

   return( 0);
}
