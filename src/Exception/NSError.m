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
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies
#import "NSException.h"


NSString  *NSErrorKey          = @"NSError";
NSString  *MulleErrorClassKey  = @"MulleErrorClass";


NSString   *NSOSStatusErrorDomain  = @"NSOSStatusError";
NSString   *NSMachErrorDomain      = @"NSMachError";
NSString   *MulleErrnoErrorDomain  = @"MulleErrnoError";

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


- (instancetype) initWithDomain:(NSString *) domain
                           code:(NSInteger) code
                       userInfo:(NSDictionary *) userInfo
{
   _domain   = [domain copy];
   _code     = code;
   _userInfo = [userInfo copy];

   return( self);
}


+ (instancetype) errorWithDomain:(NSString *) domain
                            code:(NSInteger) code
                        userInfo:(NSDictionary *) userInfo;
{
   return( [[[self alloc] initWithDomain:domain
                                    code:code
                                userInfo:userInfo] autorelease]);
}


- (NSString *) localizedDescription
{
   return( [_userInfo objectForKey:NSLocalizedDescriptionKey]);
}


- (NSString *) localizedFailureReason;
{
   return( [_userInfo objectForKey:NSLocalizedDescriptionKey]);
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
   [self mulleSetCurrentErrorClass:self];
}


+ (void) mulleSetCurrentErrorClass:(Class) domain
{
   NSMutableDictionary   *threadDictionary;

   if( ! domain)
      MulleObjCThrowInvalidArgumentException( @"domain must not be nil");

   threadDictionary = [[NSThread currentThread] threadDictionary];
   [threadDictionary removeObjectForKey:NSErrorKey];
   [threadDictionary setObject:domain
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


+ (void) mulleClearCurrentError
{
   NSMutableDictionary   *threadDictionary;

   threadDictionary = [[NSThread currentThread] threadDictionary];
   [threadDictionary removeObjectForKey:NSErrorKey];
   [threadDictionary removeObjectForKey:MulleErrorClassKey];
}


+ (instancetype) mulleErrnoError
{
   NSString       *s;
   NSError        *error;
   NSDictionary   *info;

   if( ! errno)
      return( nil);

   //
   // questionable!! Why is this UTF8
   // if not then OS should overwrite this
   //
   s     = [NSString stringWithUTF8String:strerror( errno)];
   info  = [NSDictionary dictionaryWithObject:s
                                       forKey:NSLocalizedDescriptionKey];
   error = [NSError errorWithDomain:MulleErrnoErrorDomain
                               code:errno
                           userInfo:info];
   return( error);
}


+ (instancetype) mulleCurrentError
{
   NSMutableDictionary   *threadDictionary;
   NSError               *error;
   Class                 cls;

   threadDictionary = [[NSThread currentThread] threadDictionary];
   error            = [threadDictionary objectForKey:NSErrorKey];
   if( error)
      return( error);

   cls = [threadDictionary objectForKey:MulleErrorClassKey];
   return( [cls mulleErrnoError]);
}


void   MulleObjCErrorSetCurrentError( NSString *domain, NSInteger code, NSDictionary *userInfo)
{
   [NSError mulleSetCurrentErrorWithDomain:domain
                                      code:code
                                  userInfo:userInfo];
}


NSError  *MulleObjCErrorGetCurrentError( void)
{
   return( [NSError mulleCurrentError]);
}


void   MulleObjCErrorClearCurrentError( void)
{
   [NSError mulleClearCurrentError];
}


- (id) copy
{
   return( [self retain]);
}

@end
