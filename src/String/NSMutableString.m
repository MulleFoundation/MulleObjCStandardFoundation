/*
 *  MulleFoundation - the mulle-objc class library
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


@implementation NSObject( _NSMutableString)

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


static void  flush_shadow( NSMutableString *self)
{
   MulleObjCObjectDeallocateMemory( self, self->_shadow);
   self->_shadow = NULL;
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

 
static void   sizeStorageWithCount( NSMutableString *self, unsigned int count)
{
   self->_size = count + count;
   if( self->_size < 4)
      self->_size = 4;

   self->_storage = MulleObjCObjectReallocateNonZeroedMemory( self,  self->_storage, self->_size * sizeof( NSString *));
}


static void   copyStringsAndComputeLength( NSMutableString *self, NSString **strings, unsigned int count)
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

 
static void   initWithStrings( NSMutableString *self, NSString **strings, unsigned int count)
{
   sizeStorageWithCount( self, count);
   copyStringsAndComputeLength( self, strings, count);
}


static void   shrinkWithStrings( NSMutableString *self, NSString **strings, unsigned int count)
{
   autoreleaseStorageStrings( self);
   flush_shadow( self);

   if( count > self->_size || count < self->_size / 4)
      sizeStorageWithCount( self, count);
   
   copyStringsAndComputeLength( self, strings, count);
}


- (id) initWithCapacity:(NSUInteger) n
{
   sizeStorageWithCount( self, (unsigned int) (n >> 1));
   return( self);
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
      initWithStrings( self, strings, (unsigned int) count);
   return( self);
}


#pragma mark -
#pragma mark tedious code for all these NSString init calls


// need to implement all MulleObjCCStringPlaceholder does
- (id) initWithFormat:(NSString *) format
            arguments:(mulle_vararg_list) arguments
{
   NSString  *s;
   s = [[NSString alloc] initWithFormat:format
                              arguments:arguments];
   if( ! s)
   {
      [self release];
      return( nil);
   }

   initWithStrings( self, &s, 1);
   [s release];
   return( self);
}


- (instancetype) _initWithUTF8Characters:(mulle_utf8_t *) chars
                                  length:(NSUInteger) length
{
   NSString  *s;
   
   s = [[NSString alloc] _initWithUTF8Characters:chars
                                          length:length];
   if( ! s)
   {
      [self release];
      return( nil);
   }
   
   initWithStrings( self, &s, 1);
   [s release];
   
   return( self);
}


- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) chars
                                        length:(NSUInteger) length
                                  freeWhenDone:(BOOL) flag
{
   NSString  *s;
   
   s = [[NSString alloc] _initWithUTF8CharactersNoCopy:chars
                                                length:length
                                          freeWhenDone:flag];
   if( ! s)
   {
      [self release];
      return( nil);
   }
   
   initWithStrings( self, &s, 1);
   [s release];
   
   return( self);
}


- (instancetype) _initWithCharactersNoCopy:(unichar *) chars
                                    length:(NSUInteger) length
                                 allocator:(struct mulle_allocator *) allocator
{
   NSString  *s;
   
   s = [[NSString alloc] _initWithCharactersNoCopy:chars
                                            length:length
                                         allocator:allocator];
   if( ! s)
   {
      [self release];
      return( nil);
   }
   
   initWithStrings( self, &s, 1);
   [s release];
   
   return( self);
}


- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) chars
                                        length:(NSUInteger) length
                                     allocator:(struct mulle_allocator *) allocator
{
   NSString  *s;
   
   s = [[NSString alloc] _initWithUTF8CharactersNoCopy:chars
                                                length:length
                                          allocator:allocator];
   if( ! s)
   {
      [self release];
      return( nil);
   }
   
   initWithStrings( self, &s, 1);
   [s release];
   
   return( self);
}


- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) chars
                                        length:(NSUInteger) length
                                 sharingObject:(id) object
{
   NSString  *s;
   
   s = [[NSString alloc] _initWithUTF8CharactersNoCopy:chars
                                                length:length
                                         sharingObject:object];
   if( ! s)
   {
      [self release];
      return( nil);
   }
   
   initWithStrings( self, &s, 1);
   [s release];
   
   return( self);
}


- (instancetype) _initWithCharactersNoCopy:(unichar *) chars
                                    length:(NSUInteger) length
                             sharingObject:(id) object
{
   NSString  *s;
   
   s = [[NSString alloc] _initWithCharactersNoCopy:chars
                                            length:length
                                     sharingObject:object];
   if( ! s)
   {
      [self release];
      return( nil);
   }
   
   initWithStrings( self, &s, 1);
   [s release];
   
   return( self);
}


#pragma mark -
#pragma mark - additional convenience constructors

+ (id) stringWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


- (void) dealloc
{
   MulleObjCMakeObjectsPerformRelease( _storage, _count);

   flush_shadow( self);

   MulleObjCObjectDeallocateMemory( self, self->_storage);
   [super dealloc];
}


#pragma mark -
#pragma mark NSCopying


- (id) copy
{
   mulle_utf8_t   *s;
   
   // ez and cheap copy, use it
   if( self->_count == 1)
      return( (id) [self->_storage[ 0] copy]);
   
   s = [self UTF8String];
   return( (id) [[NSString alloc] initWithUTF8String:s]);
}


#pragma mark -
#pragma mark NSString subclassing

- (NSUInteger) length
{
   return( _length);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   NSString     **p;
   NSString     **sentinel;
   NSUInteger   length;
   NSString     *s;
   
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   
   p        = &_storage[ 0];
   sentinel = &p[ _count];
   
   while( p < sentinel)
   {
      s      = *p++;
      length = [s length];
      if( index < length)
         break;
      
      index -= length;
   }
   return( [s characterAtIndex:index]);
}


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   NSString     **p;
   NSString     **sentinel;
   NSUInteger   length;
   NSString     *s;
   NSUInteger   grab_len;
   
   if( range.length + range.location > _length || range.length > _length)
      MulleObjCThrowInvalidRangeException( range);

   p        = &_storage[ 0];
   sentinel = &p[ _count];
   
   
   // `s` is first string with `length`
   // range is offset into s + remaining length
   
   while( range.length)
   {
      s      = *p++;
      length = [s length];

      if( range.location >= length)
      {
         range.location -= length;
         continue;
      }
   
      grab_len = range.length;
      if( grab_len > length)
         grab_len = length - range.location;
      
      [s getCharacters:buf
                 range:NSMakeRange( range.location, grab_len)];

      buf            = &buf[ grab_len];
      
      range.location = 0;
      range.length  -= grab_len;
   }
}


#pragma mark -
#pragma mark Operations

- (void) _reset
{
   shrinkWithStrings( self, NULL, 0);
}


- (void) appendString:(NSString *) s
{
   size_t   len;

   // more convenient really to allow nil
   len = [s length];
   if( ! len)
      return;
      
   if( _count >= _size)
   {
      _size += _size;
      if( _size < 8)
         _size = 8;
      _storage = MulleObjCObjectReallocateNonZeroedMemory( self, _storage, _size * sizeof( NSString *));
   }

   _storage[ _count++] = [s copy];
   _length            += len;

   flush_shadow( self);
}


- (void) appendFormat:(NSString *) format, ...
{
   NSString            *s;
   mulle_vararg_list   args;
   
   mulle_vararg_start( args, format);
   s = [NSString stringWithFormat:format
                        arguments:args];
   mulle_vararg_end( args);
   
   [self appendString:s];
}


- (void) setString:(NSString *) aString
{
   shrinkWithStrings( self, &aString, aString ? 1 : 0);
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
  // figure out range of substrings that fall in the range
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



- (void) replaceOccurrencesOfString:(NSString *) s
                         withString:(NSString *) replacement
                            options:(NSStringCompareOptions) options
                              range:(NSRange) range
{
   NSRange      found;
   NSUInteger   r_length;
   NSUInteger   end;

   if( range.length + range.location > _length || range.length > _length)
      MulleObjCThrowInvalidRangeException( range);
   
   r_length = [replacement length];
   options &= NSLiteralSearch|NSCaseInsensitiveSearch|NSNumericSearch;
   
   for(;;)
   {
      found = [self rangeOfString:s
                          options:options
                            range:range];
      if( ! found.length)
         return;
      
      [self replaceCharactersInRange:found
                          withString:replacement];

      // mover over to end for next check
      end             = range.location + range.length;
      range.location  = found.location + found.length;
      range.length    = end - range.location;

      // adjust for change in length due to replacement
      range.location += r_length - found.length;
   }
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


static void   mulleConvertStringsToUTF8( NSString **strings,
                                         unsigned int n,
                                         struct mulle_buffer *buffer)
{
   NSString       *s;
   mulle_utf8_t   *p;
   id             *sentinel;
   NSUInteger     len;
   
   sentinel = &strings[ n];
   while( strings < sentinel)
   {
      s   = *strings++;
      len = [s _UTF8StringLength];
      p   = mulle_buffer_advance( buffer, len);
      [s _getUTF8Characters:p
                 maxLength:len];
   }
   mulle_buffer_add_byte( buffer, 0);
}


- (void) _getUTF8Characters:(mulle_utf8_t *) buf
                  maxLength:(NSUInteger) maxLength
{
   NSString       *s;
   id             *sentinel;
   NSUInteger     len;
   NSString       **strings;
   
   strings  = _storage;
   sentinel = &strings[ _count];
   
   while( strings < sentinel)
   {
      s   = *strings++;
      len = [s _UTF8StringLength];
      if( len > maxLength)
         len = maxLength;
      
      [s _getUTF8Characters:buf
                  maxLength:len];

      buf        = &buf[ len];
      maxLength -= len;
      if( ! maxLength)
         break;
   }
}


- (NSUInteger) _UTF8StringLength
{
   if( ! _shadow)
      [self UTF8String];
   return( _shadowLen);
}


- (mulle_utf8_t *) UTF8String
{
   char                     tmp[ 0x400];
   struct mulle_allocator   *allocator;
   struct mulle_buffer      buffer;
   
   if( _shadow)
      return( _shadow);

   allocator = MulleObjCObjectGetAllocator( self);

   mulle_buffer_init_with_static_bytes( &buffer, tmp, sizeof( tmp), allocator);
   mulleConvertStringsToUTF8( _storage, _count, &buffer);

   mulle_buffer_size_to_fit( &buffer);
   _shadowLen = mulle_buffer_get_length( &buffer) - 1; // no trailin zero
   _shadow    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( _shadow);
}
   

- (id) mutableCopy
{
   return( [[NSMutableString alloc] initWithStrings:_storage
                                              count:_count]);
}

@end


# pragma mark -
# pragma mark ### NSString ( NSMutableString) ###
# pragma mark -

@implementation NSString ( NSMutableString)

- (id) mutableCopy
{
   return( [[NSMutableString alloc] initWithString:self]);
}

#pragma mark -
#pragma mark mutation constructors

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
   mulle_utf8_t    *buf;
   
   len = [self _UTF8StringLength];
   if( ! len)
      return( [[other copy] autorelease]);
      
   other_len = [other _UTF8StringLength];
   if( ! other_len)
      return( [[self copy] autorelease]);
      
   combined_len = len + other_len;
   buf          = MulleObjCObjectAllocateNonZeroedMemory( self, combined_len * sizeof( mulle_utf8_t));

   [self _getUTF8Characters:buf
                 maxLength:len];
   
   [other _getUTF8Characters:&buf[ len]
                  maxLength:other_len];

   s = [[[NSString alloc] _initWithUTF8CharactersNoCopy:buf
                                                 length:combined_len
                                              allocator:MulleObjCObjectGetAllocator( self)] autorelease];
   return( s);
}



- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) s
                                         withString:(NSString *) replacement
{
   NSMutableString   *copy;
   NSRange           found;
   
   found = [self rangeOfString:s];
   if( ! found.length)
      return( self);
   
   copy = [NSMutableString stringWithString:self];
   [copy replaceOccurrencesOfString:s
                         withString:replacement
                            options:NSLiteralSearch
                              range:NSMakeRange( 0, [copy length])];
   return( copy);
}


- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) s
                                         withString:(NSString *) replacement
                                            options:(NSUInteger) options
                                              range:(NSRange) range
{
   NSMutableString   *copy;
   NSRange           found;
   
   found = [self rangeOfString:s
                       options:options
                         range:range];
   if( ! found.length)
      return( self);
   
   copy = [NSMutableString stringWithString:self];
   [copy replaceOccurrencesOfString:s
                         withString:replacement
                            options:options
                              range:range];
   return( copy);
}
                                    

- (NSString *) stringByReplacingCharactersInRange:(NSRange) range
                                       withString:(NSString *) replacement
{
   NSMutableString   *copy;

   copy = [NSMutableString stringWithString:self];
   [copy replaceCharactersInRange:range
                         withString:replacement];
   return( copy);
}

@end


