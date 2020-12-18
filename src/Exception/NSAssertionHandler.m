//
//  NSAssertionHandler.m
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

#import "NSAssertionHandler.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "import.h"
#import "MulleObjCStandardContainerFoundation.h"
#import "MulleObjCStandardValueFoundation.h"

// std-c and dependencies


NSString  *NSAssertionHandlerKey = @"NSAssertionHandler";


@implementation NSAssertionHandler

+ (NSAssertionHandler *) currentHandler
{
   NSMutableDictionary   *dictionary;
   NSAssertionHandler    *handler;

   dictionary = [[NSThread currentThread] threadDictionary];
   handler = [dictionary objectForKey:NSAssertionHandlerKey];
   if( ! handler)
   {
      handler = [[self new] autorelease];
      [dictionary setObject:handler
                     forKey:NSAssertionHandlerKey];
   }
   return( handler);
}


#pragma mark - mechanics
//
// try to keep the output compatible with Mac OS X, although good grief
// it's not very telling... is it ?
//
static void   failure( NSString *name,
                       NSString *fileName,
                       NSInteger line,
                       NSString *desc)
{
   NSString   *s;

   s = [NSString stringWithFormat:@"*** Assertion failure in %@, %@:%ld",
         name, fileName, (long) line];

   if( [desc length])
      s = [NSString stringWithFormat:@"%@ %@", s, desc];

   fprintf( stderr, "%s\n", [s UTF8String]);
   abort();
}


static inline void   handleFailureInFunction( NSString *functionName,
                                              NSString *fileName,
                                              NSInteger line,
                                              NSString *desc)
{
   failure( functionName, fileName, line, desc);
}


static void  handleFailureInMethod( SEL selector,
                                    id object,
                                    NSString *fileName,
                                    NSInteger line,
                                    NSString *desc)
{
   NSString   *s;
   NSString   *selName;
   BOOL       flag;

   // test to see if object is a class
   flag    = [object respondsToSelector:@selector( instancesRespondToSelector:)];
   selName = NSStringFromSelector( selector);

   if( flag)
      s = [NSString stringWithFormat:@"+[%@ %@]", NSStringFromClass( object), selName];
   else
      s = [NSString stringWithFormat:@"-[%@ %@]", [object class], selName];

   failure( s, fileName, line, desc);
}



- (void) handleFailureInMethod:(SEL) sel
                        object:(id) obj
                          file:(NSString *) filename
                    lineNumber:(NSInteger) line
                   description:(NSString *) format, ...;
{
   mulle_vararg_list    args;
   NSString             *desc;

   mulle_vararg_start( args, format);

   desc = [NSString stringWithFormat:format
                     mulleVarargList:args];
   mulle_vararg_end( args);

   handleFailureInMethod( sel, obj, filename, line, desc);
}


- (void) handleFailureInFunction:(NSString *) functionname
                            file:(NSString *) filename
                      lineNumber:(NSInteger) line
                     description:(NSString *) format, ...
{
   mulle_vararg_list    args;
   NSString             *desc;

   mulle_vararg_start( args, format);

   desc = [NSString stringWithFormat:format
                     mulleVarargList:args];
   mulle_vararg_end( args);

   handleFailureInFunction( functionname, filename, line, desc);
}



void   NSAssertionHandlerHandleMethodFailure( SEL sel,
                                              id obj,
                                              char *file,
                                              int line,
                                              NSString *format, ...)
{
   va_list    args;
   NSString   *desc;
   NSString   *filename;

   va_start( args, format);

   desc = [NSString stringWithFormat:format
                             arguments:args];
   va_end( args);
   desc = [desc stringByReplacingOccurrencesOfString:@"%"
                                          withString:@"%%"];

   filename = [NSString stringWithUTF8String:file];
   [[NSAssertionHandler currentHandler] handleFailureInMethod:sel
                                                       object:obj
                                                         file:filename
                                                   lineNumber:line
                                                  description:desc];
}


void   NSAssertionHandlerHandleFunctionFailure( char *function,
                                                char *file,
                                                int line,
                                                NSString *format, ...)
{
   va_list    args;
   NSString   *desc;
   NSString   *filename;
   NSString   *functionname;

   va_start( args, format);
   desc = [NSString stringWithFormat:format
                             arguments:args];
   va_end( args);
   desc = [desc stringByReplacingOccurrencesOfString:@"%"
                                          withString:@"%%"];

   functionname = [NSString stringWithUTF8String:function];
   filename     = [NSString stringWithUTF8String:file];

   [[NSAssertionHandler currentHandler] handleFailureInFunction:functionname
                                                            file:filename
                                                      lineNumber:line
                                                     description:desc];
}

@end
