//
//  NSAssertionHandler.m
//  MulleObjCFoundation
//
//  Created by Nat! on 23.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSAssertionHandler.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationString.h"

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


#pragma mark -
#pragma mark mechanics
//
// try to keep the output compatible with Mac OS X, although good grief
// it's not very telling... is it ?
//
static void   failure( NSString *name,
                       NSString *fileName, 
                       NSInteger line, 
                       NSString *desc)
{
   extern void  NSLog( NSString *format, ...);
   
   NSString   *s;
   
   s = [NSString stringWithFormat:@"*** Assertion failure in %@, %@:%ld",
         name, fileName, (long) line];
   
   if( [desc length])
      s = [NSString stringWithFormat:@"%@ %@", s, desc];
   
   NSLog( @"%@", s);
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
                           arguments:args];
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
                            arguments:args];
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
                            va_list:args];
   va_end( args);
   desc = [desc stringByReplacingOccurrencesOfString:@"%"
                                          withString:@"%%"];
   
   filename = [NSString stringWithUTF8String:(mulle_utf8_t *) file];
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
                             va_list:args];
   va_end( args);
   desc = [desc stringByReplacingOccurrencesOfString:@"%"
                                          withString:@"%%"];
   
   functionname = [NSString stringWithUTF8String:(mulle_utf8_t *) function];
   filename     = [NSString stringWithUTF8String:(mulle_utf8_t *) file];
   
   [[NSAssertionHandler currentHandler] handleFailureInFunction:functionname
                                                            file:filename
                                                      lineNumber:line
                                                     description:desc];
}

@end
