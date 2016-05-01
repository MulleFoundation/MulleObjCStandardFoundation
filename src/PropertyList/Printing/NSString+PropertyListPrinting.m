//
//  NSString+PropertyListPrinting.m
//  MulleEOUtil
//
//  Created by Nat! on 14.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+PropertyListPrinting.h"

// other files in this library
#import "NSData+PropertyListPrinting.h"

// std-c and dependencies


@implementation NSString ( PropertyListPrinting)

//
// this is probably too slow
//
- (NSData *) propertyListUTF8DataWithIndent:(unsigned int) indent
{
   NSData          *data;
   unsigned char   *s, *start;
   unsigned char   *q, *sentinel;
   size_t          len;
   NSMutableData   *target;
   
   // don't do this for larger strings
   data = [self dataUsingEncoding:NSUTF8StringEncoding];
   if( ! [data propertyListUTF8DataNeedsQuoting])
      return( data);
      
   // do proper quoting and escaping
   len    = [data length];
   target = [NSMutableData dataWithLength:len * 2 + 2];
   start  = (unsigned char *) [target mutableBytes];
   s      = start;
   q      = (unsigned char *) [data bytes];

   sentinel = &q[ len];
   *s++     = '\"';

   do
   {
      switch( *q)
      {
      default   : *s++ = *q; break;
      case '\a' : *s++ = '\\'; *s++ = 'a'; break;
      case '\b' : *s++ = '\\'; *s++ = 'b'; break;
      case '\f' : *s++ = '\\'; *s++ = 'f'; break;
      case '\n' : *s++ = '\\'; *s++ = 'n'; break;
      case '\r' : *s++ = '\\'; *s++ = 'r'; break;
      case '\t' : *s++ = '\\'; *s++ = 't'; break;
      case '\v' : *s++ = '\\'; *s++ = 'v'; break;
      case '\\' : *s++ = '\\'; *s++ = '\\'; break;
      case '\"' : *s++ = '\\'; *s++ = '\"'; break;
#if ESCAPED_ZERO_IN_UTF8_STRING_IS_A_GOOD_THING   
      case 0    : *s++ = '\\'; *s++ = '0'; break; 
#endif   
      }
   }
   while( ++q < sentinel);

   *s++   = '\"';
      
   [target setLength:s - start];
   return( target);
}


@end
