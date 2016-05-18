//
//  NSDictionary+PropertyListParsing.m
//  MulleObjCEOUtil
//
//  Created by Nat! on 13.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "NSDictionary+PropertyListParsing.h"

// other files in this library
#import "_MulleObjCPropertyListReader+InlineAccessors.h"
#import "NSObject+PropertyListParsing.h"
#import "NSString+PropertyListParsing.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSDictionary ( NSPropertyListParsing)

NSDictionary   *_MulleObjCNewDictionaryFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   NSMutableDictionary   *result;
   long                  x;
   NSString              *key;
   id                    value;
   
   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader);
   if (x != '{') 
      return( (id) _MulleObjCPropertyListReaderFail( reader, @"did not find dictionary (expected '{')"));
    

   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '{'
   x = _MulleObjCPropertyListReaderSkipWhite( reader);
   
   if( x == '}')
   { // an empty dictionary
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '}'
      return( [reader->nsDictionaryClass new]); // 
   }

   result = [NSMutableDictionary new];
   for(;;)
   {
      key = _MulleObjCNewStringFromPropertyListWithReader( reader);
      if( ! key)
      {
         [result release];  // NSParse already complained
         return( nil);
      }
      
      _MulleObjCPropertyListReaderSkipWhite( reader);
      x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader); // check 4 '='
      if( x != '=')
      {
         [key release];
         [result release];
         return( (id) _MulleObjCPropertyListReaderFail( reader, @"expected '=' after key in dictionary"));
      }
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
      _MulleObjCPropertyListReaderSkipWhite( reader);

      value = _MulleObjCNewFromPropertyListWithStreamReader( reader);
      if( ! value)
      {
         [key release];
         [result release];  // NSParse already complained
         return( nil);
      }
      
      NSCParameterAssert( ! [result objectForKey:key]);
      
      [result setObject:value
                 forKey:key];
      [value release];
      [key release];
                 
      _MulleObjCPropertyListReaderSkipWhite( reader);
      x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader); // check 4 ';}'
      if( x != ';')
      {
         [result release];
         return( (id) _MulleObjCPropertyListReaderFail( reader, @"expected ';' after value in dictionary"));
      }
      
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
      x = _MulleObjCPropertyListReaderSkipWhite( reader);
      if( x == '}')
      {
         _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);
         break;
      }

      if( x < 0)
      {
         [result release];
         return( (id) _MulleObjCPropertyListReaderFail( reader, @"dictionary was not closed (expected '}')"));
      }
   }
	
   return( result);
}

@end
