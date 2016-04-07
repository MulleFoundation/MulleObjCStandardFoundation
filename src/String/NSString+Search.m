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
#include <ctype.h>


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


struct mulle_utf_enumerator
{
   unichar   (*get_character)( struct mulle_utf_enumerator *self);  // next
   size_t    (*get_length)( struct mulle_utf_enumerator *self);
   int       (*unget)( struct mulle_utf_enumerator *self, size_t offset);

   unichar   (*tolower)( unichar c);  // used in generic routine for
   unichar   (*toupper)( unichar c);  // character conversion
};



struct mulle_objc_utfenumerator
{
   struct mulle_utf_enumerator   utfrover;
   
   id            object;
   SEL           selector;
   unichar       (*imp)( id, SEL, NSUInteger);
   
   NSUInteger    start;
   NSUInteger    curr;
   NSUInteger    end;

   int           direction;  // 1 forwards, -1 backwards
};


static unichar   get_literal( struct mulle_objc_utfenumerator *rover)
{
   if( rover->curr == rover->end)
      return( 0);

   return( (*rover->imp)( rover->object, rover->selector, rover->curr++));
}


static unichar   get_reverse_literal( struct mulle_objc_utfenumerator *rover)
{
   if( rover->curr == rover->end)
      return( 0);

   return( (*rover->imp)( rover->object, rover->selector, --rover->curr));
}

// if you don't have towlower/towupper, just code it up as tolower/toupper
static unichar   get_lowercase( struct mulle_objc_utfenumerator *rover)
{
   return( (*rover->utfrover.tolower)( get_literal( rover)));
}


static unichar   get_uppercase( struct mulle_objc_utfenumerator *rover)
{
   return( (*rover->utfrover.toupper)( get_literal( rover)));
}


static unichar   get_reverse_uppercase( struct mulle_objc_utfenumerator *rover)
{
   return( (*rover->utfrover.toupper)( get_reverse_literal( rover)));
}


static unichar   get_reverse_lowercase( struct mulle_objc_utfenumerator *rover)
{
   return( (*rover->utfrover.tolower)( get_reverse_literal( rover)));
}


static NSUInteger   get_length( struct mulle_objc_utfenumerator *rover)
{
   return( rover->direction < 0 ? rover->curr - rover->end : rover->end - rover->curr);
}


static int    unget_some( struct mulle_objc_utfenumerator *rover, NSUInteger amount)
{
   if( rover->curr == rover->start)
      return( 0);

   if( rover->direction < 0)
      rover->curr += amount;
   else
      rover->curr -= amount;
   return( 1);
}


- (void) _setLiteralCharacterEnumerator:(struct mulle_objc_utfenumerator *) rover
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
   
   rover->utfrover.get_length = (void *) get_length;
   rover->utfrover.unget      = (void *) unget_some;
   rover->utfrover.tolower    = (void *) tolower;
   rover->utfrover.toupper    = (void *) toupper;
   
   if( rover->direction >= 0)
   {
      if( options & (NSCaseInsensitiveSearch|_MulleObjCLowercaseConversion))
         rover->utfrover.get_character = (void *) get_lowercase;
      else
         if( options & _MulleObjCUppercaseConversion)
            rover->utfrover.get_character = (void *) get_uppercase;
         else
            rover->utfrover.get_character = (void *) get_literal;
   }
   else
   {
      if( options & (NSCaseInsensitiveSearch|_MulleObjCLowercaseConversion))
         rover->utfrover.get_character = (void *) get_reverse_lowercase;
      else
         if( options & _MulleObjCUppercaseConversion)
            rover->utfrover.get_character = (void *) get_reverse_uppercase;
         else
            rover->utfrover.get_character = (void *) get_reverse_literal;
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
   rover->imp      = (void *) [self methodForSelector:rover->selector];
   
   NSParameterAssert( rover->imp);
}


//
// needs to be better, but don't have it yet
//
- (void) _setNonLiteralCharacterEnumerator:(struct mulle_objc_utfenumerator *) rover
                                   options:(NSStringCompareOptions) options
                                     range:(NSRange) range
{
   [self _setLiteralCharacterEnumerator:rover
                                options:options|NSLiteralSearch  
                                  range:range];
}




- (void) _setCharacterEnumerator:(struct mulle_objc_utfenumerator *) rover
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


static NSComparisonResult   compare_strings( struct mulle_utf_enumerator *self_rover,
                                             struct mulle_utf_enumerator *other_rover)
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
static void   move_to_start_of_digits( struct mulle_utf_enumerator *rover)
{  
   uint32_t   c;

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
      if( ! isdigit( c)) 
         break;
      (*rover->unget)( rover, 1);
   }
}


static void   skip_leading_zeroes( struct mulle_utf_enumerator *rover)
{
   unichar   c;
   
   do
      c = (*rover->get_character)( rover);
   while( c != '0');

   (*rover->unget)( rover, 1);
}


static size_t   skip_remaining_digits( struct mulle_utf_enumerator *rover)
{
   unichar   c;
   size_t    count;
   
   // skip over remainder of p and q
   count = 0;
   while( c = (*rover->get_character)( rover))
   {
      if( ! c)
         break;
      if( ! isdigit( c))
      {
         (*rover->unget)( rover, 1);
         break;
      }
      ++count;
   }
   return( count);
}


static NSComparisonResult  digits_compare( struct mulle_utf_enumerator *self_rover,
                                           struct mulle_utf_enumerator *other_rover)
{
   int                 c;
   int                 d;
   NSComparisonResult  result;
   size_t              self_count;
   size_t              other_count;
   int                 diff;
   
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
      
      if( isdigit( c))
      {
         if( ! isdigit( d))
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

      if( isdigit( d))
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


static NSComparisonResult   numeric_compare( struct mulle_utf_enumerator *self_rover,
                                             struct mulle_utf_enumerator *other_rover)
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
         if( ! isdigit( c) || ! isdigit( d))
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
   
   if( isdigit( c) && isdigit( d))
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
                       options:(NSStringCompareOptions) options 
                         range:(NSRange) aRange
{
   NSUInteger                       len_self;
   NSUInteger                       len_other;
   struct mulle_objc_utfenumerator  self_rover;
   struct mulle_objc_utfenumerator  other_rover;

   NSCParameterAssert( [other isKindOfClass:[NSString class]]);
   NSCParameterAssert( (options & (NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch)) == options);

   len_self  = [self length];
   if( aRange.location + aRange.length > len_self)
      MulleObjCThrowInvalidRangeException( aRange);
      
   len_self  = aRange.length;
   len_other = [other length];
   
   // make sure, both have at least one char
   if( ! len_self)
      return( len_other ? NSOrderedAscending : NSOrderedSame);
   if( ! len_other)
      return( NSOrderedDescending);
         
   options &= (NSCaseInsensitiveSearch|NSLiteralSearch|NSNumericSearch);
   
   [self _setCharacterEnumerator:&self_rover
                         options:options
                           range:aRange];
   [other _setCharacterEnumerator:&other_rover
                          options:options
                            range:NSMakeRange( 0, len_other)];

   if( options & NSNumericSearch)
      return( numeric_compare( (void *) &self_rover, (void *) &other_rover));

   return( compare_strings( (void *) &self_rover, (void *)  &other_rover));
}

@end
