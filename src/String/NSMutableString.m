/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMutableString.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSMutableString.h"

// other files in this library
#import "NSString+ClassCluster.h"
#import "NSString+Search.h"
#import "NSString+Sprintf.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"

// std-c and dependencies


@implementation NSObject( NSMutableString)

- (BOOL) __isNSMutableString
{
   return( NO);
}

@end


@implementation NSMutableString

- (BOOL) __isNSMutableString
{
   return( YES);
}


/*
 *
 */
static void   autoreleaseStorageStrings( NSMutableString *self)
{
   NSUInteger  n;
   
   n = self->_count;
   self->_count = 0;  // do it now, important for autoreleasepool checks

   _MulleObjCAutoreleaseObjects( self->_storage, n);
}

 
static void   sizeStorageWithCount( NSMutableString *self, NSUInteger count)
{
   self->_size = count + count;
   if( self->_size < 4)
      self->_size = 4;
      
   self->_storage = MulleObjCReallocateNonZeroedMemory( self->_storage, self->_size * sizeof( NSString *));
}


static void   copyStringsAndComputeLength( NSMutableString *self, NSString **strings, NSUInteger count)
{
   NSUInteger  i;
   
   self->_length = 0;
   for( i = 0; i < count; i++)
   {
      self->_storage[ i]  = [strings[ i] copy];
      self->_length      += [strings[ i] length];
   }
   self->_count = count;
}

 
static void   initWithStrings( NSMutableString *self, NSString **strings, NSUInteger count)
{
   sizeStorageWithCount( self, count);
   copyStringsAndComputeLength( self, strings, count);
}


static void   shrinkWithStrings( NSMutableString *self, NSString **strings, NSUInteger count)
{
   autoreleaseStorageStrings( self);
   if( count > self->_size || count < self->_size / 4)
      sizeStorageWithCount( self, count);
   
   copyStringsAndComputeLength( self, strings, count);
}


- (id) initWithString:(NSString *) s
{
   if( s)
      initWithStrings( self, &s, 1);
   return( self);
}


- (id) initWithStrings:(NSString **) strings
                 count:(NSUInteger) count
{
   if( count)
      initWithStrings( self, strings, count);
   return( self);
}
                 

// need to implement all _NSCStringPlaceholder does
- (id) initWithFormat:(NSString *) format
            arguments:(mulle_vararg_list) arguments
{
   NSString  *s;
   
   s = [[NSString alloc] initWithFormat:format
                                           arguments:arguments];
   initWithStrings( self, &s, 1);
   [s release];

   return( self);
}         


+ (id) stringWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


- (id) initWithCapacity:(NSUInteger) capacity;
{
   return( [self init]);
}


- (void) dealloc
{
   autoreleaseStorageStrings( self);
   MulleObjCDeallocateMemory( self->_storage);
   [super dealloc];
}


- (id) copy
{
   mulle_utf8char_t   *s;
   
   s = [self UTF8String];
   return( (id) [[NSString alloc] initWithUTF8String:s]);
}


- (void) _reset
{
   shrinkWithStrings( self, NULL, 0);
}


- (void) appendString:(NSString *) s
{
   if( _count >= _size)
   {
      _size += _size;
      if( _size < 8)
         _size = 8;
      _storage = MulleObjCReallocateNonZeroedMemory( _storage, _size * sizeof( NSString *));
   }

   _storage[ _count++] = [s copy];
   _length            += [s length];
}


- (void) appendFormat:(NSString *) format, ...
{
   NSString                 *s;
   mulle_vararg_list   args;
   
   mulle_vararg_start( args, format);
   s = [NSString stringWithFormat:format
                        arguments:args];
   mulle_vararg_end( args);
   
   return( [self appendString:s]);
}


- (void) setString:(NSString *) aString
{
   shrinkWithStrings( self, &aString, 1);
}


// this is "non"-optimal, just some code to get by
- (void) deleteCharactersInRange:(NSRange) aRange
{
   [self replaceCharactersInRange:aRange
                       withString:@""];
}


//
// maybe overcomplicated: could be better to just make a new coherent
// buffer ?
//
- (void) replaceCharactersInRange:(NSRange) aRange 
                       withString:(NSString *) replacement
{
   int           fromStart;
   int           toEnd;
   NSString      *s[ 3];
   unsigned int  i;
   NSRange       subRange;
   
  //
  // figure out range of substrings that covers
  // create two subranges and add them to the array
  // remove the "split" original
  //
   fromStart = aRange.location == 0;
   toEnd     = aRange.length == [self length];

   i = 0;
   if( ! fromStart)
   {
      subRange.location = 0;
      subRange.length   = aRange.location;
      s[ i++]           = [self substringWithRange:NSMakeRange( 0, aRange.location)];
   }

   if( [replacement length])
      s[ i++] = replacement;

   if( ! toEnd)
   {
      subRange.location = aRange.location + aRange.length;
      subRange.length   = [self length] - subRange.location;
      s[ i++]           = [self substringWithRange:subRange];
   }
   
   shrinkWithStrings( self, s, i);
}

                       
// rrrong, if storage is smaller than prefix!
- (BOOL) hasPrefix:(NSString *) prefix
{
   NSUInteger   len_first;
   NSUInteger   len_prefix;   

   if( _count == 0)
      return( NO);

   len_prefix = [prefix length];
   len_first  = [_storage[ 0] length];
   if( len_prefix <= len_first)
      return( [_storage[ 0] hasPrefix:prefix]);

   return( [super hasPrefix:prefix]);
}


- (BOOL) hasSuffix:(NSString *) suffix
{
   NSUInteger   len_last;
   NSUInteger   len_suffix;
   
   if( _count == 0)
      return( NO);

   len_suffix = [suffix length];
   len_last   = [_storage[ _count - 1] length];
   if( len_suffix <= len_last)
      return( [_storage[ _count - 1] hasSuffix:suffix]);
   
   return( [super hasSuffix:suffix]);
}


- (NSUInteger) length
{
   return( _length);
}



//***************************************************
// LAYER 3 - generic CString support
//***************************************************
static NSUInteger   _NSStringGrabUTF8StringFromStrings( id *storage, unsigned int n,
                                                        mulle_utf8char_t *buf, size_t len,
                                                        NSRange range)
{
   NSRange        grab_range;
   NSRange        remaining_range;
   NSRange        vrange;
   NSString       *s;
   NSUInteger     buf_len;
   NSUInteger     vrange_total;
   mulle_utf8char_t       *p;
   id             *sentinel;
   size_t         remaining_buf_len;

   
   assert( len);
   
   // example input:
   //  storage = [ @"VfL", @"Bochum", @"1848" ]
   //  n = 3 
   //  range: { 2, 5 }
   //  len = 4
   //
   // example output:
   //  buf = [ 'L', 'B', 'o', 0 ]
   //  leftover = &{ 5, 2 }
   
   // end = indexof( 'u')
   
   remaining_range   = range;
   remaining_buf_len = len - 1; // adjust for trailing zero
   sentinel        = &storage[ n];
   p               = buf;
   
   //
   // 1) dial ahead to storage
   //
   //  ranges: { 0, 3 }, { 0, 6 },{ 0, 4 }
   //  vrange: { 0, 3 }, { 3, 6 },{ 9, 4 }
   //
   vrange       = NSMakeRange( 0, 0);
   vrange_total = 0;
   
   for(;;)
   {
      s = *storage++;
      
      vrange.location += vrange.length;        // add old
      vrange.length    = [s length];   
      vrange_total    += vrange.length;
      if( range.location < vrange_total)
         break;
      
      assert( storage < sentinel);
   }
   
   //   
   // 2) Now use as many string as necessary to fill up buffer
   //    or exhaust the range
   for(;;)
   {
      grab_range.location = remaining_range.location - vrange.location;
      grab_range.length   = remaining_range.length < vrange.length ? remaining_range.length : vrange.length;
      
      buf_len = [s getUTF8Characters:p
                           maxLength:remaining_buf_len + 1
                               range:grab_range];

      p                  = &p[ buf_len];
      remaining_buf_len -= buf_len;
      
      remaining_range.location += grab_range.length;
      remaining_range.length   -= grab_range.length;
      
      // possibly exhausted ?
      if( ! remaining_buf_len || ! remaining_range.length)
         return( p - buf);
      
      // dial to next
      s = *storage++;
      
      vrange.location += vrange.length;        // add old
      vrange.length    = [s length];   
      vrange_total    += vrange.length;

      assert( storage <= sentinel);
   }   
   return( 0);
}

- (mulle_utf8char_t *) UTF8String
{
   abort();
}


- (id) mutableCopy
{
   return( [[NSMutableString alloc] initWithStrings:_storage
                                              count:_count]);
}


@end

