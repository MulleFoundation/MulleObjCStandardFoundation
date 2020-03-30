//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


int   main(int argc, const char * argv[])
{
   NSDictionary   *dict;

   dict = [NSDictionary new];
   [dict objectForKey:@"foo"];
   [dict release];

   return( 0);
}
