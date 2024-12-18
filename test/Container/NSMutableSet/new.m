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
   NSMutableSet   *set;
   NSString       *value;
   NSString       *key;

#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      return( 1);
#endif

   // simple basic test for classcluster +new and leakage
   key   = [NSString stringWithUTF8String:"bar is quite long"];
   value = [NSMutableString stringWithUTF8String:"foo is quite long"];

   set = [NSMutableSet new];
   [set addObject:key];
   [set addObject:key];
   [set addObject:value];
   [set release];

   return( 0);
}
