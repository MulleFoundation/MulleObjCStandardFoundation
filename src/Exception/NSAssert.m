/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSAssertionHandler.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSAssert.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies
#include <stdlib.h>


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


static void   handleFailureInFunction( NSString *functionName,
                                       id object,
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


void   NSAssertionHandlerHandleMethodFailure( SEL sel,
                                              id obj,
                                              char *filename,
                                              int line,
                                              NSString *format, ...)
{
   va_list    args;
   NSString   *desc;
   
   va_start( args, format);
   desc = [NSString stringWithFormat:format
                             va_list:args];
   va_end( args);
   
   handleFailureInMethod( sel, obj, [NSString stringWithUTF8String:(mulle_utf8char_t *) filename], line, desc);
}


void   NSAssertionHandlerHandleFunctionFailure( char *function,
                                                char *filename,
                                                int line,
                                                NSString *format, ...)
{
   va_list    args;
   NSString   *desc;
   
   va_start( args, format);
   desc = [NSString stringWithFormat:format
                             va_list:args];
   va_end( args);
   
   failure( [NSString stringWithUTF8String:(mulle_utf8char_t *) function],
            [NSString stringWithUTF8String:(mulle_utf8char_t *) filename],
            line,
            desc);
}
