//
//  NSObject+PropertyListParsing.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2009 Nat! - Mulle kybernetiK.
//  Copyright (c) 2009 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSObject+PropertyListParsing.h"

// other files in this library
#import "NSArray+PropertyListParsing.h"
#import "NSDictionary+PropertyListParsing.h"
#import "NSData+PropertyListParsing.h"
#import "NSString+PropertyListParsing.h"
#import "_MulleObjCPropertyListReader.h"
#import "_MulleObjCPropertyListReader+InlineAccessors.h"

// other libraries of MulleObjCPosixFoundation

// std-c and dependencies

@interface NSObject( _NS)

- (BOOL) __isNSString;
- (BOOL) __isNSNumber;

@end


@implementation NSObject( NSPropertyListParsing)


enum
{
   is_string = 0,
   is_integer,
   is_double
};

enum
{
   has_nothing,
   has_sign,
   has_leading_zero,
   has_integer,
   has_dot,
   has_fractional,
   has_exp,
   has_exp_sign,
   has_exponent,
};


//
// can't parse hex, and octal.
// specifically does not parse leading 0 numbers (except 0) (avoid phonenumbers)
// does not allow leading plus (avoid phonenumbers)
// does not allow .2
// does allow 0.e10
// does not allow e10
// guarantees that int is <= 18 and double <= 24
// of course this is a heuristic. on the bright side, we quote "dudes" on
// output
//
int   _dude_looks_like_a_number( char *buffer, size_t len);

int   _dude_looks_like_a_number( char *buffer, size_t len)
{
   char   *sentinel;
   int    state;
   int    c;

   state = has_nothing;

   sentinel = &buffer[ len];
   do
   {
      c = *buffer++;

      switch( state)
      {
      case has_nothing :
         switch( c)
         {
         case '-' : state = has_sign; continue;
         case '0' : state = has_leading_zero; continue;
         default  : if( isdigit( c)) { state = has_integer; continue; }
         }
         return( is_string);

      case has_sign :
         switch( c)
         {
         case '0' : state = has_leading_zero; continue;
         default  : if( isdigit( c)) { state = has_integer; continue; }
         }
         return( is_string);

      case has_leading_zero :
         switch( c)
         {
         case 'e' :
         case 'E' : state = has_exp; continue;
         case ',' :
         case '.' : state = has_dot; continue;
         default  : ;
         }
         return( is_string);

      case has_integer :
         switch( c)
         {
         case 'e' :
         case 'E' : state = has_exp; continue;
         case ',' :
         case '.' : state = has_dot; continue;
         default  : if( isdigit( c)) { continue; }
         }
         return( is_string);

      case has_dot :
         switch( c)
         {
         case 'e' :
         case 'E' : state = has_exp; continue;
         default  : if( isdigit( c)) { state = has_fractional; continue; }
         }
         return( is_string);

      case has_fractional :
         switch( c)
         {
         case 'e' :
         case 'E' : state = has_exp; continue;
         default  : if( isdigit( c)) { continue; }
         }
         return( is_string);

      case has_exp :
         switch( c)
         {
         case '+' :
         case '-' : state = has_exp_sign; continue;
         default  : if( isdigit( c)) { state = has_exponent; continue; }
         }
         return( is_string);

      case has_exp_sign :
         if( isdigit( c)) { state = has_exponent; continue; }
         return( is_string);

      case has_exponent :
         if( isdigit( c)) {  continue; }
         return( is_string);
      }
   }
   while( buffer < sentinel);

   switch( state)
   {
   case has_leading_zero :
   case has_integer      : return( len <= 18 ? is_integer : is_string); break; // 9223372036854775808
   case has_fractional   :
   case has_exponent     : return( len <= 24 ? is_double : is_string); // 4.94065645841246544e-324
   }
   return( is_string);
}


//
// if it's unquoted it's known to be non-nil, unescaped and alnum
// (with possibly +-eE)
//
id   _MulleObjCNewObjectParsedUnquotedFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   MulleObjCMemoryRegion  region;
   char             buf[ 32];
   int              type;

   _MulleObjCPropertyListReaderBookmark( reader);
   _MulleObjCPropertyListReaderSkipUntilTrue( reader, _MulleObjCPropertyListReaderIsUnquotedStringEndChar);
   region = _MulleObjCPropertyListReaderBookmarkedRegion( reader);
   // empty string not possible

   if( [reader decodesNumber])
   {
      switch( type = _dude_looks_like_a_number( (char *) region.bytes, region.length))
      {
      case is_integer :
      case is_double  :
         memcpy( buf, region.bytes, region.length);
         buf[ region.length] = 0;
         if( type == is_integer)
            return( [[NSNumber alloc] initWithLongLong:atoll( buf)]);
         return( [[NSNumber alloc] initWithDouble:atof( buf)]);
      }
   }
   return( [[reader->nsStringClass alloc] mulleInitWithUTF8Characters:region.bytes
                                                               length:region.length]);
}


// nil means error, _MulleObjCPropertyListReaderFail should have complained
// already.
//
// NSNull means some plist is incomplete like a comma after a value is
// missing "{ x, }".If you get this at the beginning of a parse it indicates
// a malformed plist
//
id   _MulleObjCNewFromPropertyListWithStreamReader( _MulleObjCPropertyListReader *reader)
{
   long   x;
   long   y;
   id     plist;
   id     tofree;
   BOOL   missingSlash;
   BOOL   isLeaf;

   isLeaf = [reader isLeaf];
   [reader setLeaf:YES];

   x = _MulleObjCPropertyListReaderSkipWhiteAndComments( reader);
   switch( x)
   {
   case -1 :
      return( (id) _MulleObjCPropertyListReaderFail( reader,
                     @"empty property list is invalid"));

   default: // an unquoted string or number
      if( ! [reader decodesComments])
      {
         if( x == '/')
            return( (id) _MulleObjCPropertyListReaderFail( reader, @"stray '/' in input (needs to be quoted)"));
      }

      /* we missed a '/', only happens ifdef MULLE_PLIST_DECODE_PBX  */
      missingSlash = (x != _MulleObjCPropertyListReaderCurrentUTF32Character( reader));
      if( ! _MulleObjCPropertyListReaderIsUnquotedStringStartChar( reader, x))
         return( (id) _MulleObjCPropertyListReaderFail( reader,
                     @"stray '%c' (%ld) in input (needs to be quoted)",
                     (int) x, x));

      plist = _MulleObjCNewObjectParsedUnquotedFromPropertyListWithReader( reader);
      if( missingSlash && plist)
      {
         [plist autorelease];
         plist  = [[@"/" stringByAppendingString:plist] retain];
      }
      break;

   case '"': // quoted string
      plist = _MulleObjCNewStringFromPropertyListWithReader( reader);
      if( isLeaf)
         return( plist);
      break;

   case '{': // dictionary
      plist = _MulleObjCNewDictionaryFromPropertyListWithReader( reader, nil);
      return( plist);

   case '(': // array
      plist = _MulleObjCNewArrayFromPropertyListWithReader( reader);
      return( plist);

   case '<': // data
      plist = _MulleObjCNewDataFromPropertyListWithReader( reader);
      return( plist);

   case '}' :
   case ')' :  // can happen in  (  v, y, c, ) situations
      return( [NSNull null]);
   }

   // known to be a string, lets check if it really is "strings format"
   NSCParameterAssert( [plist __isNSString] || [plist __isNSNumber]);

   x = _MulleObjCPropertyListReaderSkipWhiteAndComments( reader);
   if( x != '=')
      return( plist);

   /* it's a strings file really ! */
   [reader setStringsPlist:YES];
   plist = _MulleObjCNewDictionaryFromPropertyListWithReader( reader, plist);
   return( plist);
}

@end
