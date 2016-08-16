//
//  NSString+Sprintf.m
//  MulleObjCFoundation
//
//  Created by Nat! on 09.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString+Sprintf.h"

// other files in this library
#import "NSString+ClassCluster.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCBaseFunctions.h"

// std-c and dependencies
#include <mulle_sprintf/mulle_sprintf.h>
#include <stdarg.h>


@implementation NSString (Sprintf)

+ (id) stringWithFormat:(NSString *) format
              arguments:(mulle_vararg_list) arguments
{
   return( [[[self alloc] initWithFormat:format
                               arguments:arguments] autorelease]);
}


+ (id) stringWithFormat:(NSString *) format
                va_list:(va_list) args
{
   return( [[[self alloc] initWithFormat:format
                                 va_list:args] autorelease]);
}

//
// Generic stuff for both NSString and NSMutableString
//
+ (id) stringWithFormat:(NSString *) format, ...
{
   NSString                  *s;
   mulle_vararg_list    args;
   
   mulle_vararg_start( args, format);
   s = [self stringWithFormat:format
                    arguments:args];
   mulle_vararg_end( args);
   return( s);
}


- (NSString *) stringByAppendingFormat:(NSString *) format, ...
{
   NSString             *s;
   mulle_vararg_list    args;
   
   mulle_vararg_start( args, format);
   s = [NSString stringWithFormat:format
                        arguments:args];
   mulle_vararg_end( args);
   
   return( [self stringByAppendingString:s]);
}


- (id) initWithFormat:(NSString *) format
            arguments:(mulle_vararg_list) arguments
{
   NSString                 *s;
   char                     *c_format;
   mulle_utf8_t             *result;
   size_t                   len;
   struct mulle_allocator   *allocator;
   struct mulle_buffer      buffer;
   auto char                space[ 512];
   
   if( ! format)
      MulleObjCThrowInvalidArgumentException( @"format is nil");
   
   c_format  = [format UTF8String];
   allocator = MulleObjCObjectGetAllocator( self);
   
   mulle_buffer_init_with_static_bytes( &buffer, space, sizeof( space), allocator);
   if( mulle_mvsprintf( &buffer, (char *) c_format, arguments) < 0)
   {
      mulle_buffer_done( &buffer);
      [self release];
      return( nil);
   }
   
   // check if buffer need't malloc
   len = mulle_buffer_get_static_bytes_length( &buffer);
   if( len)
   {
      result = mulle_buffer_get_bytes( &buffer);
      s      = [self _initWithUTF8Characters:result
                                     length:len];
   }
   else
   {
      len    = mulle_buffer_get_length( &buffer);
      result = mulle_buffer_extract_bytes( &buffer);
      s      = [self _initWithUTF8CharactersNoCopy:result
                                           length:len
                                        allocator:allocator];
   }
   mulle_buffer_done( &buffer);
   return( s);
}


- (id) initWithFormat:(NSString *) format
              va_list:(va_list) va_list
{
   char                     *c_format;
   mulle_utf8_t             *result;
   struct mulle_buffer      buffer;
   struct mulle_allocator   *allocator;
   size_t                   len;
   NSString                 *s;
   
   c_format  = [format UTF8String];
   allocator = MulleObjCObjectGetAllocator( self);
   
   mulle_buffer_init( &buffer, allocator);
   if( mulle_vsprintf( &buffer, (char *) c_format, va_list) < 0)
   {
      [self release];
      return( nil);
   }
   
   // check if buffer need't malloc
   len = mulle_buffer_get_static_bytes_length( &buffer);
   if( len)
   {
      result = mulle_buffer_get_bytes( &buffer);
      s      = [self _initWithUTF8Characters:result
                                      length:len];
   }
   else
   {
      len    = mulle_buffer_get_length( &buffer);
      result = mulle_buffer_extract_bytes( &buffer);
      s      = [self _initWithUTF8CharactersNoCopy:result
                                            length:len
                                         allocator:allocator];
   }
   mulle_buffer_done( &buffer);
   return( s);
}

@end
