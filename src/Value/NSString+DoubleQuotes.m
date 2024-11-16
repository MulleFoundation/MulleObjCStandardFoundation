//
//  NSString+DoubleQuotes.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2023 Nat! - Mulle kybernetiK.
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
#import "NSString+DoubleQuotes.h"

#import "import-private.h"


#import "_MulleObjCCheatingASCIICharacterSet.h"
#import "NSString+Search.h"


struct parser
{
   struct mulle_utf8data    cdata;
   NSUInteger               start;
   int                      quoted;
   char                     *curr;
   char                     *sentinel;
   struct mulle__rangeset   ranges;
   struct mulle_allocator   *allocator;
   struct mulle_range       storage[ 16];
};


static inline void  _parser_init( struct parser *p,
                                  struct mulle_utf8data cdata,
                                  struct mulle_allocator *allocator)
{

   memset( p, 0, sizeof( *p));

   p->cdata     = cdata;
   p->curr      = cdata.characters;
   p->sentinel  = &p->curr[ cdata.length];
   p->allocator = allocator;
   _mulle__rangeset_init_with_static_ranges( &p->ranges, p->storage, 16);
}


static inline void  _parser_done( struct parser *p)
{
   _mulle__rangeset_done( &p->ranges, p->allocator);
}


static inline void  _parser_memorize( struct parser *p)
{
   p->start = (p->curr - p->cdata.characters);
}


static inline void  _parser_set_quoted( struct parser *p, int flag)
{
   p->quoted = flag;
}


static inline int  _parser_is_quoted( struct parser *p)
{
   return( p->quoted);
}


static inline void  _parser_skip( struct parser *p)
{
   ++p->curr;
}


static inline unsigned int   _parser_skip_white( struct parser *p)
{
   unsigned int   skipped;

   for( skipped = 0; p->curr < p->sentinel; ++p->curr)
   {
      switch( *p->curr)
      {
      case ' '  :
      case '\f' :
      case '\n' :
      case '\r' :
      case '\t' :
      case '\v' :
         ++skipped;
         continue;
      }
      break;
   }
   return( skipped);
}


static void  _parser_define_range( struct parser *p)
{
   NSUInteger           end;
   NSUInteger           len;
   struct mulle_range   range;

   end   = p->curr - p->cdata.characters;
   len   = end - p->start;
   range = mulle_range_make( p->start, len);
   _mulle__rangeset_insert( &p->ranges, range, p->allocator);

   p->start = (p->curr - p->cdata.characters) + 1;
}



static void  _parser_define_range_if_not_empty( struct parser *p)
{
   NSUInteger           end;
   NSUInteger           len;
   struct mulle_range   range;

   // this can happen in the very end when we maybe skip white
   // and then possibly post increment one too much
   if( p->curr > p->sentinel)
      p->curr = p->sentinel;

   end = p->curr - p->cdata.characters;
   len = end - p->start;
   if( len)
   {
      range = mulle_range_make( p->start, len);
      _mulle__rangeset_insert( &p->ranges, range, p->allocator);
   }

   p->start = (p->curr - p->cdata.characters) + 1;
}


static NSString   *_parser_extract_string( struct parser *p, int nil_if_empty)
{
   NSString   *s;

   if( nil_if_empty && ! _mulle__rangeset_sum_lengths( &p->ranges))
      return( nil);

   s = [NSString mulleStringWithUTF8Characters:(char *) p->cdata.characters
                                     cRangeSet:&p->ranges];
   _mulle__rangeset_reset( &p->ranges, p->allocator);
   return( s);
}


@implementation NSString( DoubleQuotedString)

+ (NSString *) mulleStringWithUTF8Characters:(char *) bytes
                                   cRangeSet:(struct mulle__rangeset *) ranges
{
   NSString             *s;
   NSMutableString      *buf;
   struct mulle_range   range;
   NSUInteger           i, n;

   buf = nil;
   n   = _mulle__rangeset_get_rangecount( ranges);
   for( i = 0; i < n; i++)
   {
      range = _mulle__rangeset_get( ranges, i);
      s     = [NSString mulleStringWithUTF8Characters:&bytes[ range.location]
                                               length:range.length];
      if( n == 1)
         return( s);

      if( ! buf)
         buf = [NSMutableString string];
      [buf appendString:s];
   }
   return( buf);
}


//
// Creates components from everything that is whitespace separated
// Understands that "..." is a string that could contain whitespace, which
// is not supposed to act as a separator. Also understands that \" in a string
// indicates a " that is not to be understood as a quote. Furthermore
// understands that \\ is supposed to be a \.
// "...""..." is not separated by a space, so it will be concatenated.
// also does '' quoting now, but does not do ''' like the shell but
// also escapes with backslash
//
// quoting=1 "
// quoting=2 '
// quoting=3 " + '
//
static NSArray   *mulleComponentsSeparatedByWhitespaceWithQuoting( NSString *self, NSUInteger quoting)
{
   NSData              *data;
   NSMutableArray      *array;
   NSString            *s;
   struct parser       parser;
   struct mulle_data   cdata;
   int                 concat;
   int                 quote_char;

   array = nil;

   data  = [self mulleDataUsingEncoding:NSUTF8StringEncoding
                        encodingOptions:MulleStringEncodingOptionTerminateWithZero];

   cdata = [data mulleCData];
   cdata.length--; // ignore zero

   _parser_init( &parser, mulle_data_as_utf8data( cdata), NULL);
   _parser_skip_white( &parser);
   _parser_memorize( &parser);

   while( parser.curr < parser.sentinel)
   {
      /* quoted */
      if( _parser_is_quoted( &parser))
      {
         quote_char = _parser_is_quoted( &parser) == 1 ? '"' : '\'';
         while( parser.curr < parser.sentinel)
         {
            switch( *parser.curr)
            {
            case '\'' : // closer
            case '"' : // closer
               if( *parser.curr != quote_char)
               {
                  _parser_skip( &parser);
                  continue;
               }

               _parser_define_range( &parser);
               concat = parser.curr[ 1] == quote_char;
               _parser_skip( &parser);
               if( ! concat)
               {
                  if( _parser_skip_white( &parser))
                  {
                     s     = _parser_extract_string( &parser, 0);
                     array = array ? array : [NSMutableArray array];
                     [array addObject:s];
                  }
               }
               _parser_memorize( &parser);
               _parser_set_quoted( &parser, 0);
               break;

            // just unescape \" and \\
            // use the fact, that we know there is a terminating zero
            // that's behind sentinel
            case '\\' :
               if( parser.curr[ 1] == quote_char)
               {
                  _parser_define_range( &parser);
                  _parser_skip( &parser);
                  _parser_memorize( &parser);
               }
               else
                  if( parser.curr[ 1] == '\\')
                  {
                     _parser_skip( &parser);
                     _parser_define_range( &parser);
                     _parser_skip( &parser);
                     _parser_memorize( &parser);
                  }
               // fall thru

            default :
               _parser_skip( &parser);
               continue;
            }
            break;
         }
      }
      /* unquoted */
      while( parser.curr < parser.sentinel)
      {
         switch( *parser.curr)
         {
         case '\'' :
            if( ! (quoting & 2))
            {
               _parser_skip( &parser);
               continue;
            }
            _parser_define_range_if_not_empty( &parser);
            _parser_set_quoted( &parser, 2);
            _parser_skip( &parser);
            break;

         case '"' :
            if( ! (quoting & 1))
            {
               _parser_skip( &parser);
               continue;
            }

            _parser_define_range_if_not_empty( &parser);
            _parser_set_quoted( &parser, 1);
            _parser_skip( &parser);
            break;

         case ' '  :
         case '\f' :
         case '\n' :
         case '\r' :
         case '\t' :
         case '\v' :
            _parser_define_range_if_not_empty( &parser);
            s = _parser_extract_string( &parser, 1);
            if( s)
            {
               array = array ? array : [NSMutableArray array];
               [array addObject:s];
            }
            _parser_skip_white( &parser);
            _parser_memorize( &parser);
            continue;

         default :
            _parser_skip( &parser);
            continue;
         }

         break;
      }
   }

   // strings with opened quotes but not closed are lost
   if( ! _parser_is_quoted( &parser))
   {
      _parser_define_range_if_not_empty( &parser);
      if( (s = _parser_extract_string( &parser, 1)))
      {
         array = array ? array : [NSMutableArray array];
         [array addObject:s];
      }
   }
   _parser_done( &parser);

   return( array ? array : [NSArray arrayWithObject:@""]);
}


- (NSArray *) mulleComponentsSeparatedByWhitespaceWithDoubleQuoting
{
   return( mulleComponentsSeparatedByWhitespaceWithQuoting( self, 1));
}


- (NSArray *) mulleComponentsSeparatedByWhitespaceWithSingleQuoting
{
   return( mulleComponentsSeparatedByWhitespaceWithQuoting( self, 2));
}


- (NSArray *) mulleComponentsSeparatedByWhitespaceWithSingleAndDoubleQuoting
{
   return( mulleComponentsSeparatedByWhitespaceWithQuoting( self, 3));
}


- (NSString *) mulleDoubleQuoteEscapedString
{
   NSCharacterSet           *charSet;
   char                     *start;
   char                     *src;
   char                     *sentinel;
   char                     *dst;
   NSUInteger               count;
   NSUInteger               length;
   NSString                 *s;
   struct mulle_data        cdata;
   struct mulle_allocator   *allocator;

   {
      struct _MulleObjCCheatingASCIICharacterSetStorage   charSet_storage;

      charSet = _MulleObjCCheatingASCIICharacterSetStorageInit( &charSet_storage,
                                                                "\"\\",
                                                                2,
                                                                NO);
      count   = [self mulleCountOccurrencesOfCharactersFromSet:charSet
                                                         range:MulleMakeFullRange()];
      if( count == 0)
         return( self);
   }

   // running a second time over string somewhat lame
   length = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

   mulle_buffer_do( buffer)
   {
      start    = mulle_buffer_guarantee( buffer, length + count + 1);
      dst      = start;
      src      = &start[ count];
      sentinel = &src[ length];
      [self mulleGetUTF8Characters:src
                         maxLength:length];
      while( src < sentinel)
      {
         if( *src == '\\' || *src == '\"')
            *dst++ = '\\';
         *dst++ = *src++;
      }
      *dst++ = 0;

      mulle_buffer_advance( buffer, dst - start);
      allocator = mulle_buffer_get_allocator( buffer);
      cdata     = mulle_buffer_extract_data( buffer);
      s         = [[[NSString alloc] mulleInitWithUTF8CharactersNoCopy:cdata.bytes
                                                                length:cdata.length
                                                             allocator:allocator] autorelease];
   }
   return( s);
}


@end

