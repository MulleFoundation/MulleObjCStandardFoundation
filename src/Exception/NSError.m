//
//  NSError.m
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

#import "NSError.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardFoundationContainer.h"
#import "MulleObjCStandardFoundationString.h"

// std-c and dependencies
#import "NSException.h"



NSString   *MulleErrorClassKey                    = @"MulleErrorClass";

NSString   *NSOSStatusErrorDomain                 = @"NSOSStatusError";
NSString   *NSMachErrorDomain                     = @"NSMachError";
NSString   *MulleErrnoErrorDomain                 = @"MulleErrnoError";

NSString   *NSFilePathErrorKey                    = @"NSFilePathError";
NSString   *NSStringEncodingErrorKey              = @"NSStringEncodingError";
NSString   *NSURLErrorKey                         = @"NSURLError";
NSString   *NSUnderlyingErrorKey                  = @"NSUnderlyingError";

NSString   *NSHelpAnchorErrorKey                  = @"NSHelpAnchorError";
NSString   *NSLocalizedDescriptionKey             = @"NSLocalizedDescription";
NSString   *NSLocalizedFailureReasonErrorKey      = @"NSLocalizedFailureReasonError";
NSString   *NSLocalizedRecoveryOptionsErrorKey    = @"NSLocalizedRecoveryOptionsError";
NSString   *NSLocalizedRecoverySuggestionErrorKey = @"NSLocalizedRecoverySuggestionError";
NSString   *NSRecoveryAttempterErrorKey           = @"NSRecoveryAttempterError";


NSString   *NSErrorKey       = @"NSError";
NSString   *NSErrorDomainKey = @"NSErrorDomain";


@implementation NSError


static struct
{
   NSMapTable   *_domains;
} Self;


+ (mulle_objc_dependency_t *) dependencies
{
   static mulle_objc_dependency_t   dependencies[] =
   {
      MULLE_OBJC_LIBRARY_DEPENDENCY( MulleObjCValueFoundation),
      MULLE_OBJC_LIBRARY_DEPENDENCY( MulleObjCContainerFoundation),
      MULLE_OBJC_NO_DEPENDENCY
   };
   return( dependencies);
}


+ (void) initialize
{
   if( ! Self._domains)
   {
      Self._domains = NSCreateMapTable( NSObjectMapKeyCallBacks,
                                        NSNonOwnedPointerMapValueCallBacks,
                                        4);
   }
}


+ (void) deinitialize
{
   @autoreleasepool
   {
      NSFreeMapTable( Self._domains);
      Self._domains = NULL;
   }
}



+ (void) registerErrorDomain:(NSString *) domain
         errorStringFunction:(NSString *(*)( NSInteger)) translator
{
   // should check that this called only during +load or +initialize
   NSMapInsert( Self._domains, domain, translator);
}


+ (void) removeErrorDomain:(NSString *) domain
{
   // should check that this called only during +load or +initialize
   if( Self._domains)
      NSMapRemove( Self._domains, domain);
}


/*
 *
 */
- (instancetype) initWithDomain:(NSString *) domain
                           code:(NSInteger) code
                       userInfo:(NSDictionary *) userInfo
{
   _domain   = [domain copy];
   _code     = code;
   _userInfo = [userInfo copy];

   return( self);
}


- (void) finalize
{
   [_domain autorelease];
   _domain = 0;
   [_userInfo autorelease];
   _userInfo = 0;

   [super finalize];
}


- (id) copy
{
   return( [self retain]);
}


+ (instancetype) errorWithDomain:(NSString *) domain
                            code:(NSInteger) code
                        userInfo:(NSDictionary *) userInfo;
{
   return( [[[self alloc] initWithDomain:domain
                                    code:code
                                userInfo:userInfo] autorelease]);
}


+ (instancetype) mulleGenericErrorWithDomain:(NSString *) domain
                        localizedDescription:(NSString *) s
{
   if( ! s)
      s = @"???";
   return( [self errorWithDomain:domain
                            code:-1
                        userInfo:@{ NSLocalizedDescriptionKey: s }]);
}


- (NSString *) localizedDescription
{
   return( [_userInfo objectForKey:NSLocalizedDescriptionKey]);
}


- (NSString *) localizedFailureReason
{
   return( [_userInfo objectForKey:NSLocalizedFailureReasonErrorKey]);
}


- (NSString *) localizedRecoverySuggestion;
{
   return( [_userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]);
}


- (NSString *) localizedRecoveryOptions;
{
   return( [_userInfo objectForKey:NSLocalizedRecoveryOptionsErrorKey]);
}


- (id) recoveryAttempter;
{
   return( [_userInfo objectForKey:NSRecoveryAttempterErrorKey]);
}


- (NSString *) helpAnchor;
{
   return( [_userInfo objectForKey:NSHelpAnchorErrorKey]);
}


//
// mulle additions:  the default ways are tedious and lame
//
+ (void) mulleSetError:(NSError *) error
{
   if( ! error)
      MulleObjCThrowInvalidArgumentException( @"error must not be nil");

   [[[NSThread currentThread] threadDictionary] setObject:error
                                                   forKey:NSErrorKey];
}


+ (void) mulleSetErrorCode:(NSInteger) code
                    domain:(NSString *) domain
                  userInfo:(NSDictionary *) userInfo
{
   NSError  *error;

   error = [NSError errorWithDomain:domain
                               code:code
                           userInfo:userInfo];
   [self mulleSetError:error];
}


static inline NSString  *MulleStringFromErrorCode( NSInteger  code)
{
   return( [NSString stringWithUTF8String:strerror( (int) errno)]);
}


//
// We use the lazy stringification that the various domains installed to
// produce the string, which is then wrapped into an NSError
//
+ (instancetype) mulleLazyErrorWithCode:(NSInteger) code
                                 domain:(NSString *) domain
{
   NSString       *s;
   NSError        *error;
   NSDictionary   *info;
   NSString       *(*f)( NSInteger);

   if( ! code)
      return( nil);

   info = nil;
   s    = nil;
   if( domain)
   {
      f = NSMapGet( Self._domains, domain);
      if( f)
      {
         s = (*f)( code);
         goto have_domain;
      }

      // NSPosixErrorDomain and MulleErrnoErrorDomain don't install anything,
      // so just use strerror
   }
   s = MulleStringFromErrorCode( code);

have_domain:
   if( s)
      info = [NSDictionary dictionaryWithObject:s
                                         forKey:NSLocalizedDescriptionKey];

   error = [NSError errorWithDomain:domain
                               code:code
                           userInfo:info];
   return( error);
}




+ (NSString *) mulleErrorDomain
{
   NSMutableDictionary   *threadDictionary;
   int                   preserve;

   preserve = errno;
   threadDictionary = [[NSThread currentThread] threadDictionary];
   errno    = preserve;

   return( [threadDictionary objectForKey:NSErrorDomainKey]);
}



+ (void) mulleSetErrorDomain:(NSString *) domain
{
   NSMutableDictionary   *threadDictionary;
   NSError               *error;
   int                   preserve;

   preserve = errno;

   threadDictionary = [[NSThread currentThread] threadDictionary];
   [threadDictionary removeObjectForKey:NSErrorKey];
   if( ! domain)
      [threadDictionary removeObjectForKey:NSErrorDomainKey];
   else
      [threadDictionary setObject:domain
                           forKey:NSErrorDomainKey];

   errno = preserve;
}


+ (void) mulleClear
{
   [self mulleSetErrorDomain:nil];

   errno = 0;
}


//
// the runtime protect errno from changing during a [] call
//
+ (instancetype) mulleExtract
{
   NSMutableDictionary   *threadDictionary;
   NSError               *error;
   NSString              *domain;
   int                   preserve;

   preserve         = errno;
   threadDictionary = [[NSThread currentThread] threadDictionary];
   error            = [threadDictionary objectForKey:NSErrorKey];
   if( ! error)
   {
      domain = [threadDictionary objectForKey:NSErrorDomainKey];
      error  = [self mulleLazyErrorWithCode:preserve
                                     domain:domain];
   }

   [self mulleClear];
   return( error);
}


/*
 * C shortcuts
 */

NSString   *MulleObjCGetErrorDomain( void)
{
   return( [NSError mulleErrorDomain]);

}


void   MulleObjCSetErrorDomain( NSString *domain)
{
   [NSError mulleSetErrorDomain:domain];
}


void   MulleObjCSetErrorCode( NSInteger code, NSString *domain, NSDictionary *userInfo)
{
   [NSError mulleSetErrorCode:code
                       domain:domain
                     userInfo:userInfo];
}


NSError   *MulleObjCExtractError( void)
{
   return( [NSError mulleExtract]);
}


void   MulleObjCClearError( void)
{
   [NSError mulleClear];
}


@end
