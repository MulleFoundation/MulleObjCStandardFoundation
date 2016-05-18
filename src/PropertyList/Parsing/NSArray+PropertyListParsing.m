//
//  NSArray+PropertyListParsing.m
//  MulleObjCEOUtil
//
//  Created by Nat! on 13.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "NSArray+PropertyListParsing.h"

// other files in this library
#import "NSObject+PropertyListParsing.h"
#import "_MulleObjCPropertyListReader+InlineAccessors.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSArray ( NSPropertyListParsing)

NSArray   *_MulleObjCNewArrayFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   NSMutableArray   *result;
   id               element;
   long             x;
   
   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader);
   if (x != '(') 
      return( _MulleObjCPropertyListReaderFail( reader, @"did not find array (expected '(')"));
    

   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '('
   x = _MulleObjCPropertyListReaderSkipWhite( reader);
   
   if( x == ')')
   { // an empty array
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip ')'
      return( [reader->nsArrayClass new]);
   }

   result = [NSMutableArray new];
   for(;;)
   {
      element = _MulleObjCNewFromPropertyListWithStreamReader( reader);
      if( ! element) 
      {
         [result release];  // NSParse already complained
         return( nil);
      }
      [result addObject:element];
      [element release]; 
      
      _MulleObjCPropertyListReaderSkipWhite( reader);
      x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader); // check 4 ')'
      if( x == ',')
      {
         _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
         _MulleObjCPropertyListReaderSkipWhite( reader);
         continue;
      }
      
      if( x == ')')
      {
         _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
         break;
      }
   
      [result release];
      return( _MulleObjCPropertyListReaderFail( reader, x < 0
                                       ? @"array was not closed (expected ')')"
                                       : @"expected ')' or ',' after array element"));
   }
   return( result);
}

@end
