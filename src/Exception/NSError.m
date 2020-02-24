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


NSString   *NSErrorKey          = @"NSError";
NSString   *MulleErrorClassKey  = @"MulleErrorClass";


NSString   *NSOSStatusErrorDomain    = @"NSOSStatusError";
NSString   *NSMachErrorDomain        = @"NSMachError";
NSString   *MulleErrnoErrorDomain    = @"MulleErrnoError";

NSString   *NSFilePathErrorKey       = @"NSFilePathError";
NSString   *NSStringEncodingErrorKey = @"NSStringEncodingError";
NSString   *NSURLErrorKey            = @"NSURLError";
NSString   *NSUnderlyingErrorKey     = @"NSUnderlyingError";

NSString   *NSHelpAnchorErrorKey                  = @"NSHelpAnchorError";
NSString   *NSLocalizedDescriptionKey             = @"NSLocalizedDescription";
NSString   *NSLocalizedFailureReasonErrorKey      = @"NSLocalizedFailureReasonError";
NSString   *NSLocalizedRecoveryOptionsErrorKey    = @"NSLocalizedRecoveryOptionsError";
NSString   *NSLocalizedRecoverySuggestionErrorKey = @"NSLocalizedRecoverySuggestionError";
NSString   *NSRecoveryAttempterErrorKey           = @"NSRecoveryAttempterError";



@implementation NSError

NSString   *MulleStringFromErrno( NSInteger errno)
{
   return( [NSString stringWithUTF8String:strerror( (int) errno)]);
}


static struct
{
   Class        _nsErrorClass;
   NSMapTable   *_domains;
} Self;


MULLE_OBJC_DEPENDS_ON_LIBRARY( MulleObjCValueFoundation);


+ (void) load
{
   Self._nsErrorClass = [self class];
}


+ (void) initialize
{
   if( ! Self._domains)
   {
      Self._domains = NSCreateMapTable( NSObjectMapKeyCallBacks,
                                        NSNonOwnedPointerMapValueCallBacks,
                                        4);
      NSMapInsertKnownAbsent( Self._domains, MulleErrnoErrorDomain, MulleStringFromErrno);
   }
}


+ (void) deinitialize
{
   NSFreeMapTable( Self._domains);
}



+ (void) registerErrorDomain:(NSString *) domain
         errorStringFunction:(NSString *(*)( NSInteger)) translator
{
   // should check that this called only during +load or +initialize
   NSMapInsert( Self._domains, domain, translator);
}


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
+ (void) mulleResetCurrentErrorClass
{
   NSMutableDictionary   *threadDictionary;

   threadDictionary = [[NSThread currentThread] threadDictionary];
   [threadDictionary setObject:self
                        forKey:MulleErrorClassKey];
}


+ (void) mulleSetCurrentError:(NSError *) error
{
   if( ! error)
      MulleObjCThrowInvalidArgumentException( @"error must not be nil");

   [[[NSThread currentThread] threadDictionary] setObject:error
                                                   forKey:NSErrorKey];
}


+ (void) mulleSetCurrentErrorWithDomain:(NSString *) domain
                                   code:(NSInteger) code
                               userInfo:(NSDictionary *) userInfo
{
   NSError  *error;

   error = [NSError errorWithDomain:domain
                               code:code
                           userInfo:userInfo];
   [self mulleSetCurrentError:error];
}


+ (void) mulleClearErrorState
{
   errno = 0;
}


+ (void) mulleClearCurrentError
{
   NSMutableDictionary   *threadDictionary;
   Class                 cls;

   threadDictionary = [[NSThread currentThread] threadDictionary];
   [threadDictionary removeObjectForKey:NSErrorKey];

   cls = [threadDictionary objectForKey:MulleErrorClassKey];
   if( ! cls)
      cls  = self;
   return( [cls mulleClearErrorState]);
}


+ (NSString *) mulleDefaultDomain
{
   return( MulleErrnoErrorDomain);
}


//
// code must be in "errno", then we use the lazy stringification that
// the various domain installed to produce the string, which is then
// wrapped into an NSError
//
+ (instancetype) mulleLazyErrorWithDomain:(NSString *) domain
{
   NSString       *s;
   NSError        *error;
   NSDictionary   *info;
   NSString       *(*f)( NSInteger);

   if( ! errno)
      return( nil);

   info = nil;
   f    = NSMapGet( Self._domains, domain);
   if( f)
   {
      s = (*f)( errno);
      if( s)
         info  = [NSDictionary dictionaryWithObject:s
                                             forKey:NSLocalizedDescriptionKey];
   }

   error = [NSError errorWithDomain:domain
                               code:errno
                           userInfo:info];
   return( error);
}


+ (instancetype) mulleCurrentErrorWithDomain:(NSString *) domain
{
   NSMutableDictionary   *threadDictionary;
   NSError               *error;
   Class                 cls;

   threadDictionary = [[NSThread currentThread] threadDictionary];
   error            = [threadDictionary objectForKey:NSErrorKey];
   if( error)
      return( error);

   cls = [threadDictionary objectForKey:MulleErrorClassKey];
   if( ! cls)
      cls = self;
   return( [cls mulleLazyErrorWithDomain:domain]);
}


+ (instancetype) mulleCurrentError
{
   return( [self mulleCurrentErrorWithDomain:[self mulleDefaultDomain]]);
}


void   MulleObjCErrorSetCurrentError( NSString *domain, NSInteger code, NSDictionary *userInfo)
{
   [Self._nsErrorClass mulleSetCurrentErrorWithDomain:domain
                                                 code:code
                                             userInfo:userInfo];
}


NSError  *MulleObjCErrorGetCurrentErrorWithDomain( NSString *domain)
{
   return( [Self._nsErrorClass mulleCurrentErrorWithDomain:domain]);
}


NSError  *MulleObjCErrorGetCurrentError( void)
{
   return( [Self._nsErrorClass mulleCurrentError]);
}



void   MulleObjCErrorClearCurrentError( void)
{
   [Self._nsErrorClass mulleClearCurrentError];
}


- (id) copy
{
   return( [self retain]);
}

@end
