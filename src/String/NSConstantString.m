/*
 *  MulleFoundation - the mulle-objc class library
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
   
   cls     = self;
   runtime = _mulle_objc_class_get_runtime( cls);
   _mulle_objc_runtime_set_staticstringclass( runtime, cls);
}


//
//  http://lists.apple.com/archives/objc-language/2006/Jan/msg00013.html
// 

- (mulle_utf8_t *) UTF8String
{
   return( (mulle_utf8_t *) _storage);
}


- (mulle_utf8_t *) _fastUTF8Characters
{
   return( (mulle_utf8_t *) _storage);
}


- (NSUInteger) _UTF8StringLength
{
   return( _length);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (NSUInteger) length
{
   return( _length);
}


- (id) retain       {  return( self); }
- (void) release    { }
- (id) autorelease  { return( self); }
- (void) dealloc
{
   assert( 0 && "deallocing a NSConstantString ???");
}
@end


