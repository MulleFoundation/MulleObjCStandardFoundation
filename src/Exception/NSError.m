//
//  NSError.m
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSError.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies


NSString  *NSErrorKey = @"NSError";


NSString   *NSOSStatusErrorDomain  = @"NSOSStatusError";
NSString   *NSMachErrorDomain      = @"NSMachError";

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
   _domain = [domain copy];
   _code   = code;
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


// mulle addition:  the default ways are tedious and lame
+ (void) setCurrentError:(NSError *) error
{
   if( ! error)
      MulleObjCThrowInvalidArgumentException( @"error must not be nil");
   
   [[[NSThread currentThread] threadDictionary] setObject:error
                                                   forKey:NSErrorKey];
}


+ (void) setCurrentErrorWithDomain:(NSString *) domain
                              code:(NSInteger) code
                          userInfo:(NSDictionary *) userInfo
{
   NSError  *error;

   error = [NSError errorWithDomain:domain
                               code:code
                           userInfo:userInfo];
   [self setCurrentError:error];
}


+ (void) clearCurrentError
{
   [[[NSThread currentThread] threadDictionary] removeObjectForKey:NSErrorKey];
}


+ (instancetype) currentError
{
   return( [[[NSThread currentThread] threadDictionary] objectForKey:NSErrorKey]);
}


void   MulleObjCErrorSetCurrentError( NSString *domain, NSInteger code, NSDictionary *userInfo)
{
   [NSError setCurrentErrorWithDomain:domain
                                 code:code
                             userInfo:userInfo];
}

NSError  *MulleObjCErrorGetCurrentError( void)
{
   return( [NSError currentError]);
}


void   MulleObjCErrorClearCurrentError( void)
{
   [NSError clearCurrentError];
}


- (id) copy
{
   return( [self retain]);
}

@end
