/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSException.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSException.h"

// other files in this library
#import "NSAssert.h"
#import "ns_foundationconfiguration.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies


NSString  *NSInternalInconsistencyException = @"NSInternalInconsistencyException";
NSString  *NSGenericException               = @"NSGenericException";
NSString  *NSInvalidArgumentException       = @"NSInvalidArgumentException";
NSString  *NSMallocException                = @"NSMallocException";
NSString  *NSRangeException                 = @"NSRangeException";
NSString  *MulleObjCErrnoException          = @"MulleObjCErrnoException";


static void   MulleObjCDefaultUncaughtExceptionHandler( NSException *exception);
static NSUncaughtExceptionHandler   *defaultUncaughtHandler = MulleObjCDefaultUncaughtExceptionHandler;


static void   MulleObjCDefaultUncaughtExceptionHandler( NSException *exception)
{
   extern void  NSLog( NSString *, ...);
   
   NSLog( @"uncaught exception %@ %@", [exception name], [exception reason]);
   abort();
}


NSUncaughtExceptionHandler * NSGetUncaughtExceptionHandler( void)
{
   return( defaultUncaughtHandler);
}


void   NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler *handler)
{
   if( ! handler)
      handler = MulleObjCDefaultUncaughtExceptionHandler;
   defaultUncaughtHandler = handler;
}



@implementation NSException

// TODO: localization hooks for exceptions ?
__attribute__ ((noreturn))
static void   mulle_objc_throw_malloc_exception( size_t bytes)
{
   [NSException raise:NSMallocException
               format:@"out of memory, when requesting %ld bytes", bytes];
}

__attribute__ ((noreturn))
static void   mulle_objc_throw_errno_exception( char *s)
{
   [NSException raise:MulleObjCErrnoException
               format:@"%s: %s", s, strerror( errno)];
}

__attribute__ ((noreturn))
static void   mulle_objc_throw_generic_exception( NSString *reason, NSString *format, va_list args)
{
   [NSException raise:NSMallocException
               format:format
               va_list:args];
}


__attribute__ ((noreturn))
static void   mulle_objc_throw_inconsistency_exception( id format, va_list args)
{
   mulle_objc_throw_generic_exception( NSInternalInconsistencyException, format, args);
}


__attribute__ ((noreturn))
static void   mulle_objc_throw_argument_exception( id format, va_list args)
{
   mulle_objc_throw_generic_exception( NSInvalidArgumentException, format, args);
}


__attribute__ ((noreturn))
static void   mulle_objc_throw_index_exception( NSUInteger index)
{
   [NSException raise:NSMallocException
               format:@"index %lu is out of range", (long) index];
}


__attribute__ ((noreturn))
static void   mulle_objc_throw_range_exception( NSRange arg)
{
   [NSException raise:NSRangeException
               format:@"range %lu.%lu doesn't fit", (long) arg.location, (long) arg.length];
}

    
static void  init_exceptionhandlertable ( struct _ns_exceptionhandlertable *table)
{
   table->errno_error            = mulle_objc_throw_errno_exception;
   table->allocation_error       = mulle_objc_throw_malloc_exception;
   table->invalid_argument       = mulle_objc_throw_argument_exception;
   table->internal_inconsistency = mulle_objc_throw_inconsistency_exception;
   table->invalid_index          = mulle_objc_throw_index_exception;
   table->invalid_range          = mulle_objc_throw_range_exception;
}


+ (void) initialize
{
   struct _ns_foundationconfiguration   *config;
   
   config = _ns_get_foundationconfiguration();
   init_exceptionhandlertable( &config->root.exception.vectors);
}

+ (NSException *) exceptionWithName:(NSString *) name
                             reason:(NSString *) reason
                           userInfo:(NSDictionary *) userInfo
{
   return( [[[self alloc] initWithName:name
                                reason:reason
                              userInfo:userInfo] autorelease]);
}


+ (void) raise:(NSString *) name
        format:(NSString *) format, ...
 {
   mulle_vararg_list   args;

   mulle_vararg_start( args, format );
   [self raise:name 
        format:format 
     arguments:args];
}


+ (void) raise:(NSString *) name
        format:(NSString *) format
       va_list:(va_list) args
{
   NSException   *exception;
   NSString      *reason;
   
   reason     = [NSString stringWithFormat:format
                                   va_list:args];
   exception  = [self exceptionWithName:name
                                 reason:reason
                               userInfo:nil];
   
   [exception raise];
}


+ (void) raise:(NSString *) name
        format:(NSString *) format
     arguments:(mulle_vararg_list) va
{
   NSException   *exception;
   NSString      *reason;
   
   reason     = [NSString stringWithFormat:format
                                 arguments:va];
   exception  = [self exceptionWithName:name
                                 reason:reason
                               userInfo:nil];
   
   [exception raise];
}


- (id) initWithName:(NSString *) name
             reason:(NSString *) reason
           userInfo:(NSDictionary *) userInfo
{
   NSParameterAssert( [name isKindOfClass:[NSString class]]);
   NSParameterAssert( ! reason || [reason isKindOfClass:[NSString class]]);
   
   _name     = [name copy];
   _reason   = [reason copy];
   _userInfo = [userInfo retain];

   return( self);
}


- (void) dealloc
{
   [_name release];
   [_reason release];
   [_userInfo release];

   [super dealloc];
}


- (NSString *) name
{
   return( _name);
}


- (NSString *) reason
{
   return( _reason);
}


- (NSDictionary *) userInfo
{
   return( _userInfo);
}

@end


//
// maybe a bit too lazy...
//
NSUInteger  MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( NSRange range,
                                                              NSUInteger length)
{
   NSUInteger max;
   
   if( range.length == ULONG_MAX)
      range.length = length;
   max = range.location + range.length;
   if( range.location > max || max > length)
      MulleObjCThrowInvalidRangeException( range);
   return( max);
}
