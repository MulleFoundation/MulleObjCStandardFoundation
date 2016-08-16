//
//  NSString+ClassCluster.m
//  MulleObjCFoundation
//
//  Created by Nat! on 10.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString+ClassCluster.h"

// other files in this library
#import "_MulleObjCTaggedPointerChar5String.h"
#import "_MulleObjCTaggedPointerChar7String.h"
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


NSString  *MulleObjCNewASCIIStringWithASCIICharacters( char *s, NSUInteger length);

NSString  *MulleObjCNewASCIIStringWithASCIICharacters( char *s, NSUInteger length)
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


static NSString  *MulleObjCNewASCIIStringWithUTF32Characters( mulle_utf32_t *s, NSUInteger length)
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


static NSString  *MulleObjCNewUTF16StringWithUTF8Characters( mulle_utf8_t *s, NSUInteger length, struct mulle_allocator *allocator)
{
   struct mulle_buffer   buffer;
   NSUInteger            utf16len;
   mulle_utf16_t         *utf16;

   assert( length);
   mulle_buffer_init( &buffer, allocator);

   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf16_t));
   mulle_utf8_convert_to_utf16_bytebuffer( s,
                                           length,
                                           &buffer,
                                           (void (*)()) mulle_buffer_add_bytes);

   utf16len = mulle_buffer_get_length( &buffer) / 2;
   utf16    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:utf16
                                                                 length:utf16len
                                                              allocator:allocator]);
}


static NSString  *MulleObjCNewUTF16StringWithUTF32Characters( mulle_utf32_t *s, NSUInteger length, struct mulle_allocator   *allocator)
{
   NSUInteger            utf16len;
   mulle_utf16_t         *utf16;
   struct mulle_buffer   buffer;
   
   assert( length);
   mulle_buffer_init( &buffer, allocator);
   
   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf16_t));
   mulle_utf32_convert_to_utf16_bytebuffer( s,
                                            length,
                                            &buffer,
                                            (void (*)()) mulle_buffer_add_bytes);
   
   utf16len = mulle_buffer_get_length( &buffer) / sizeof( mulle_utf16_t);
   utf16    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:utf16
                                                                 length:utf16len
                                                              allocator:allocator]);
}


static NSString  *MulleObjCNewUTF32StringWithUTF8Characters( mulle_utf8_t *s, NSUInteger length, struct mulle_allocator   *allocator)
{
   struct mulle_buffer   buffer;
   NSUInteger            utf32len;
   mulle_utf32_t         *utf32;
   
   assert( length);
   assert( allocator);
   
   mulle_buffer_init( &buffer, allocator);
   
   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf32_t));
   mulle_utf8_convert_to_utf32_bytebuffer( s,
                                           length,
                                           &buffer,
                                           (void (*)()) mulle_buffer_add_bytes);
   
   utf32len = mulle_buffer_get_length( &buffer) / sizeof( unichar);
   utf32    = mulle_buffer_extract_bytes( &buffer);
   mulle_buffer_done( &buffer);
   
   return( [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:utf32
                                                                 length:utf32len
                                                              allocator:allocator]);
}


static NSString  *MulleObjCNewUTF32StringWithUTF32Characters( mulle_utf32_t *s, NSUInteger length)
{
   assert( length);
   return( [_MulleObjCGenericUTF32String newWithUTF32Characters:s
                                                         length:length]);
}


static NSString  *newStringWithUTF8Characters( mulle_utf8_t *buf, NSUInteger len, struct mulle_allocator   *allocator)
{
   struct mulle_utf_information  info;
   
   if( mulle_utf8_information( buf, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");

#ifndef MULLE_OBJC_NO_TAGGED_POINTERS
   if( info.is_ascii && info.utf8len <= mulle_char7_uintptr_max_length())
      return( MulleObjCTaggedPointerChar7StringWithASCIICharacters( (char *) info.start, info.utf8len));
   if( info.is_char5 && info.utf8len <= mulle_char5_uintptr_max_length())
      return( MulleObjCTaggedPointerChar5StringWithASCIICharacters( (char *) info.start, info.utf8len));
#endif
   
   if( info.is_ascii)
      return( MulleObjCNewASCIIStringWithASCIICharacters( (char *) info.start, info.utf8len));

   if( info.is_utf15)
      return( MulleObjCNewUTF16StringWithUTF8Characters( info.start, info.utf8len, allocator));

   return( MulleObjCNewUTF32StringWithUTF8Characters( info.start, info.utf8len, allocator));
}


static NSString  *newStringWithUTF32Characters( mulle_utf32_t *buf, NSUInteger len, struct mulle_allocator *allocator)
{
   struct mulle_utf_information  info;
   
   if( mulle_utf32_information( buf, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF32");

   if( info.is_ascii)
      return( MulleObjCNewASCIIStringWithUTF32Characters( info.start, info.utf32len));

   if( info.is_utf15)
      return( MulleObjCNewUTF16StringWithUTF32Characters( info.start, info.utf32len, allocator));

   return( MulleObjCNewUTF32StringWithUTF32Characters( info.start, info.utf32len));
}


#pragma mark -
#pragma mark class cluster init


- (id) initWithUTF8String:(char *) s
{
   struct mulle_allocator  *allocator;

   if( ! s)
      MulleObjCThrowInvalidArgumentException( @"argument must not be null");
   
   allocator = MulleObjCObjectGetAllocator( self);
   [self release];
   return( (id) newStringWithUTF8Characters( (mulle_utf8_t *) s, mulle_utf8_strlen( (mulle_utf8_t *) s), allocator));
}


- (id) _initWithUTF8Characters:(mulle_utf8_t *) s
                        length:(NSUInteger) len
{
   struct mulle_allocator  *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);
   [self release];
   return( (id) newStringWithUTF8Characters( s, len, allocator));
}



- (id) initWithCharacters:(unichar *) s
                   length:(NSUInteger) len
{
   struct mulle_allocator  *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);
   [self release];
   return( (id) newStringWithUTF32Characters( s, len, allocator));
}


- (id) _initWithCharactersNoCopy:(unichar *) s
                          length:(NSUInteger) length
                       allocator:(struct mulle_allocator *) allocator
{
   struct mulle_utf_information   info;
   
   if( mulle_utf32_information( s, length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF32");
   
   if( info.has_bom)
   {
      self = [self initWithCharacters:s
                               length:length];
      mulle_allocator_free( allocator, s);
      return( self);
   }
   
   [self release];
   return( [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:info.start
                                                                 length:info.utf32len
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
   struct mulle_utf_information  *info;
   struct mulle_utf_information  _info;
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
   
   
   if( ! info->utf8len)
   {
      [self release];
      return( [[_MulleObjCEmptyString sharedInstance] retain]);
   }
   
   
   // need to copy it, because it's not ASCII

   [self release];
   
   allocator = MulleObjCObjectGetAllocator( self);
   mulle_buffer_init( &buffer, allocator);

   
   // convert it to UTF16
   // make it a regular string
   if( info->is_utf15)
   {
      mulle_utf8_convert_to_utf16_bytebuffer( info->start,
                                              info->utf8len,
                                              &buffer,
                                              (void (*)()) mulle_buffer_add_bytes);
      assert( info->utf16len == mulle_buffer_get_length( &buffer) / sizeof( mulle_utf16_t));
      utf = mulle_buffer_extract_bytes( &buffer);

      self = [_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:utf
                                                                   length:info->utf16len
                                                                allocator:allocator];
   }
   else
   {
      mulle_utf8_convert_to_utf32_bytebuffer( info->start,
                                              info->utf8len,
                                              &buffer,
                                              (void (*)()) mulle_buffer_add_bytes);
      assert( info->utf32len == mulle_buffer_get_length( &buffer) / sizeof( mulle_utf32_t));
      utf = mulle_buffer_extract_bytes( &buffer);
   
      self = [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:utf
                                                                   length:info->utf32len
                                                                allocator:allocator];
   }
   
   mulle_buffer_done( &buffer);
   return( self);
}

- (id) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                              length:(NSUInteger) length
                           allocator:(struct mulle_allocator *) allocator
{
   struct mulle_utf_information  info;
   id                            obj;
   
   assert( length <= NSIntegerMax);
   
   if( mulle_utf8_information( s, length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");

   obj = [self _initWithNonASCIIUTF8Characters:info.start
                                        length:info.utf8len
                                      userInfo:&info];
   
   // free it, because we don't use it
   if( allocator)
      mulle_allocator_free( allocator, s);
   
   return( obj);
}


- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
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
   struct mulle_utf_information  info;

   if( mulle_utf8_information( s, length, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");
   
   return( [self _initWithNonASCIIUTF8Characters:info.start
                                          length:info.utf8len
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
