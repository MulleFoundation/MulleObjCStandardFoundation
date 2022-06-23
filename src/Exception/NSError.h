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


MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *MulleErrorClassKey;  // class to produce lazy error

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSOSStatusErrorDomain;  // unused
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSMachErrorDomain;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *MulleErrnoErrorDomain;

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSFilePathErrorKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSStringEncodingErrorKey;    // NSNumber containing NSStringEncoding
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSURLErrorKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUnderlyingErrorKey;

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSHelpAnchorErrorKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocalizedDescriptionKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocalizedFailureReasonErrorKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocalizedRecoveryOptionsErrorKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSLocalizedRecoverySuggestionErrorKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSRecoveryAttempterErrorKey;


// keys for threadInfo dict
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSErrorKey;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSErrorDomainKey;

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


//
// if you use errno or some other threadlocal error state, you can
// set the errordomain to a constant only and create mulleExtract lazily
//
+ (void) mulleSetError:(NSError *) error;
+ (void) mulleSetErrorCode:(NSInteger) code
                    domain:(NSString *) domain
                  userInfo:(NSDictionary *) userInfo;

// new principal way to get errors
+ (instancetype) mulleExtract;

// reset to errno
+ (void) mulleClear;

// cheat :) function to just set an error quickly with localizedDescription
+ (void) mulleSetGenericErrorWithDomain:(NSString *) domain
                   localizedDescription:(NSString *) s;

+ (instancetype) mulleGenericErrorWithDomain:(NSString *) domain
                        localizedDescription:(NSString *) s;
@end


// shortcuts
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL
void      MulleObjCSetErrorCode( NSInteger code, NSString *domain, NSDictionary *userInfo);

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL
void      MulleObjCSetErrorDomain( NSString *domain);

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL
NSString  *MulleObjCGetErrorDomain( void);

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL
NSError   *MulleObjCExtractError( void);

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL
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
