/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSConstantString.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSConstantString.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSConstantString

+ (void) load
{
   struct _mulle_objc_runtime   *runtime;
   struct _mulle_objc_class     *cls;
   
   runtime = __get_or_create_objc_runtime();
   cls     = _mulle_objc_class_get_infraclass( (void *) self);
   assert( cls);
   _mulle_objc_runtime_set_staticstringclass( runtime, cls);
}


//
// weird shit: http://lists.apple.com/archives/objc-language/2006/Jan/msg00013.html
// 

- (mulle_utf8_t *) UTF8String
{
   return( (mulle_utf8_t *) _storage);
}


- (mulle_utf8_t *) _fastUTF8StringContents
{
   return( (mulle_utf8_t *) _storage);
}


- (NSUInteger) _UTF8StringLength
{
   return( _length);
}


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (NSUInteger) length
{
   return( _length);
}

@end


