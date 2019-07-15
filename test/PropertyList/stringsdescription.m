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


static void  print_strings( NSDictionary *strings)
{
   NSString   *s;

   s = [strings descriptionInStringsFileFormat];
   printf( ">%s<\n", s ? [s UTF8String] : "nil");
}


int main(int argc, const char * argv[])
{
   print_strings( @{ @"a": @"A",  @"b": @"B" });
   print_strings( @{});
   print_strings( @{ @"a.lf.b": @"A\nB" });
   print_strings( @{ @"b": @12 });  // Apple can print this, but unquoted
   print_strings( @{ @"b": @[] });  // Apple prints this has () 
   return( 0);
}
