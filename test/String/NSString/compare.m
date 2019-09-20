//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void  print_comparison( NSComparisonResult  result)
{
   switch( result)
   {
   case NSOrderedSame       : printf( "same\n"); break;
   case NSOrderedAscending  : printf( "ascending\n"); break;
   case NSOrderedDescending : printf( "descending\n"); break;
   default                  : printf( "???\n"); break;
   }
}


int main( int argc, const char * argv[])
{
   print_comparison( [@"VfL" compare:@"VfL"]);
   print_comparison( [@"vfL" compare:@"VfL"]);
   print_comparison( [@"VfL" compare:@"vfL"]);
   print_comparison( [@"VFL" compare:@"VfL"]);

   printf( "--\n");
   print_comparison( [@"VfL" caseInsensitiveCompare:@"VfL"]);
   print_comparison( [@"vfL" caseInsensitiveCompare:@"VfL"]);
   print_comparison( [@"VfL" caseInsensitiveCompare:@"vfL"]);
   print_comparison( [@"VFL" caseInsensitiveCompare:@"VfL"]);

   print_comparison( [@"VfL" caseInsensitiveCompare:@"VfB"]);
   print_comparison( [@"VfB" caseInsensitiveCompare:@"VfL"]);

   return( 0);
}
