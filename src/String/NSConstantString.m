//
//  NSConstantString.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSString.h"

#import "NSConstantString.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies

#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation NSConstantString

#ifndef MULLE_OBJC_NO_TAGGED_POINTERS
+ (struct _mulle_objc_dependency *) dependencies
{
   static struct _mulle_objc_dependency   dependencies[] =
   {
      { @selector( _MulleObjCTaggedPointerChar7String), 0 },
      { @selector( _MulleObjCTaggedPointerChar5String), 0 },
      { @selector( NSThread), 0 },
      { 0, 0 }
   };
   return( dependencies);
}
#endif


+ (void) load
{
   struct _mulle_objc_universe   *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   _mulle_objc_universe_set_staticstringclass( universe, self);
}


//
//  http://lists.apple.com/archives/objc-language/2006/Jan/msg00013.html
//

- (char *) UTF8String
{
   return( _storage);
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


- (instancetype) retain       {  return( self); }
- (void) release              { }
- (instancetype) autorelease  { return( self); }
- (void) dealloc
{
   assert( 0 && "deallocing a NSConstantString ???");
}
@end
