//
//  NSData+PropertyListParsing.m
//  MulleObjCEOUtil
//
//  Created by Nat! on 12.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "NSData+PropertyListParsing.h"

// other files in this library
#import "NSObject+PropertyListParsing.h"
#import "_MulleObjCPropertyListReader.h"
#import "_MulleObjCPropertyListReader+InlineAccessors.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSData ( _PropertyListParsing)


static inline int   hex( _MulleObjCPropertyListReader *reader, char c)
{
    switch( c) 
    {
    case '0': 
    case '1': 
    case '2': 
    case '3': 
    case '4':
    case '5': 
    case '6': 
    case '7': 
    case '8': 
    case '9':
        return( c - '0'); 
    
    case 'A': 
    case 'B': 
    case 'C':
    case 'D': 
    case 'E':
    case 'F':
        return( c - 'A' + 10); 
    
    case 'a': 
    case 'b': 
    case 'c':
    case 'd': 
    case 'e': 
    case 'f':
        return( c - 'a' + 10); 

    default:
        _MulleObjCPropertyListReaderFail( reader, @"invalid hex nybble '%c' ($%X)", c, c);
        return( 0);
   }
}


NSData   *_MulleObjCNewDataFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   MulleObjCMemoryRegion  region;
   NSMutableData   *buffer;
   long            x;
   unsigned char   *src;
   unsigned char   *dst;
   unsigned char   *start;
   unsigned char   *srcSentinel;
   //unsigned char   *dstSentinel;
   size_t          len;
   
   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader); // skip '<'
   if( x != '<')
      return( nil);
      
   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '<'
   x = _MulleObjCPropertyListReaderSkipWhite( reader);
   if( x == '>')
   {
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '<'
      return( [reader->nsDataClass new]);
   }
   
   [reader bookmark];
   
   _MulleObjCPropertyListReaderSkipUntil( reader, '>');
   
   region = _MulleObjCPropertyListReaderBookmarkedRegion( reader);
   
   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader);
   if( x != '>')
      return( (id) _MulleObjCPropertyListReaderFail( reader, @"unexpected garbage at end of NSData"));
      
   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '>'
   
   len         = region.length;
   buffer      = [[NSMutableData alloc] initWithLength:len / 2];
   
   src         = region.bytes;
   srcSentinel = &src[ len];   

   dst         = (unsigned char *) [buffer mutableBytes];
   //dstSentinel = &dst[ len / 2];   
   start       = dst;
   
   while( src < srcSentinel)
   {
      if( *src == ' ')
      {
         ++src;
         continue;
      }
         
      *dst++ = (unsigned char) ((hex( reader,  src[ 0]) << 4) | hex( reader, src[ 1]));
      src   += 2;
   }
   
   [buffer setLength:dst-start];
   
   return( buffer);
}


@end
