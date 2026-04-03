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


int main(int argc, const char * argv[])
{
   mulle_printf( "%s\n", [[@{} description] UTF8String]);
   mulle_printf( "%s\n", [[@{ @"a" : @"b" } description] UTF8String]);
   mulle_printf( "%s\n", [[@{ @"a" : @"b", @"c" : @"d"} description] UTF8String]);

   return( 0);
}
