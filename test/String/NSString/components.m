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



static void  test( NSString *s, NSString *seperator)
{
   NSArray    *array;
   NSString   *component;

   array = [s componentsSeparatedByString:seperator];
   printf( "\"%s\" seperated by \"%s\":",
            [s UTF8String],
            [seperator UTF8String]);

   for( component in array)
      printf( " \"%s\"", [component UTF8String]);
   printf( "\n");
}

int main( int argc, const char * argv[])
{
   test( @"", @"");

NS_DURING
   test( @"0,1,2,3", nil);
NS_HANDLER
   printf( "%s\n", [[localException name] UTF8String]);
NS_ENDHANDLER

   test( @"0,1,2,3", @",");
   test( @"0,1,2,3", @",,");
   test( @"0,1,,2,,,,3,,,,4", @",");
   test( @"0,1,,2,,,,3,,,,4", @",,");

   test( @",", @",");
   test( @"0,", @",");
   test( @"0,,", @",");
   test( @",0", @",");
   test( @",,0", @",");
   test( @",,0,,", @",");
   test( @",,0,0,,", @",");

   return( 0);
}
