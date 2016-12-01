//
//  NSString+NSSearch.m
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString+Search.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <mulle_utf/mulle_utf.h>


@implementation NSString (NSSearch)

//
// an idea, to write c/unicode code that works with all character sizes
// can also manage compound characters if needed.
//

enum
{
   _MulleObjCLowercaseConversion = 0x10000,
   _MulleObjCUppercaseConversion = 0x10000
};


struct mulle_unichar_enumerator
{
   unichar   (*get_character)( struct mulle_unichar_enumerator *self);  // next
   size_t    (*get_length)( struct mulle_unichar_enumerator *self);
   int       (*unget)( struct mulle_unichar_enumerator *self, size_t offset);

   unichar   (*tolower)( unichar c);  // used in generic routine for
   unichar   (*toupper)( unichar c);  // character conversion
};



struct mulle_objc_unichar_enumerator
{
   struct mulle_unichar_enumerator   utfrover;
   
   id            object;
   SEL           selector;
   unichar       (*imp)( id, SEL, NSUInteger);
   
   NSUInteger    start;
   NSUInteger    curr;
   NSUInteger    end;

   int           direction;  // 1 forwards, -1 backwards
};


static unichar   get_literal( struct mulle_objc_unichar_enumerator *rover)
{
   if( rover->curr == rover->end)
      return( 0);

   return( (*rover->imp)( rover->object, rover->selector, rover->curr++));
}


static unichar   get_reverse_literal( struct mulle_objc_unichar_enumerator *rover)
{
   if( rover->curr == rover->end)
      return( 0);

   return( (*rover->imp)( rover->object, rover->selector, --rover->curr));
}

// if you don't have towlower/towupper, just code it up as tolower/toupper
static unichar   get_lowercase( struct mulle_objc_unichar_enumerator *rover)
{
   return( (*rover->utfrover.tolower)( get_literal( rover)));
}


static unichar   get_uppercase( struct mulle_objc_unichar_enumerator *rover)
{
   return( (*rover->utfrover.toupper)( get_literal( rover)));
}


static unichar   get_reverse_uppercase( struct mulle_objc_unichar_enumerator *rover)
{
   return( (*rover->utfrover.toupper)( get_reverse_literal( rover)));
}


static unichar   get_reverse_lowercase( struct mulle_objc_unichar_enumerator *rover)
{
   return( (*rover->utfrover.tolower)( get_reverse_literal( rover)));
}


static size_t   get_length( struct mulle_objc_unichar_enumerator *rover)
{
   return( rover->direction < 0 ? rover->curr - rover->end : rover->end - rover->curr);
}


static int    unget_some( struct mulle_objc_unichar_enumerator *rover, NSUInteger amount)
{
   if( rover->curr == rover->start)
      return( 0);

   if( rover->direction < 0)
      rover->curr += amount;
   else
      rover->curr -= amount;
   return( 1);
}


static void   get_characters( struct mulle_objc_unichar_enumerator *rover, unichar *buf)
{
   unichar   c;
   
   while( c = (rover->utfrover.get_character)( &rover->utfrover))
      *buf++ = c;
}



- (void) _setLiteralCharacterEnumerator:(struct mulle_objc_unichar_enumerator *) rover
                                options:(NSStringCompareOptions) options
                                  range:(NSRange) range
{
   NSUInteger   start;
   NSUInteger   end;
   
   NSCParameterAssert( range.location + range.length <= [self length]);
   
   start = range.location;
   end   = start + range.length;
   
//   rover->options   = options;
   rover->object    = self;
   rover->direction = options & NSBackwardsSearch ? -1 : 1;
   
   rover->utfrover.get_length = (size_t (*)()) get_length;
   rover->utfrover.unget      = (int (*)()) unget_some;
   rover->utfrover.tolower    = mulle_utf32_tolower;
   rover->utfrover.toupper    = mulle_utf32_toupper;
   
   if( rover->direction >= 0)
   {
      if( options & (NSCaseInsensitiveSearch|_MulleObjCLowercaseConversion))
         rover->utfrover.get_character = (unichar (*)()) get_lowercase;
      else
         if( options & _MulleObjCUppercaseConversion)
            rover->utfrover.get_character = (unichar (*)()) get_uppercase;
         else
            rover->utfrover.get_character = (unichar (*)()) get_literal;
   }
   else
   {
      if( options & (NSCaseInsensitiveSearch|_MulleObjCLowercaseConversion))
         rover->utfrover.get_character = (unichar (*)()) get_reverse_lowercase;
      else
         if( options & _MulleObjCUppercaseConversion)
            rover->utfrover.get_character = (unichar (*)()) get_reverse_uppercase;
         else
            rover->utfrover.get_character = (unichar (*)()) get_reverse_literal;
   }

   if( rover->direction >= 0)
   {
      rover->start = start;
      rover->end   = end;
   }
   else
   {
      rover->start = end;
      rover->end   = start;
   }

   rover->curr     = rover->start;
   rover->selector = @selector( characterAtIndex:);
   rover->imp      = (unichar (*)()) [self methodForSelector:rover->selector];
   
   NSParameterAssert( rover->imp);
}


//
// there is no difference in the MulleFoundation we only serve Literals
//
- (void) _setNonLiteralCharacterEnumerator:(struct mulle_objc_unichar_enumerator *) rover
                                   options:(NSStringCompareOptions) options
                                     range:(NSRange) range
{
   [self _setLiteralCharacterEnumerator:rover
                                options:options|NSLiteralSearch  
                                  range:range];
}




- (void) _setCharacterEnumerator:(struct mulle_objc_unichar_enumerator *) rover
                         options:(NSStringCompareOptions) options
                           range:(NSRange) range
{
   if( options & NSLiteralSearch)
   {
      [self _setLiteralCharacterEnumerator:rover
                                   options:options
                                     range:range];
      return;
   }
   
   [self _setNonLiteralCharacterEnumerator:rover
                                   options:options
                                     range:range];
}


- (BOOL) isEqualToString:(NSString *) other
{
   NSUInteger   len;
   
   if( self == other)
      return( YES);

   len = [self length];
   if( len != [other length])
      return( NO);

   return( [self compare:other
                 options:NSLiteralSearch
                   range:NSMakeRange( 0, len)] == NSOrderedSame);
}


- (BOOL) hasPrefix:(NSString *) prefix
{
   size_t   prefix_len;
   size_t   len;
   
   prefix_len = [prefix length];
   len        = [self length];
   
   if( len < prefix_len)
      return( NO);
      
   return( [self compare:prefix
                 options:NSLiteralSearch
                   range:NSMakeRange( 0, prefix_len)] == NSOrderedSame);      
}


- (BOOL) hasSuffix:(NSString *) suffix
{
   size_t   suffix_len;
   size_t   len;
   
   suffix_len = [suffix length];
   len        = [self length];
   
   if( len < suffix_len)
      return( NO);
      
   return( [self compare:suffix
                 options:NSLiteralSearch
                   range:NSMakeRange( len - suffix_len, suffix_len)] == NSOrderedSame);      
}

#pragma mark -
#pragma mark compare:

static NSComparisonResult   compare_strings( struct mulle_unichar_enumerator *self_rover,
                                             struct mulle_unichar_enumerator *other_rover)
{
   int   c;
   int   d;
   int   diff;
   
   for(;;)
   {
      c = (*self_rover->get_character)( self_rover);
      d = (*other_rover->get_character)( other_rover);
   
      if( ! c)
      {
         if( ! d)
            return( NSOrderedSame);
         return( NSOrderedAscending);
      }

      if( ! d)
         return( NSOrderedDescending);
      
      diff = (int) c - (int) d;
      if( diff)
         return( diff < 0 ? NSOrderedAscending : NSOrderedDescending);
   }
}                 


// this routine compares two numbers inside of strings
// p_p must point to pointer to "somewhere" into the first string, that resides 
// somewhere in buf of buf_len
// e.g.  buf     = "VfL Bochum 1848 e.V."
//       buf_len = strlen( buf);
//       x       = &buf[ 13];
//       p_p     = &x;
//
// same goes for q with o_buf
//
static void   move_to_start_of_digits( struct mulle_unichar_enumerator *rover)
{  
   unichar   c;

   //
   // we might be here:
   //   1234x
   //       ^
   //   1234y
   // 
   
   for(;;)
   {
      if( ! (*rover->unget)( rover, 1))
         break;
      c = (*rover->get_character)( rover);
      if( ! mulle_utf32_is_decimaldigit( c))
         break;
      (*rover->unget)( rover, 1);
   }
}


static void   skip_leading_zeroes( struct mulle_unichar_enumerator *rover)
{
   unichar   c;
   
   do
      c = (*rover->get_character)( rover);
   while( c != '0');

   (*rover->unget)( rover, 1);
}


static size_t   skip_remaining_digits( struct mulle_unichar_enumerator *rover)
{
   unichar   c;
   size_t    count;
   
   // skip over remainder of p and q
   count = 0;
   while( c = (*rover->get_character)( rover))
   {
      if( ! c)
         break;
      if( ! mulle_utf32_is_decimaldigit( c))
      {
         (*rover->unget)( rover, 1);
         break;
      }
      ++count;
   }
   return( count);
}


static NSComparisonResult  digits_compare( struct mulle_unichar_enumerator *self_rover,
                                           struct mulle_unichar_enumerator *other_rover)
{
   unichar             c;
   unichar             d;
   unichar             diff;
   NSComparisonResult  result;
   size_t              self_count;
   size_t              other_count;
   
   move_to_start_of_digits( self_rover);
   move_to_start_of_digits( other_rover);
   
   skip_leading_zeroes( self_rover);
   skip_leading_zeroes( other_rover);
   // advance over leading zeroes
   
   diff = 0;
   for(;;)
   {
      c = (*self_rover->get_character)( self_rover);
      d = (*other_rover->get_character)( other_rover);
   
      if( ! c)
      {
         if( ! d)
            return( NSOrderedSame);
         return( NSOrderedAscending);
      }

      if( ! d)
         return( NSOrderedDescending);
      
      if( mulle_utf32_is_decimaldigit( c))
      {
         if( ! mulle_utf32_is_decimaldigit( d))
         {
            (*other_rover->unget)( other_rover, 1);
            result = NSOrderedDescending;
            break;
         }

         diff = (int) c - (int) d;
         if( diff)
         {
            result = diff < 0 ? NSOrderedAscending : NSOrderedDescending;
            break;
         }
         continue;
      }

      if( mulle_utf32_is_decimaldigit( d))
      {
         (*self_rover->unget)( self_rover, 1);
         result = NSOrderedAscending;
         break;
      }

      result = NSOrderedSame;
      break;
   }

   // skip over remainder of p and q
   self_count  = skip_remaining_digits( self_rover);
   other_count = skip_remaining_digits( other_rover);
      
   if( diff == 0)
      return( result);
   
   if( self_count == other_count)
      return( result);
   return( self_count < other_count ? NSOrderedAscending : NSOrderedDescending);
}         


static NSComparisonResult   numeric_compare( struct mulle_unichar_enumerator *self_rover,
                                             struct mulle_unichar_enumerator *other_rover)
{
   unichar               c;
   unichar               d;
   unichar               diff;
   NSComparisonResult    result;
   
   for(;;)
   {
      c    = (unichar) self_rover->get_character( self_rover);
      d    = (unichar) other_rover->get_character( other_rover);
      if( ! c || ! d)
         break;
      
      diff = c - d;
      if( diff)
      {
         if( ! mulle_utf32_is_decimaldigit( c) || ! mulle_utf32_is_decimaldigit( d))
            return( diff < 0 ? NSOrderedAscending : NSOrderedDescending);
         
         //
         // cases:
         //    123   124
         //      ^     ^   (ascending)
         //
         //  foo2   foo02
         //     ^      ^   (same)
         //  
         result = digits_compare( self_rover, other_rover);
         if( result != NSOrderedSame)
            return( result);
      }
   }
   
   if( mulle_utf32_is_decimaldigit( c) && mulle_utf32_is_decimaldigit( d))
      return( digits_compare( self_rover, other_rover));

   if( ! c)
   {
      if( ! d)
         return( NSOrderedSame);
      return( NSOrderedAscending);
   }
   return( NSOrderedDescending);
}


- (NSComparisonResult) compare:(id) other
{
   return( [self compare:other
                 options:0
                   range:NSMakeRange( 0, [self length])]);
}


- (NSComparisonResult) compare:(id) other
                       options:(NSStringCompareOptions) mask
{
   return( [self compare:other
                 options:mask
                   range:NSMakeRange( 0, [self length])]);
}


- (NSComparisonResult) caseInsensitiveCompare:(NSString *) other
{
   return( [self compare:other
                 options:NSCaseInsensitiveSearch
                   range:NSMakeRange( 0, [self length])]);
}


- (NSComparisonResult) compare:(id) other
                       options:(NSStringCompareOptions) options 
                         range:(NSRange) range
{
   NSUInteger                            len_self;
   NSUInteger                            len_other;
   struct mulle_objc_unichar_enumerator  self_rover;
   struct mulle_objc_unichar_enumerator  other_rover;
   
   NSCParameterAssert( [other isKindOfClass:[NSString class]]);
   NSCParameterAssert( (options & (NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch)) == options);

   len_self  = [self length];
   if( range.location + range.length > len_self || range.length > len_self)
      MulleObjCThrowInvalidRangeException( range);
      
   len_self  = range.length;
   len_other = [other length];
   
   // make sure, both have at least one char
   if( ! len_self)
      return( len_other ? NSOrderedAscending : NSOrderedSame);
   if( ! len_other)
      return( NSOrderedDescending);
         
   options &= (NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch);
   
   [self _setCharacterEnumerator:&self_rover
                         options:options
                           range:range];
   [other _setCharacterEnumerator:&other_rover
                          options:options
                            range:NSMakeRange( 0, len_other)];

   if( options & NSNumericSearch)
      return( numeric_compare( (void *) &self_rover, (void *) &other_rover));

   return( compare_strings( (void *) &self_rover, (void *)  &other_rover));
}


#pragma mark -
#pragma mark rangeOfString:

//
// boyer moore is not so good for utf32, so i use Knuth Morris Pratt
// it turns out that the common prefix code is not really _that_ useful
// when searching for random keys... But that's just like my opinion man!
//

static void   _kmp_precompute( unichar *search,
                               size_t search_len,
                               ptrdiff_t *table)
{
   size_t      i;
   ptrdiff_t   j;
   unichar     c;
   unichar     d;
   
   j         = -1;
   table[ 0] = j;
   
   for( i = 0; i < search_len;)
   {
      if( j >= 0)
      {
         c = search[ i];
         
         do
         {
            d = search[ j];
            if( c == d)
               break;
            
            j = table[ j];
         }
         while( j >= 0);
      }
      
      ++i;
      ++j;
      
      table[ i] = j;
   }
}


//static NSInteger   __simple_search( struct mulle_objc_unichar_enumerator *self_rover,
//                                    unichar *search, size_t search_len)
//{
//   size_t      i;
//   ptrdiff_t   j;
//   unichar     c;
//   unichar     d;
//   NSInteger   found;
//   size_t      len;
//   
//   found = NSNotFound;
//   len   = get_length( self_rover);
//   
//   for( j = 0, i = 0; i < len;)
//   {
//      c = (*self_rover->utfrover.get_character)( &self_rover->utfrover);
//      d = search[ j];
//      if( c != d)
//         j = -1;
//   
//      ++i;
//      ++j;
//      
//      if( j == (ptrdiff_t) search_len)
//      {
//         found = i - search_len;
//         break;
//      }
//   }
//   
//   return( found);
//}


static NSInteger   __kmp_search( struct mulle_objc_unichar_enumerator *self_rover,
                                 unichar *search, size_t search_len,
                                 ptrdiff_t *table)
{
   NSInteger   found;
   unichar     c;
   unichar     d;
   size_t      i;
   size_t      len;
   ptrdiff_t   j;
   
   found = NSNotFound;
   len   = get_length( self_rover);
   
   for( j = 0, i = 0; i < len;)
   {
      if( j >= 0)
      {
         c = (*self_rover->utfrover.get_character)( &self_rover->utfrover);
         
         do
         {
            d = search[ j];
            if( c == d)
               break;
            
            j = table[ j];
         }
         while( j >= 0);
      }
      
      ++i;
      ++j;
      
      if( j == (ptrdiff_t) search_len)
      {
         found = i - search_len;
         break;
      }
   }
   
   return( found);
}


static NSInteger  _kmp_search( struct mulle_objc_unichar_enumerator *self_rover,
                               unichar *search,
                               size_t search_len)
{
   ptrdiff_t    *table;
   void         *tofree;
   NSInteger    found;
   ptrdiff_t    tmp[ 0x100];
   
   tofree = NULL;
   table  = tmp;
   if( search_len > 0x100 - 1)
      table = tofree = mulle_malloc( sizeof( ptrdiff_t) * search_len + 1);
   
   /* Preprocessing */
   _kmp_precompute( search, search_len, table);
   found = __kmp_search( self_rover, search, search_len, table);
   
   mulle_free( tofree);
   
   return( found);
}



static NSInteger   normal_search( struct mulle_objc_unichar_enumerator *self_rover,
                                  struct mulle_objc_unichar_enumerator *other_rover)
{
   NSInteger   index;
   size_t      search_len;
   size_t      size;
   unichar     *search;
   unichar     *tofree;
   unichar     tmp[ 0x100];
   
   // must be > 0 and is not > self_len

   // grab search pattten into own unichar buffer
   search_len = get_length( other_rover);
   size       = sizeof( unichar) * search_len;
   tofree     = NULL;
   search     = tmp;
   
   if( search_len > 0x100)
      search = tofree = mulle_malloc( size);
   
   get_characters( other_rover, search);

   index = _kmp_search( self_rover, search, search_len);
   
   mulle_free( tofree);
   
   return( index);
}


#pragma mark -
#pragma mark string search

- (NSRange) rangeOfString:(NSString *) other
                  options:(NSStringCompareOptions) options
                    range:(NSRange) range
{
   NSUInteger                            len_self;
   NSUInteger                            len_other;
   struct mulle_objc_unichar_enumerator  self_rover;
   struct mulle_objc_unichar_enumerator  other_rover;
   NSInteger                             location;
   NSRange                               result;
   
   NSCParameterAssert( [other isKindOfClass:[NSString class]]);
   NSCParameterAssert( (options & (NSAnchoredSearch|NSBackwardsSearch|NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch)) == options);
   
   len_self  = [self length];
   if( range.location + range.length > len_self || range.length > len_self)
      MulleObjCThrowInvalidRangeException( range);
   
   len_self  = range.length;
   len_other = [other length];
   
   // make sure, both have at least one char
   // ! len_other == NSNotFound is spec
   if( ! len_self || ! len_other || len_other > len_self)
      return( NSMakeRange( NSNotFound, 0));
   
   options &= (NSAnchoredSearch|NSBackwardsSearch|NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch);
   
   [self _setCharacterEnumerator:&self_rover
                         options:options
                           range:range];
   [other _setCharacterEnumerator:&other_rover
                          options:options
                            range:NSMakeRange( 0, len_other)];
   
   location = normal_search( &self_rover, &other_rover);
   if( location == NSNotFound)
      return( NSMakeRange( NSNotFound, 0));

   if( location && (options & NSAnchoredSearch))
      return( NSMakeRange( NSNotFound, 0));
   
   if( ! (options & NSBackwardsSearch))
      result = NSMakeRange( range.location + location, len_other);
   else
      result = NSMakeRange( range.location + range.length - location - len_other, len_other);
   
   NSParameterAssert( MulleObjCRangeContainsRange( range, result));
   return( result);
}


- (NSRange) rangeOfString:(NSString *) other
{
   return( [self rangeOfString:other
                       options:0
                         range:NSMakeRange( 0, [self length])]);
}


- (NSRange) rangeOfString:(NSString *) other
                  options:(NSStringCompareOptions) mask
{
   return( [self rangeOfString:other
                       options:mask
                         range:NSMakeRange( 0, [self length])]);
}


#pragma mark -
#pragma mark character search

//
// search until first time a char is matched
//
static NSInteger   charset_location_search( struct mulle_objc_unichar_enumerator *self_rover,
                                            NSCharacterSet *set)
{
   unichar   c;
   size_t    i;
   size_t    len;
   SEL       selMember;
   IMP       impMember;
   
   len       = get_length( self_rover);
   selMember = @selector( characterIsMember:);
   impMember = [set methodForSelector:selMember];
   
   for( i = 0; i < len; ++i)
   {
      c = (*self_rover->utfrover.get_character)( &self_rover->utfrover);
      if( (BOOL) (*impMember)( set, selMember, (void *) c))
         return( i);
   }
   
   return( NSNotFound);
}


- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set
                            options:(NSStringCompareOptions) options
                              range:(NSRange) range
{
   NSUInteger                            len_self;
   struct mulle_objc_unichar_enumerator  self_rover;
   NSInteger                             location;
   NSRange                               result;
   
   NSCParameterAssert( [set isKindOfClass:[NSCharacterSet class]]);
   NSCParameterAssert( (options & (NSAnchoredSearch|NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch|NSBackwardsSearch)) == options);
   
   len_self  = [self length];
   if( range.location + range.length > len_self || range.length > len_self)
      MulleObjCThrowInvalidRangeException( range);
   
   len_self = range.length;
   if( ! len_self)
      return( NSMakeRange( NSNotFound, 0));
   
   options &= (NSAnchoredSearch|NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch|NSBackwardsSearch);
   
   [self _setCharacterEnumerator:&self_rover
                         options:options
                           range:range];
   
   location = charset_location_search( &self_rover, set);
   if( location == NSNotFound)
      return( NSMakeRange( NSNotFound, 0));
   
   if( location && (options & NSAnchoredSearch))
      return( NSMakeRange( NSNotFound, 0));
   
   if( ! (options & NSBackwardsSearch))
      result = NSMakeRange( range.location + location, 1);
   else
      result = NSMakeRange( range.location + range.length - location, 1);

   NSParameterAssert( MulleObjCRangeContainsRange( range, result));
   return( result);
}


- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set
                            options:(NSStringCompareOptions) options
{
   return( [self rangeOfCharacterFromSet:set
                                 options:options
                                   range:NSMakeRange( 0, [self length])]);
}


- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set
{
   return( [self rangeOfCharacterFromSet:set
                                 options:0
                                   range:NSMakeRange( 0, [self length])]);
}



#pragma mark -
#pragma mark range search

//
// search until chars don't match set, return length of matches
//
static NSInteger   charset_length_search( struct mulle_objc_unichar_enumerator *self_rover,
                                          NSCharacterSet *set)
{
   unichar   c;
   size_t    i;
   size_t    len;
   SEL       selMember;
   IMP       impMember;
   
   len       = get_length( self_rover);
   selMember = @selector( characterIsMember:);
   impMember = [set methodForSelector:selMember];
   
   for( i = 0; i < len; ++i)
   {
      c = (*self_rover->utfrover.get_character)( &self_rover->utfrover);
      if( ! (BOOL) (*impMember)( set, selMember, (void *) c))
         break;
   }
   
   return( i);
}


- (NSRange) _rangeOfCharactersFromSet:(NSCharacterSet *) set
                              options:(NSStringCompareOptions) options
                                range:(NSRange) range
{
   NSUInteger                            len_self;
   struct mulle_objc_unichar_enumerator  self_rover;
   NSInteger                             length;
   
   NSCParameterAssert( [set isKindOfClass:[NSCharacterSet class]]);
   NSCParameterAssert( (options & (NSAnchoredSearch|NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch|NSBackwardsSearch)) == options);
   
   len_self  = [self length];
   if( range.location + range.length > len_self || range.length > len_self)
      MulleObjCThrowInvalidRangeException( range);
   
   len_self = range.length;
   if( ! len_self)
      return( NSMakeRange( NSNotFound, 0));
   
   options &= (NSAnchoredSearch|NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch|NSBackwardsSearch);
   
   [self _setCharacterEnumerator:&self_rover
                         options:options
                           range:range];
   
   length = charset_length_search( &self_rover, set);
   if( ! length)
      return( NSMakeRange( NSNotFound, 0));

   if( ! (options & NSBackwardsSearch))
      return( NSMakeRange( range.location, range.location + length));
   return( NSMakeRange( range.location + range.length - length, length));
}

@end
