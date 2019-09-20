//
//  _MulleObjCCheatingASCIIString.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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
#import "_MulleObjCASCIIString.h"

#import "_MulleObjCCheatingASCIIString.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation _MulleObjCCheatingASCIIString


+ (instancetype) alloc       { abort(); }
- (void) dealloc             { abort(); }
- (instancetype) autorelease { abort(); }
- (instancetype) retain      { abort(); }
- (void) release             { abort(); }

//
// the only way to keep a cheating string
//
NSString  *MulleObjCNewASCIIStringWithASCIICharacters( char *s, NSUInteger length);

- (id) copy
{
   return( MulleObjCNewASCIIStringWithASCIICharacters( _storage, _length));
}


// cheating string can't use shadow
- (char *) UTF8String
{
   struct mulle_buffer      buffer;
   struct mulle_allocator   *allocator;
   char                     *s;

   allocator = MulleObjCObjectGetAllocator( self);

   mulle_buffer_init( &buffer, allocator);
   mulle_buffer_add_bytes( &buffer, _storage, _length);
   mulle_buffer_add_byte( &buffer, 0);
   s = mulle_buffer_extract_all( &buffer);
   mulle_buffer_done( &buffer);

   MulleObjCAutoreleaseAllocation( s, allocator);

   return( s);
}

@end
