/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSPropertyListSerialization.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSPropertyListSerialization.h"

// other files in this library
#import "_MulleObjCPropertyListReader.h"
#import "NSObject+PropertyListParsing.h"
#import "NSData+Unicode.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies
#include <ctype.h>


@interface NSObject( Future)

- (BOOL) _propertyListIsValidForFormat:(NSPropertyListFormat) format;

@end



@implementation NSPropertyListSerialization

+ (NSData *) dataFromPropertyList:(id) plist 
                           format:(NSPropertyListFormat) format 
                 errorDescription:(NSString **) errorString;
{
   abort();
   return( 0);
}


+ (BOOL) propertyList:(id) plist 
     isValidForFormat:(NSPropertyListFormat) format
{
   if( ! [plist respondsToSelector:@selector( _propertyListIsValidForFormat:)])
      return( NO);
      
   return( [plist _propertyListIsValidForFormat:format]);
}     


// a heuristic
+ (NSPropertyListFormat) _detectPropertyListFormat:(NSData *) data
{
   char         *s;
   char         *sentinel;
   int          c;
   NSUInteger   len;
   
   s   = [data bytes];
   len = [data length];
   
   sentinel = &s[ len];
   while( s < sentinel)
   {
      c = *s++;
      if( isspace( c))
         continue;
      if( c != '<')
         return( NSPropertyListOpenStepFormat);
      break;
   }

   while( s < sentinel)
   {
      c = *s++;
      if( isspace( c))
         continue;

      switch( toupper( c))
      {
      case '0' : 
      case '1' : 
      case '2' : 
      case '3' : 
      case '4' : 
      case '5' : 
      case '6' : 
      case '7' : 
      case '8' : 
      case '9' : 
      case 'A' : 
      case 'B' : 
      case 'C' : 
      case 'D' : 
      case 'E' : 
      case 'F' : 
      case '>' : return( NSPropertyListOpenStepFormat);
      }
      break;
   }

   if( s == sentinel)
      return( NSPropertyListOpenStepFormat);
   return( NSPropertyListXMLFormat_v1_0);
}

+ (id) propertyListFromData:(NSData *) data 
           mutabilityOption:(NSPropertyListMutabilityOptions) opt 
                     format:(NSPropertyListFormat *) format 
           errorDescription:(NSString **) errorString
{
   _MulleObjCByteOrderMark             bom;
   _MulleObjCPropertyListReader        *reader;
   _MulleObjCBufferedDataInputStream   *stream;
   id                           plist;
   NSPropertyListSerialization  *parser;
   
   if( ! data)
      return( nil);
      
   bom = [data _byteOrderMark];
   switch( bom)
   {
   case _MulleObjCNoByteOrderMark   :
   case _MulleObjCUTF8ByteOrderMark :
      break;
      
   default                   :
      abort();
   }
   
   switch( [self _detectPropertyListFormat:data])
   {
   case NSPropertyListOpenStepFormat :
      stream = [[[_MulleObjCBufferedDataInputStream alloc] initWithData:data] autorelease];
      reader = [[[_MulleObjCPropertyListReader alloc] initWithBufferedInputStream:stream] autorelease];
      
      [reader setMutableContainers:opt != NSPropertyListImmutable];
      [reader setMutableLeaves:opt == NSPropertyListMutableContainersAndLeaves];
   
      plist = _MulleObjCNewFromPropertyListWithStreamReader( reader);
      NSAutoreleaseObject( plist);
      break;
   
   case NSPropertyListXMLFormat_v1_0 :
      parser  = [[NSPropertyListSerialization new] autorelease];
      plist   = [parser _parseXMLData:data];
   }
   
   return( plist);
}   
        
@end

