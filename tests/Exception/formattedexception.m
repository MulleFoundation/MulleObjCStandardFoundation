//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"



int main(int argc, const char * argv[])
{
   NSString  *fileName;
   NSString  *reason;
   long      lineNumber;

   fileName  = [[[NSString alloc] _initWithUTF8CharactersNoCopy:"commands/filter/filter-html.scion"
                                                          length:NSIntegerMax
                                                    freeWhenDone:NO] autorelease];

   reason   = [[[NSString alloc] _initWithUTF8CharactersNoCopy:"at 'h' near \"{% filter htmlEscapedString, (output) %} <html> {{ \"\\\"html>\\\" }} {% endfilter %} {% filter htmlEscapedString %} <html\", unknown keyword \"filter\" (did you mean \"filter\" ?)"
                                                          length:NSIntegerMax
                                                    freeWhenDone:NO] autorelease];
   lineNumber = 1;

   @try
   {
    [NSException raise:NSInvalidArgumentException
                format:@"%@,%lu: %@", fileName ? fileName : @"template", (long) lineNumber, reason];
   }
   @catch( NSException *localException)
   {
   }
}
