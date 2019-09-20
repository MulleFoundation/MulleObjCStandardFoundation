//
//  NSString+Sprintf.m
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

#import "NSString+Sprintf.h"

// other files in this library
#import "NSString+ClassCluster.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"

// std-c and dependencies
#include <mulle-sprintf/mulle-sprintf.h>
#include <stdarg.h>


@implementation NSString (Sprintf)

+ (instancetype) stringWithFormat:(NSString *) format
                  mulleVarargList:(mulle_vararg_list) arguments
{
   return( [[[self alloc] initWithFormat:format
                         mulleVarargList:arguments] autorelease]);
}


+ (instancetype) stringWithFormat:(NSString *) format
                        arguments:(va_list) args
{
   return( [[[self alloc] initWithFormat:format
                                 arguments:args] autorelease]);
}

//
// Generic stuff for both NSString and NSMutableString
//
+ (instancetype) stringWithFormat:(NSString *) format, ...
{
   NSString                  *s;
   mulle_vararg_list    args;

   mulle_vararg_start( args, format);
   s = [self stringWithFormat:format
              mulleVarargList:args];
   mulle_vararg_end( args);
   return( s);
}


- (NSString *) stringByAppendingFormat:(NSString *) format, ...
{
   NSString             *s;
   mulle_vararg_list    args;

   mulle_vararg_start( args, format);
   s = [NSString stringWithFormat:format
                  mulleVarargList:args];
   mulle_vararg_end( args);

   return( [self stringByAppendingString:s]);
}


static id   string_from_buffer( NSString *self,
                                struct mulle_buffer *buffer,
                                struct mulle_allocator *allocator)
{
   size_t         len;
   mulle_utf8_t   *result;
   NSString       *s;

   // check if buffer needed to malloc
   len = mulle_buffer_get_staticlength( buffer);
   if( len)
   {
      result = mulle_buffer_get_bytes( buffer);
      s      = [self mulleInitWithUTF8Characters:result
                                      length:len];
   }
   else
   {
      len    = mulle_buffer_get_length( buffer);
      result = mulle_buffer_extract_all( buffer);
      s      = [self mulleInitWithUTF8CharactersNoCopy:result
                                            length:len
                                         allocator:allocator];
   }
   mulle_buffer_done( buffer);
   return( s);
}


- (instancetype) initWithFormat:(NSString *) format
                mulleVarargList:(mulle_vararg_list) arguments
{
   char                     *c_format;
   struct mulle_allocator   *allocator;
   struct mulle_buffer      buffer;
   auto char                space[ 512];

   if( ! format)
      MulleObjCThrowInvalidArgumentException( @"format is nil");

   allocator = MulleObjCObjectGetAllocator( self);
   mulle_buffer_init_with_static_bytes( &buffer, space, sizeof( space), allocator);
   c_format  = [format UTF8String];
   if( mulle_mvsprintf( &buffer, (char *) c_format, arguments) < 0)
   {
      mulle_buffer_done( &buffer);
      [self release];
      return( nil);
   }

   return( string_from_buffer( self, &buffer, allocator));
}


- (instancetype) initWithFormat:(NSString *) format
                      arguments:(va_list) va_list
{
   char                     *c_format;
   struct mulle_buffer      buffer;
   struct mulle_allocator   *allocator;
   auto char                space[ 512];

   if( ! format)
      MulleObjCThrowInvalidArgumentException( @"format is nil");

   allocator = MulleObjCObjectGetAllocator( self);
   mulle_buffer_init_with_static_bytes( &buffer, space, sizeof( space), allocator);
   c_format  = [format UTF8String];
   if( mulle_vsprintf( &buffer, (char *) c_format, va_list) < 0)
   {
      mulle_buffer_done( &buffer);
      [self release];
      return( nil);
   }

   return( string_from_buffer( self, &buffer, allocator));
}


- (instancetype) initWithFormat:(NSString *) format, ...
{
   NSString                  *s;
   mulle_vararg_list    args;

   mulle_vararg_start( args, format);
   s = [self initWithFormat:format
              mulleVarargList:args];
   mulle_vararg_end( args);
   return( s);
}

@end
