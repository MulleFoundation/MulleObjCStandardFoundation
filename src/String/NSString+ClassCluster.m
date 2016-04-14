//
//  NSString+ClassCluster.m
//  MulleObjCFoundation
//
//  Created by Nat! on 10.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString+ClassCluster.h"

// other files in this library
#import "_MulleObjCASCIIString.h"
#import "_MulleObjCUTF16String.h"
#import "_MulleObjCUTF32String.h"
#import "_MulleObjCEmptyString.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies
#include <mulle_sprintf/mulle_sprintf.h>


@implementation NSString (ClassCluster)

#pragma mark -
#pragma mark class cluster selection

static NSString  *newASCIIStringWithUTF8AndLength( char *s, NSUInteger length)
{
   // if we hit the length exactly then avoid adding extra 4 zero bytes
   // by using subclass. Diminishing returns with larger strings...
   switch( length)
   {
      case 00 : return( [[_MulleObjCEmptyString sharedInstance] retain]);
      case 03 : return( [_MulleObjC03LengthASCIIString newWithASCIICharacters:s
                                                                       length:length]);
      case 07 : return( [_MulleObjC07LengthASCIIString newWithASCIICharacters:s
                                                                       length:length]);
      case 11 : return( [_MulleObjC11LengthASCIIString newWithASCIICharacters:s
                                                                       length:length]);
      case 15 : return( [_MulleObjC15LengthASCIIString newWithASCIICharacters:s
                                                                       length:length]);
   }
   if( length < 0x100 + 1)
      return( [_MulleObjCTinyASCIIString newWithASCIICharacters:s
                                                         length:length]);
   return( [_MulleObjCGenericASCIIString newWithASCIICharacters:s
                                                         length:length]);
}


static NSString  *newASCIIStringWithUTF32AndLength( mulle_utf32char_t *s, NSUInteger length)
{
   // if we hit the length exactly then avoid adding extra 4 zero bytes
   // by using subclass. Diminishing returns with larger strings...
   switch( length)
   {
   case 00 : return( [[_MulleObjCEmptyString sharedInstance] retain]);
   case 03 : return( [_MulleObjC03LengthASCIIString newWithUTF32Characters:s
                                                                    length:length]);
   case 07 : return( [_MulleObjC07LengthASCIIString newWithUTF32Characters:s
                                                                    length:length]);
   case 11 : return( [_MulleObjC11LengthASCIIString newWithUTF32Characters:s
                                                                    length:length]);
   case 15 : return( [_MulleObjC15LengthASCIIString newWithUTF32Characters:s
                                                                    length:length]);
   }
   if( length < 0x100 + 1)
      return( [_MulleObjCTinyASCIIString newWithUTF32Characters:s
                                                         length:length]);
   return( [_MulleObjCGenericASCIIString newWithUTF32Characters:s
                                                         length:length]);
}


static NSString  *newUTF16StringWithUTF8AndLength( mulle_utf8char_t *s, NSUInteger length)
{
   struct mulle_buffer   buffer;
   NSUInteger            utf16len;
   mulle_utf16char_t     *utf16;
   
   assert( length);
   mulle_buffer_init( &buffer, MulleObjCAllocator());

   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf16char_t));
   mulle_utf8_convert_to_utf16_bytebuffer( &buffer, (void *) mulle_buffer_add_uint16, s, length);

   utf16len = mulle_buffer_get_length( &buffer) / 2;
   utf16    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCGenericUTF16String newWithUTF16Characters:utf16
                                                         length:length]);
}


static NSString  *newUTF16StringWithUTF32AndLength( mulle_utf32char_t *s, NSUInteger length)
{
   struct mulle_buffer   buffer;
   NSUInteger            utf16len;
   mulle_utf16char_t     *utf16;
   
   assert( length);
   mulle_buffer_init( &buffer, MulleObjCAllocator());
   
   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf16char_t));
   _mulle_utf32_convert_to_utf16_bytebuffer( &buffer, (void *) mulle_buffer_add_uint16, s, length);
   
   utf16len = mulle_buffer_get_length( &buffer) / sizeof( mulle_utf16char_t);
   utf16    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCGenericUTF16String newWithUTF16Characters:utf16
                                                         length:utf16len]);
}



static NSString  *newUTF32StringWithUTF8AndLength( mulle_utf8char_t *s, NSUInteger length)
{
   assert( length);
   struct mulle_buffer   buffer;
   NSUInteger            utf32len;
   mulle_utf32char_t     *utf32;
   
   assert( length);
   mulle_buffer_init( &buffer, MulleObjCAllocator());
   
   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf32char_t));
   mulle_utf8_convert_to_utf32_bytebuffer( &buffer, (void *) mulle_buffer_add_uint32, s, length);
   
   utf32len = mulle_buffer_get_length( &buffer) / sizeof( unichar);
   utf32    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCGenericUTF32String newWithUTF32Characters:utf32
                                                         length:utf32len]);
}


static NSString  *newUTF32StringWithUTF32AndLength( mulle_utf32char_t *s, NSUInteger length)
{
   assert( length);
   return( [_MulleObjCGenericUTF32String newWithUTF32Characters:s
                                                         length:length]);
}


static NSString  *newWithUTF8Characters( mulle_utf8char_t *buf, NSUInteger len)
{
   struct mulle_utf8_information  info;
   
   if( mulle_utf8_information( buf, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");

   if( info.utf32len == info.utf8len)
      return( newASCIIStringWithUTF8AndLength( (char *) buf, info.utf8len));

   if( info.utf32len == info.utf16len)
      return( newUTF16StringWithUTF8AndLength( buf, info.utf16len));

   return( newUTF32StringWithUTF8AndLength( buf, info.utf32len));
}


static NSString  *newWithUTF32Characters( mulle_utf32char_t *buf, NSUInteger len)
{
   struct mulle_utf32_information  info;
   
   if( mulle_utf32_information( buf, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF32");

   if( info.utf32len == info.utf8len)
      return( newASCIIStringWithUTF32AndLength( buf, info.utf8len));

   if( info.utf32len == info.utf16len)
      return( newUTF16StringWithUTF32AndLength( buf, info.utf16len));

   return( newUTF32StringWithUTF32AndLength( buf, info.utf32len));
}


#pragma mark -
#pragma mark class cluster init


- (id) initWithUTF8String:(mulle_utf8char_t *) s
{
   [self autorelease];
   return( (id) newWithUTF8Characters( s, mulle_utf8_strlen( s)));
}


- (id) initWithUTF8Characters:(mulle_utf8char_t *) s
                       length:(NSUInteger) len
{
   [self autorelease];
   return( (id) newWithUTF8Characters( s, len));
}



- (id) initWithCharacters:(unichar *) s
                   length:(NSUInteger) len
{
   [self autorelease];
   return( (id) newWithUTF32Characters( s, len));
}


- (id) initWithUTF8CharactersNoCopy:(mulle_utf8char_t *) s
                             length:(NSUInteger) length
                          allocator:(struct mulle_allocator *) allocator;
{
   struct mulle_utf8_information  info;
   struct mulle_buffer            buffer;
   void                           *utf;
   
   [self autorelease];

   if( mulle_utf8_information( s, length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");
   
   if( info.utf8len == info.utf32len)
      return( [_MulleObjCAllocatorASCIIString newWithASCIICharactersNoCopy:(char *) s
                                                                    length:info.utf8len
                                                                 allocator:allocator]);
   
   // need to copy it, because it's not ASCII
   
   mulle_buffer_init( &buffer, MulleObjCObjectGetAllocator( self));
   
   // convert it to UTF16
   // make it a regular string
   if( info.utf16len == info.utf32len)
   {
      mulle_utf8_convert_to_utf16_bytebuffer( &buffer, (void *) mulle_buffer_advance, s, length);
      assert( info.utf16len == mulle_buffer_get_length( &buffer) / sizeof( mulle_utf16char_t));
      // add trailing zero
      mulle_buffer_add_uint16( &buffer, 0);
   }
   else
   {
      mulle_utf8_convert_to_utf32_bytebuffer( &buffer, (void *) mulle_buffer_advance, s, length);
      assert( info.utf32len == mulle_buffer_get_length( &buffer) / sizeof( mulle_utf32char_t));
      // add trailing zero
      mulle_buffer_add_uint32( &buffer, 0);
   }
   
   // DELETE! s now, because otherwise we leak
   if( allocator)
      mulle_allocator_free( allocator, s);
   
   allocator = mulle_buffer_get_allocator( &buffer);
   utf      = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   if( info.utf16len == info.utf32len)
      return( [_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:utf
                                                                length:info.utf16len
                                                             allocator:allocator]);
   return( [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:utf
                                                                 length:info.utf32len
                                                              allocator:allocator]);
}

@end
