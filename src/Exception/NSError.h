//
//  NSError.h
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

#import "import.h"


@class NSArray;
@class NSDictionary;
@class NSString;


extern NSString   *MulleErrorClassKey;  // class to produce lazy error


extern NSString   *NSOSStatusErrorDomain;  // unused
extern NSString   *NSMachErrorDomain;
extern NSString   *MulleErrnoErrorDomain;

extern NSString   *NSFilePathErrorKey;
extern NSString   *NSStringEncodingErrorKey;    // NSNumber containing NSStringEncoding
extern NSString   *NSURLErrorKey;
extern NSString   *NSUnderlyingErrorKey;

extern NSString   *NSHelpAnchorErrorKey;
extern NSString   *NSLocalizedDescriptionKey;
extern NSString   *NSLocalizedFailureReasonErrorKey;
extern NSString   *NSLocalizedRecoveryOptionsErrorKey;
extern NSString   *NSLocalizedRecoverySuggestionErrorKey;
extern NSString   *NSRecoveryAttempterErrorKey;


// keys for threadInfo dict
extern NSString   *NSErrorKey;
extern NSString   *NSErrorDomainKey;

//
// domain is just a way to categorize error numbers
//
@interface NSError : NSObject < NSCopying, MulleObjCImmutable>

@property( readonly, copy)   NSString       *domain;
@property( readonly)         NSInteger      code;
@property( readonly, retain) id             userInfo;

// call this during +load or +initialize to add your error domain
+ (void) registerErrorDomain:(NSString *) domain
         errorStringFunction:(NSString *(*)( NSInteger)) translator;
+ (void) removeErrorDomain:(NSString *) domain;

- (instancetype) initWithDomain:(NSString *) domain
                           code:(NSInteger) code
                       userInfo:(NSDictionary *) userInfo;
+ (instancetype) errorWithDomain:(NSString *) domain
                            code:(NSInteger) code
                        userInfo:(NSDictionary *) userInfo;

- (NSString *) localizedDescription;
- (NSString *) localizedFailureReason;
- (NSString *) localizedRecoverySuggestion;
- (NSString *) localizedRecoveryOptions;
- (id) recoveryAttempter;
- (NSString *) helpAnchor;


// mulle addition:  the default ways are tedious and lame
//                  use this and errno, preferably
+ (void) mulleSetErrorDomain:(NSString *) domain;
+ (NSString *) mulleErrorDomain;


// if you use errno or some other threadlocal error state, you can
// set the errordomain to a constant only and create mulleExtract lazily


+ (void) mulleSetError:(NSError *) error;
+ (void) mulleSetErrorCode:(NSInteger) code
                    domain:(NSString *) domain
                  userInfo:(NSDictionary *) userInfo;

// new principal way to get errors
+ (instancetype) mulleExtract;

// reset to errno
+ (void) mulleClear;

// cheat :) function to just set an error quickly with localizedDescription
+ (instancetype) mulleGenericErrorWithDomain:( NSString *) domain
                        localizedDescription:(NSString *) s;
@end


// shortcuts
void      MulleObjCSetErrorCode( NSInteger code, NSString *domain, NSDictionary *userInfo);
void      MulleObjCSetErrorDomain( NSString *domain);
NSString  *MulleObjCGetErrorDomain( void);
NSError   *MulleObjCExtractError( void);
void      MulleObjCClearError( void);



// declared, but unused so far
@interface NSObject( RecoveryAttempting)

- (void) attemptRecoveryFromError:(NSError *) error
                      optionIndex:(NSUInteger) recoveryOptionIndex
                         delegate:(id) delegate
               didRecoverSelector:(SEL) didRecoverSelector
                      contextInfo:(void *) contextInfo;

- (BOOL) attemptRecoveryFromError:(NSError *) error
                      optionIndex:(NSUInteger) recoveryOptionIndex;

@end
