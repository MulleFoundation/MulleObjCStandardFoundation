//
//  _MulleObjCCheatingASCIIString.h
//  MulleObjCValueFoundation
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
#import "NSCharacterSet.h"

// Can't do this because it's private
// #import "_MulleObjCASCIIString.h"


@interface _MulleObjCCheatingASCIICharacterSet : NSCharacterSet <MulleObjCValueProtocols>
{
@public
   uint64_t   _bits[ 4]; // cheating actually does 256 bits (more like _MulleObjCCheatingByteCharacterSet)
   int        _invert;
}
@end


//
// the cheating ASCII String is used internally for "on stack" objects
// for these very special moments
//
struct _MulleObjCCheatingASCIICharacterSetStorage
{
   struct _mulle_objc_objectheader   _header;
   @defs( _MulleObjCCheatingASCIICharacterSet);
};



static inline id
   _MulleObjCCheatingASCIICharacterSetStorageGetObject( struct _MulleObjCCheatingASCIICharacterSetStorage *p)
{
   return( (id) _mulle_objc_objectheader_get_object( &p->_header));
}


static inline id
   _MulleObjCCheatingASCIICharacterSetStorageInit( struct _MulleObjCCheatingASCIICharacterSetStorage *storage,
                                                   char *characters,
                                                   NSUInteger length,
                                                   BOOL inverted)
{
   _MulleObjCCheatingASCIICharacterSet   *p;
   char                                  *sentinel;
   int                                   c;

   p = _MulleObjCCheatingASCIICharacterSetStorageGetObject( storage);

   MulleObjCInstanceSetClass( p, [_MulleObjCCheatingASCIICharacterSet class]);
   MulleObjCInstanceConstantify( p);
   MulleObjCInstanceSetThreadAffinity( p, mulle_thread_self());

   p->_bits[ 0] = 0;
   p->_bits[ 1] = 0;
   p->_bits[ 2] = 0;
   p->_bits[ 3] = 0;
   p->_invert   = inverted;

   sentinel = &characters[ (length == -1) ? strlen( characters) : length];
   while( characters < sentinel)
   {
      c = *characters++;
      assert( c >= 0 && c < 256);

      storage->_bits[ c >> 6] |= (1ULL << (c & 0x3F));
   }


   return( p);
}
