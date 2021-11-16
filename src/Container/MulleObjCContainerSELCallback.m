//
//  MulleObjCContainerCallback.m
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
#import "import.h"

#import "MulleObjCContainerSELCallback.h"

#import "import-private.h"



static uintptr_t   sel_hash( struct mulle_container_keycallback *callback, void *p)
{
   return( (uintptr_t) p);
}


static char *
   sel_describe( struct mulle_container_valuecallback *callback,
                 void *p,
                 struct mulle_allocator **p_allocator)
{
   *p_allocator = NULL;
   return( MulleObjCSelectorGetNameUTF8String( (SEL) (NSInteger) p));
}



struct mulle_container_keycallback   MulleSELMapKeyCallBacks =
{
   sel_hash,
   mulle_container_keycallback_pointer_is_equal,
   mulle_container_keycallback_self,
   mulle_container_keycallback_nop,
   (mulle_container_keycallback_describe_t *) sel_describe,
   0,
   NULL
};


struct mulle_container_valuecallback   MulleSELMapValueCallBacks =
{
   mulle_container_valuecallback_self,
   mulle_container_valuecallback_nop,
   sel_describe,
   NULL
};

