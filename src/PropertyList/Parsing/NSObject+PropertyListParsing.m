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
#import "_MulleObjCPropertyListReader+InlineAccessors.h"

// other libraries of MulleObjCPosixFoundation

// std-c and dependencies


@implementation NSObject( NSPropertyListParsing)


static char  end_char_lut[ 128];

+ (void) load
{
   // could be a static initialize of end_char_lut, but laziness...
   end_char_lut[ ' ']  =
   end_char_lut[ '\t'] =
   end_char_lut[ '\n'] =
   end_char_lut[ '\r'] =
   end_char_lut[ '=']  =
   end_char_lut[ ';']  =
   end_char_lut[ ',']  =
   end_char_lut[ '"']  =
   end_char_lut[ ')']  =
   end_char_lut[ '}']  =
   end_char_lut[ '>']  = YES;
}

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


static BOOL _isUnquotedStringEndChar(long _c)
{
   return( (unsigned long) _c >= 128 ? NO : end_char_lut[ _c]);
}


//
// if it's unquoted it's known to be non-nil, unescaped and ASCII
//
id   _MulleObjCNewObjectParsedUnquotedFromPropertyListWithReader( _MulleObjCPropertyListReader *reader)
{
   MulleObjCMemoryRegion  region;
   char             buf[ 32];
   int              type;

   _MulleObjCPropertyListReaderBookmark( reader);
   _MulleObjCPropertyListReaderSkipUntilTrue( reader, _isUnquotedStringEndChar);
   region = _MulleObjCPropertyListReaderBookmarkedRegion( reader);
   // empty string not possible

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
   return( [[reader->nsStringClass alloc] _initWithUTF8Characters:region.bytes
                                                          length:region.length]);
}


id   _MulleObjCNewFromPropertyListWithStreamReader( _MulleObjCPropertyListReader *reader)
{
    unsigned long   x;

    x = _MulleObjCPropertyListReaderCurrentUTF32Character( reader);

retry:
    switch( x)
    {
    case ' ':
    case '\t':
    case '\r':
    case '\n':
    case '\f':
    case '\v':
    case '\b':
        x = _MulleObjCPropertyListReaderNextUTF32Character( reader);
        goto retry;

    default: // an unquoted string
        return( _MulleObjCNewObjectParsedUnquotedFromPropertyListWithReader( reader));
    case '"': // quoted string
        return( _MulleObjCNewStringFromPropertyListWithReader( reader));
    case '{': // dictionary
        return( _MulleObjCNewDictionaryFromPropertyListWithReader( reader));
    case '(': // array
        return( _MulleObjCNewArrayFromPropertyListWithReader( reader));
    case '<': // data
        return( _MulleObjCNewDataFromPropertyListWithReader( reader));

    case '}' :
    case ')' :  // can happen in  (  v, y, c, ) situations
      ;
    }

    return( nil);
}

@end
