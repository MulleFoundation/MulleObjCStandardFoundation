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
   NSString       *key2;
   NSString       *key1;
   NSString       *prev;

#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      return( 1);
#endif

   key1 = [NSString stringWithUTF8String:"bar is quite long"];
   key2 = [NSMutableString stringWithUTF8String:"bar is quite long"];

   set  = [NSMutableSet new];
   prev = [set mulleRegisterObject:key2];
   if( prev != key2)
      return( 1);
   prev = [set mulleRegisterObject:key1];
   if( prev != key2)
      return( 2);

   [set release];

   return( 0);
}
