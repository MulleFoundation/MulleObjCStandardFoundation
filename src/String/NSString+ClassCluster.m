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


static NSString  *newASCIIStringWithUTF32AndLength( mulle_utf32_t *s, NSUInteger length)
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


static NSString  *newUTF16StringWithUTF8AndLength( mulle_utf8_t *s, NSUInteger length)
{
   struct mulle_buffer   buffer;
   NSUInteger            utf16len;
   mulle_utf16_t     *utf16;
   
   assert( length);
   mulle_buffer_init( &buffer, MulleObjCAllocator());

   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf16_t));
   mulle_utf8_convert_to_utf16_bytebuffer( &buffer, (void *) mulle_buffer_add_uint16, s, length);

   utf16len = mulle_buffer_get_length( &buffer) / 2;
   utf16    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCGenericUTF16String newWithUTF16Characters:utf16
                                                         length:utf16len]);
}


static NSString  *newUTF16StringWithUTF32AndLength( mulle_utf32_t *s, NSUInteger length)
{
   struct mulle_buffer   buffer;
   NSUInteger            utf16len;
   mulle_utf16_t     *utf16;
   
   assert( length);
   mulle_buffer_init( &buffer, MulleObjCAllocator());
   
   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf16_t));
   _mulle_utf32_convert_to_utf16_bytebuffer( &buffer, (void *) mulle_buffer_add_uint16, s, length);
   
   utf16len = mulle_buffer_get_length( &buffer) / sizeof( mulle_utf16_t);
   utf16    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCGenericUTF16String newWithUTF16Characters:utf16
                                                         length:utf16len]);
}



static NSString  *newUTF32StringWithUTF8AndLength( mulle_utf8_t *s, NSUInteger length)
{
   assert( length);
   struct mulle_buffer   buffer;
   NSUInteger            utf32len;
   mulle_utf32_t     *utf32;
   
   assert( length);
   mulle_buffer_init( &buffer, MulleObjCAllocator());
   
   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf32_t));
   mulle_utf8_convert_to_utf32_bytebuffer( &buffer, (void *) mulle_buffer_add_uint32, s, length);
   
   utf32len = mulle_buffer_get_length( &buffer) / sizeof( unichar);
   utf32    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCGenericUTF32String newWithUTF32Characters:utf32
                                                         length:utf32len]);
}


static NSString  *newUTF32StringWithUTF32AndLength( mulle_utf32_t *s, NSUInteger length)
{
   assert( length);
   return( [_MulleObjCGenericUTF32String newWithUTF32Characters:s
                                                         length:length]);
}


static NSString  *newWithUTF8Characters( mulle_utf8_t *buf, NSUInteger len)
{
   struct mulle_utf8_information  info;
   
   if( mulle_utf8_information( buf, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");

   if( info.utf32len == info.utf8len)
      return( newASCIIStringWithUTF8AndLength( (char *) info.start, info.utf8len));

   if( info.utf32len == info.utf16len)
      return( newUTF16StringWithUTF8AndLength( info.start, info.utf8len));

   return( newUTF32StringWithUTF8AndLength( info.start, info.utf8len));
}


static NSString  *newWithUTF32Characters( mulle_utf32_t *buf, NSUInteger len)
{
   struct mulle_utf32_information  info;
   
   if( mulle_utf32_information( buf, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF32");

   if( info.utf32len == info.utf8len)
      return( newASCIIStringWithUTF32AndLength( info.start, info.utf32len));

   if( info.utf32len == info.utf16len)
      return( newUTF16StringWithUTF32AndLength( info.start, info.utf32len));

   return( newUTF32StringWithUTF32AndLength( info.start, info.utf32len));
}


#pragma mark -
#pragma mark class cluster init


- (id) initWithUTF8String:(mulle_utf8_t *) s
{
   [self release];
   return( (id) newWithUTF8Characters( s, mulle_utf8_strlen( s)));
}


- (id) initWithUTF8Characters:(mulle_utf8_t *) s
                       length:(NSUInteger) len
{
   [self release];
   return( (id) newWithUTF8Characters( s, len));
}



- (id) initWithCharacters:(unichar *) s
                   length:(NSUInteger) len
{
   [self release];
   return( (id) newWithUTF32Characters( s, len));
}


- (id) _initWithCharactersNoCopy:(unichar *) s
                          length:(NSUInteger) length
                       allocator:(struct mulle_allocator *) allocator
{
   struct mulle_utf32_information   info;
   
   if( mulle_utf32_information( s, length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");
   
   [self release];

   return( [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:s
                                                         length:length
                                                   allocator:allocator]);
}


- (instancetype) initWithCharactersNoCopy:(unichar *) chars
                                   length:(NSUInteger) length
                             freeWhenDone:(BOOL) flag
{
   struct mulle_allocator   *allocator;
   
   allocator = flag ? &mulle_stdlib_allocator : NULL;
   return( [self _initWithCharactersNoCopy:chars
                                    length:length
                                 allocator:allocator]);
}


- (id) _initWithNonASCIIUTF8Characters:(mulle_utf8_t *) s
                                length:(NSUInteger) length
                              userInfo:(void *) userInfo
{
   struct mulle_utf8_information  *info;
   struct mulle_utf8_information  _info;
   struct mulle_buffer            buffer;
   void                           *utf;
   struct mulle_allocator         *allocator;
   
   info = userInfo;
   if( ! info)
   {
      info = &_info;
      if( mulle_utf8_information( s, length, info))
         MulleObjCThrowInvalidArgumentException( @"invalid UTF8");
   }
   
   // need to copy it, because it's not ASCII
   
   mulle_buffer_init( &buffer, MulleObjCObjectGetAllocator( self));
   
   // convert it to UTF16
   // make it a regular string
   if( info->utf16len == info->utf32len)
   {
      mulle_utf8_convert_to_utf16_bytebuffer( &buffer, (void *) mulle_buffer_advance, s, length);
      assert( info->utf16len == mulle_buffer_get_length( &buffer) / sizeof( mulle_utf16_t));
      // add trailing zero
   }
   else
   {
      mulle_utf8_convert_to_utf32_bytebuffer( &buffer, (void *) mulle_buffer_advance, s, length);
      assert( info->utf32len == mulle_buffer_get_length( &buffer) / sizeof( mulle_utf32_t));
      // add trailing zero
   }
   
   allocator = mulle_buffer_get_allocator( &buffer);
   utf      = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   [self release];

   if( info->utf16len == info->utf32len)
      return( [_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:utf
                                                                    length:info->utf16len
                                                                 allocator:allocator]);
   return( [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:utf
                                                                 length:info->utf32len
                                                              allocator:allocator]);
}

- (id) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                              length:(NSUInteger) length
                           allocator:(struct mulle_allocator *) allocator
{
   struct mulle_utf8_information  info;
   id                             obj;
   

   if( mulle_utf8_information( s, length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");
   
   if( info.utf8len == info.utf32len)
   {
      [self release];
      return( [_MulleObjCAllocatorASCIIString newWithASCIICharactersNoCopy:(char *) s
                                                                    length:info.utf8len
                                                                 allocator:allocator]);
   }
   
   obj = [self _initWithNonASCIIUTF8Characters:s
                                        length:length
                                      userInfo:&info];
   
   // free it, because we don't use it
   if( allocator)
      mulle_allocator_free( allocator, s);
   
   return( obj);
}


- (instancetype) initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                       length:(NSUInteger) length
                                 freeWhenDone:(BOOL) flag;
{
   struct mulle_allocator   *allocator;
   
   allocator = flag ? &mulle_stdlib_allocator : NULL;
   return( [self _initWithUTF8CharactersNoCopy:s
                                        length:length
                                     allocator:allocator]);
}


- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                        length:(NSUInteger) length
                                 sharingObject:(id) object
{
   struct mulle_utf8_information  info;

   if( mulle_utf8_information( s, length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");
   
   if( info.utf8len == info.utf32len)
   {
      [self release];
      return( [_MulleObjCSharedASCIIString newWithASCIICharactersNoCopy:(char *) s
                                                                 length:info.utf8len
                                                          sharingObject:object]);
   }
   
   return( [self _initWithNonASCIIUTF8Characters:s
                                          length:length
                                        userInfo:&info]);

}


- (instancetype) _initWithCharactersNoCopy:(unichar *) s
                                    length:(NSUInteger) length
                             sharingObject:(id) object
{
   [self release];
   return( [_MulleObjCSharedUTF32String newWithUTF32CharactersNoCopy:s
                                                              length:length
                                                       sharingObject:object]);
}
@end
