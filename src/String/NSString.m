/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSString.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSString.h"

// other files in this library
#import "NSString+ClassCluster.h"
#import "NSString+Search.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"

// std-c and dependencies
#include <ctype.h>


@implementation NSObject( NSString)

- (BOOL) __isNSString
{
   return( NO);
}

@end


@implementation NSString

- (BOOL) __isNSString
{
   return( YES);
}


+ (id) string
{
   return( [[[self alloc] init] autorelease]);
}


+ (id) stringWithUTF8String:(mulle_utf8char_t *) s
{
   return( [[[self alloc] initWithUTF8String:s] autorelease]);
}


+ (id) stringWithUTF8Characters:(mulle_utf8char_t *) s
                         length:(NSUInteger) len
{
   return( [[[self alloc] initWithUTF8Characters:s
                                          length:len] autorelease]);
}


+ (id) stringWithUTF8CharactersNoCopy:(mulle_utf8char_t *) s
                               length:(NSUInteger) len
                            allocator:(struct mulle_allocator *) allocator
{
   return( [[[self alloc] initWithUTF8CharactersNoCopy:s
                                                length:len
                                             allocator:allocator] autorelease]);
}


+ (id) stringWithString:(NSString *) s
{
   return( [[[self alloc] initWithString:s] autorelease]);
}



#pragma mark -
#pragma mark generic init


- (id) initWithString:(NSString *) other
{
   mulle_utf8char_t    *s;
   
   s = [other UTF8String];
   return( [self initWithUTF8String:s]);
}



#pragma mark -
#pragma mark generic code

//***************************************************
// LAYER 2 - base code that works generically on all
//           subclasses
//***************************************************
- (NSUInteger) hash
{
   unichar      buf[ 48];
   NSUInteger   len;
   NSUInteger   offset;
   
   len    = [self length];
   offset = 0;
   if( len > 48)
   {
      offset = len - 48;
      len    = 48;
   }
   
   [self getCharacters:buf
                 range:NSMakeRange( offset, len)];
   
   return( mulle_hash( buf, len * sizeof( unichar)));
}


// string always zero terminates, even at the expense of loss
- (void) getUTF8String:(mulle_utf8char_t *) buf
             maxLength:(NSUInteger) maxLength
{
   NSUInteger   length;
   
   if( ! maxLength)
      return;
   
   assert( buf);
   
   length = [self length];
   [self getUTF8Characters:buf
                 maxLength:maxLength
                     range:NSMakeRange( 0, length)];

   if( maxLength >= length)
      length = maxLength - 1;
   
   buf[ length] = 0;
}


- (void) getUTF8String:(mulle_utf8char_t *) buf
{
   [self getUTF8String:buf
             maxLength:ULONG_MAX];
}


- (void) getUTF8Characters:(mulle_utf8char_t *) buf
                 maxLength:(NSUInteger) maxLength
{
   [self getUTF8Characters:buf
                 maxLength:maxLength
                     range:NSMakeRange( 0, [self length])];
}


- (void) getUTF8Characters:(mulle_utf8char_t *) buf
{
   [self getUTF8Characters:buf
                 maxLength:ULONG_MAX
                     range:NSMakeRange( 0, [self length])];
}


- (mulle_utf8char_t *) _fastUTF8StringContents
{
   return( NULL);
}


- (mulle_utf8char_t *) UTF8String
{
   return( (mulle_utf8char_t *) "");  // subclasses improve this (except empty string)
}


//***************************************************
// LAYER 4 - code that works "optimally" on all
//           subclasses and probably need not be 
//           overridden
//***************************************************
/*
 * some generic stuff, irregardless of UTF or C
 */

- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSString])
      return( NO);
   return( [self isEqualToString:other]);
}

 
- (id) description
{
   return( self);
}


// generic implementations
- (NSString *) substringToIndex:(NSUInteger) idx
{
   return( [self substringWithRange:NSMakeRange( 0, idx)]);
}


- (NSString *) substringFromIndex:(NSUInteger) idx
{
   return( [self substringWithRange:NSMakeRange( idx, [self length] - idx)]);
}


//***************************************************
// LAYER 5 - code that works "well enough" on all
//           subclasses and is probably not useful to
//           be  overridden
//***************************************************
static mulle_utf8char_t   *UTF8StringWithLeadingSpacesRemoved( NSString *self)
{
   mulle_utf8char_t  *s;
   
   s = [self UTF8String];
   assert( s);
   
   while( *s && isspace( (char) *s))
      ++s;
   return( s);
}


- (double) doubleValue
{
   return( atof( (char *) UTF8StringWithLeadingSpacesRemoved( self)));
}


- (float) floatValue
{
   return( (float) atof( (char *) UTF8StringWithLeadingSpacesRemoved( self)));
}


- (int) intValue
{
   return( atoi( (char *) UTF8StringWithLeadingSpacesRemoved( self)));
}


- (long long) longLongValue;
{
   return( atoll( (char *) UTF8StringWithLeadingSpacesRemoved( self)));
}


- (NSInteger) integerValue
{
   return( (NSInteger) atoll( (char *) UTF8StringWithLeadingSpacesRemoved( self)));
}


- (BOOL) boolValue
{
   char  *s;
   
   s = (char *) UTF8StringWithLeadingSpacesRemoved( self);
   
   if( *s == '+' || *s == '-')
      ++s;
   while( *s == '0')
      ++s;
      
   switch( *s)
   {
   case '1' :
   case '2' :
   case '3' :
   case '4' :
   case '5' :
   case '6' :
   case '7' :
   case '8' :
   case '9' :
   case 'Y' :
   case 'y' :
   case 'T' :
   case 't' :
      return( YES);
   }
   return( NO);
}


- (NSUInteger) _UTF8StringLength
{
   abort();
}

//
// this works, albeit not so well for Unicode, because both
// get converted to UTF8 and then appended.
//
// Possibly use a link list chain class for this, because
// there is probably another append coming up.
//
- (NSString *) stringByAppendingString:(NSString *) other
{
   NSUInteger  len;
   NSUInteger  other_len;
   NSUInteger  combined_len;
   NSString    *s;
   mulle_utf8char_t    *buf;
   
   len = [self _UTF8StringLength];
   if( ! len)
      return( [[other copy] autorelease]);
      
   other_len = [other _UTF8StringLength];
   if( ! other_len)
      return( [[self copy] autorelease]);
      
   combined_len = len + other_len;
   buf          = MulleObjCAllocateNonZeroedMemory( combined_len * sizeof( mulle_utf8char_t));

   [self getUTF8Characters:buf
                 maxLength:len
                     range:NSMakeRange( 0, len)];
   
   [other getUTF8Characters:&buf[ len]
                  maxLength:other_len
                      range:NSMakeRange( 0, other_len)];

   s = [[[NSString alloc] initWithUTF8Characters:buf
                                          length:combined_len] autorelease];
   return( s);
}

@end
