/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  MulleObjCUTF8StringPlaceholder.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCStringPlaceholder.h"

// other files in this library
#import "_MulleObjCASCIIString.h"
#import "_MulleObjCUTF16String.h"
#import "_MulleObjCUTF32String.h"
#import "_MulleObjCEmptyString.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies
#include <mulle_sprintf/mulle_sprintf.h>



@implementation _MulleObjStringPlaceholder

static Class  ASCIIStringClassWithLength(NSUInteger length)
{
   // if we hit the length exactly then avoid adding extra 4 zero bytes
   // by using subclass. Diminishing returns with larger strings...
   switch( length)
   {
   case 00 : return( [_MulleObjCEmptyString class]);
   case 03 : return( [_MulleObjC03LengthASCIIString class]);
   case 07 : return( [_MulleObjC07LengthASCIIString class]);
   case 11 : return( [_MulleObjC11LengthASCIIString class]);
   case 15 : return( [_MulleObjC15LengthASCIIString class]);
   }
   if( length < 0x100 + 1)
      return( [_MulleObjCTinyASCIIString class]);
   return( [_MulleObjCGenericASCIIString class]);
}


static Class  UTF16StringClassWithLength( NSUInteger length)
{
   assert( length);
   return( [_MulleObjCGenericUTF16String class]);
}


static Class   UTF32StringClassWithLength( NSUInteger length)
{
   assert( length);
   return( [_MulleObjCGenericUTF32String class]);
}


static NSString  *stringWithUTF8CharactersAndInfo( utf8char *buf, struct mulle_utf8_information *info)
{
   Class        cls;
   NSUInteger   len;
   
   if( info->utf32len == info->utf8len)
   {
      len = info->utf8len;
      cls = ASCIIStringClassWithLength( len);
   }
   else
      if( info->utf32len == info->utf16len)
      {
         len = info->utf16len;
         cls = UTF16StringClassWithLength( len);
      }
      else
      {
         len = info->utf32len;
         cls = UTF32StringClassWithLength( len);
      }

  return( [cls stringWithUTF8Characters:buf
                                 length:len]);
}


static NSString  *stringWithUTF8Characters( utf8char *buf, NSUInteger len)
{
   struct mulle_utf8_information  info;
   
   if( mulle_utf8_information( buf, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");
   return( stringWithUTF8CharactersAndInfo( buf, &info));
}


static NSString  *stringWithUTF32Characters( utf32char *buf, NSUInteger len)
{
   struct mulle_utf32_information  info;
   Class                           cls;
   
   if( mulle_utf32_information( buf, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF32");

   if( info.utf32len == info.utf8len)
   {
      len = info.utf8len;
      cls = ASCIIStringClassWithLength( len);
   }
   else
      if( info.utf32len == info.utf16len)
      {
         len = info.utf16len;
         cls = UTF16StringClassWithLength( len);
      }
      else
      {
         len = info.utf32len;
         cls = UTF32StringClassWithLength( len);
      }

  return( [cls stringWithUTF32Characters:buf
                                  length:len]);
}



- (id) initWithUTF8String:(utf8char *) s
{
   return( (id) stringWithUTF8Characters( s, mulle_utf8_strlen( s)));
}


- (id) initWithUTF8Characters:(utf8char *) s
                       length:(NSUInteger) len
{
   return( (id) stringWithUTF8Characters( s, len));
}



- (id) initWithCharacters:(unichar *) s
                   length:(NSUInteger) len
{
   return( (id) stringWithUTF32Characters( s, len));
}


- (id) initWithUTF8String:(utf8char *) s
                   length:(NSUInteger) len
             freeWhenDone:(BOOL) flag
{
   struct mulle_utf8_information  info;
   id                             obj;
   
   if( mulle_utf8_information( s, len, &info))
      MulleObjCThrowInvalidArgumentException( @"invalid UTF8");
   
   if( ! flag)
      return( (id) stringWithUTF8CharactersAndInfo( s, &info));
   
   if( info.utf8len == info.utf32len || ! info.has_terminating_zero)
   {
      obj = stringWithUTF8CharactersAndInfo( s, &info);
      MulleObjCDeallocateMemory( s);
      return( obj);
   }
   
   return( [_MulleObjCReferencingASCIIString stringWithASCIIString:(char *) s
                                                            length:info.utf8len]);
}



- (id) initWithFormat:(NSString *) format
            arguments:(mulle_vararg_list) arguments
{
   utf8char                 *c_format;
   utf8char                 *result;
   struct mulle_buffer      buffer;
   struct mulle_allocator   *allocator;
   size_t                   len;
   NSString                 *s;

   c_format  = [format UTF8string];
   allocator = MulleObjCAllocator();
   
   mulle_buffer_init( &buffer, allocator);
   if( mulle_mvsprintf( &buffer, c_format, arguments) < 0)
   {
      [self autorelease];
      return( nil);
   }
   
   // check if buffer need't malloc
   len = _mulle_buffer_get_static_bytes_length( &buffer);
   if( len)
   {
      result = mulle_buffer_extract( &buffer);
      s      = [self initWithUTF8String:result
                                 length:len];
   }
   else
   {
      result = mulle_buffer_extract( &buffer);
      s      = [self initWithUTF8String:result
                                 length:-1
                              allocator:allocator];
   }
   mulle_buffer_done( &buffer);
   return( s);
}


- (id) initWithFormat:(NSString *) format
              va_list:(va_list) va_list
{
   utf8char                 *c_format;
   utf8char                 *result;
   struct mulle_buffer      buffer;
   struct mulle_allocator   *allocator;
   size_t                   len;
   NSString                 *s;
   
   c_format  = [format UTF8string];
   allocator = MulleObjCAllocator();
   
   mulle_buffer_init( &buffer, allocator);
   if( mulle_vsprintf( &buffer, c_format, va_list) < 0)
   {
      [self autorelease];
      return( nil);
   }
   
   // check if buffer need't malloc
   len = _mulle_buffer_get_static_bytes_length( &buffer);
   if( len)
   {
      result = mulle_buffer_extract( &buffer);
      s      = [self initWithUTF8String:result
                                 length:len];
   }
   else
   {
      result = mulle_buffer_extract( &buffer);
      s      = [self initWithUTF8String:result
                                 length:-1
                              allocator:allocator];
   }
   mulle_buffer_done( &buffer);
   return( s);
}


            
- (id) initWithString:(NSString *) other
{
   utf8char    *s;

   s = [other UTF8String];
   return( [self initWithUTF8String:s]);
}

@end
