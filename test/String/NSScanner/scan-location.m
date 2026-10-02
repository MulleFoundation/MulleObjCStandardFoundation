//
//  scan-location.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2026 Nat! - Mulle kybernetiK. All rights reserved.
//
//  -scanLocation has to be the cursor the scan methods move. Reading it must
//  report where the scanner is, and setting it - the documented way to backtrack
//  - must move the scanner. While the property had an ivar of its own it did
//  neither: it stayed 0 and the setter was ignored, which nobody noticed because
//  the scan methods themselves were correct.
//

#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>

#include <stdio.h>


static void   show( char *label, NSScanner *scanner)
{
   mulle_printf( "%-12s loc=%lu rest=[%s] atEnd=%s\n",
                 label,
                 (unsigned long) [scanner scanLocation],
                 [[scanner mulleUnscannedString] UTF8String],
                 [scanner isAtEnd] ? "yes" : "no");
}


int   main( void)
{
   NSScanner   *scanner;
   NSScanner   *copy;

   scanner = [NSScanner scannerWithString:@"abcd"];
   [scanner setCharactersToBeSkipped:nil];
   show( "initial", scanner);

   mulle_printf( "scan \"ab\": %s\n",
                 [scanner scanString:@"ab"
                           intoString:NULL] ? "yes" : "no");
   show( "after ab", scanner);

   //
   // the rewind has to reach the scanner, so "cd" is not where it is any more
   //
   [scanner setScanLocation:0];
   show( "rewound", scanner);
   mulle_printf( "scan \"cd\": %s\n",
                 [scanner scanString:@"cd"
                           intoString:NULL] ? "yes" : "no");
   show( "still 0", scanner);

   mulle_printf( "scan \"ab\": %s\n",
                 [scanner scanString:@"ab"
                           intoString:NULL] ? "yes" : "no");
   show( "after ab", scanner);

   //
   // a copy carries the position with it
   //
   copy = [scanner copy];
   show( "copy", copy);
   mulle_printf( "scan \"cd\": %s\n",
                 [copy scanString:@"cd"
                       intoString:NULL] ? "yes" : "no");
   show( "in copy", copy);
   [copy release];

   //
   // the end of the text is the length of it
   //
   [scanner setScanLocation:4];
   show( "at end", scanner);

   return( 0);
}
