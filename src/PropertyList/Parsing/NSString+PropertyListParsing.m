//
//  NSString+PropertyListPrinting.m
//  MulleObjCEOUtil
//
//  Created by Nat! on 13.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "NSString+PropertyListParsing.h"

// other files in this library
#import "_MulleObjCPropertyListReader+InlineAccessors.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies



@implementation NSString ( _PropertyListParsing)


NSString   *_MulleObjCNewStringParsedQuotedFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   long           x;
   size_t         len;
   size_t         escaped;
   MulleObjCMemoryRegion  region;
   NSMutableData  *data;
   unsigned char  *src;
   unsigned char  *dst;
   NSString       *s;
   
   // grab '"' off
   x = _MulleObjCPropertyListReaderNextUTF32Character( reader);
   
   _MulleObjCPropertyListReaderBookmark(reader);
   escaped = 0;
   
   //
   // consume string... figure out how long it is
   // first slurp in the string unescaped and check boundaries
   //
   while( x != '"')
   {
      if( x == '\\') 
      {
         x = _MulleObjCPropertyListReaderNextUTF32Character( reader);
         switch( x)
         {
         case -1   : return( (id) _MulleObjCPropertyListReaderFail( reader, @"escape in quoted string not finished !"));
         case 'a'  : 
         case 'b'  : 
         case 'f'  : 
         case 'n'  : 
         case 'r'  : 
         case 't'  : 
         case 'v'  : 
         case '\\' : 
         case '\"' : 
#if ESCAPED_ZERO_IN_UTF8_STRING_IS_A_GOOD_THING   
         case '0' : 
#endif   
               break;
         }
         escaped++;
      }
      x = _MulleObjCPropertyListReaderNextUTF32Character( reader);
      if( x < 0)
         return( (id) _MulleObjCPropertyListReaderFail( reader, @"quoted string not closed (expected '\"')"));
   }
   
  
   // get region without the trailing quote
   region = _MulleObjCPropertyListReaderBookmarkedRegion( reader);
   // now we can't read the stream anymore, until we are done with the region
   // it's fragile but faster
   
   if( ! region.length)
   {
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '"'
      return( [[reader->nsStringClass alloc] initWithString:@""]);
   }
   
   if( ! escaped)
   {
      s = [[reader->nsStringClass alloc] initWithUTF8Characters:region.bytes
                                                         length:region.length];
      _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader); // skip '"'
      return( s);
   }                               
   
   len  = region.length - escaped;
   data = [[NSMutableData alloc] initWithLength:len];
   
   src = (unsigned char *) region.bytes;
   dst = (unsigned char *) [data bytes];
   
   while( len)
   {
      --len;
      if( (*dst++ = *src++) == '\\') // oldskool code
         switch( *src++)
         {
         case 'a'  : dst[ -1] = '\a'; break;
         case 'b'  : dst[ -1] = '\b'; break;
         case 'f'  : dst[ -1] = '\f'; break;
         case 'n'  : dst[ -1] = '\n'; break;
         case 'r'  : dst[ -1] = '\r'; break;
         case 't'  : dst[ -1] = '\t'; break;
         case 'v'  : dst[ -1] = '\v'; break;
         case '\\' : dst[ -1] = '\\'; break;
         case '\"' : dst[ -1] = '\"'; break;
#if ESCAPED_ZERO_IN_UTF8_STRING_IS_A_GOOD_THING   
         case '0' : 
#endif   
            break;
         }
   }
   s = [[reader->nsStringClass alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
   [data release];
   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( reader);  // skip '"'
   return( s);
}


NSString   *_MulleObjCNewStringFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   long  x;
   
   x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader);
   if( x == '"')
      return( _MulleObjCNewStringParsedQuotedFromPropertyListWithReader( reader));
   return( _MulleObjCNewObjectParsedUnquotedFromPropertyListWithReader( reader));
}

@end
