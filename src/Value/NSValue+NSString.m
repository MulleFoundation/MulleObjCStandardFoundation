//
//  NSValue+NSString.m
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

#import "NSValue.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationString.h"

// std-c dependencies
#include <mulle_buffer/mulle_buffer.h>
#include <stdint.h>


@implementation NSValue (NSString)

- (NSString *) _debugContentsDescription
{
   struct mulle_buffer   buffer;
   char                  tmp[ 512];
   uint8_t               value[ 256];
   NSUInteger            size;
   NSString              *s;
   char                  *type;

   type = [self objCType];
   NSGetSizeAndAlignment( type, &size, NULL);
   if( size >= 256)
   {
      s = [NSString stringWithFormat:@"\"%s\" %ld bytes", type, size];
      return( s);
   }

   [self getValue:value];

   mulle_buffer_init_with_static_bytes( &buffer, tmp, sizeof( tmp), NULL);
   mulle_buffer_dump_hex( &buffer, value, size, 0, 0x5); // no counter. no ASCII
   mulle_buffer_add_byte( &buffer, 0);
   s = [NSString stringWithFormat:@"\"%s\" %s", type, mulle_buffer_get_bytes( &buffer)];
   mulle_buffer_done( &buffer);

   return( s);
}

@end
