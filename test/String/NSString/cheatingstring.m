//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#import <MulleObjCValueFoundation/_MulleObjCASCIIString.h>
#import <MulleObjCValueFoundation/_MulleObjCCheatingASCIIString.h>
//#import "MulleStandaloneObjCFoundation.h"



int main( int argc, const char * argv[])
{
   struct _MulleObjCCheatingASCIIStringStorage   storage;
   char  *string = "description";
   NSString   *s;

   s = _MulleObjCCheatingASCIIStringStorageInit( &storage, string, strlen( string));
   printf( "%s\n", [s UTF8String]);

   return( 0);
}
