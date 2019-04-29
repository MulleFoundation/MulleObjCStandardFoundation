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

#import "MulleObjCFoundationBase.h"


@class NSArray;
@class NSDictionary;
@class NSString;


extern NSString   *NSErrorKey;
extern NSString   *MulleErrorClassKey;  // class to produce lazy error

extern NSString   *NSOSStatusErrorDomain;
extern NSString   *NSMachErrorDomain;
extern NSString   *MulleErrnoErrorDomain;

extern NSString   *NSFilePathErrorKey;
extern NSString   *NSStringEncodingErrorKey;// NSNumber containing NSStringEncoding
extern NSString   *NSURLErrorKey;
extern NSString   *NSUnderlyingErrorKey;

extern NSString   *NSHelpAnchorErrorKey;
extern NSString   *NSLocalizedDescriptionKey;
extern NSString   *NSLocalizedFailureReasonErrorKey;
extern NSString   *NSLocalizedRecoveryOptionsErrorKey;
extern NSString   *NSLocalizedRecoverySuggestionErrorKey;
extern NSString   *NSRecoveryAttempterErrorKey;


// domain is just a way to categorize error numbers

@interface NSError : NSObject < NSCopying>

@property( readonly, copy)   NSString       *domain;
@property( readonly)         NSInteger      code;
@property( readonly, retain) NSDictionary   *userInfo;

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

// if you use errno or some other threadlocal error state, you can
// set the errordomain to a constant only and create mulleCurrentError lazily


+ (void) mulleSetCurrentErrorClass:(Class) cls;
+ (void) mulleResetCurrentErrorClass; // set to self

+ (void) mulleSetCurrentError:(NSError *) error;
+ (void) mulleSetCurrentErrorWithDomain:(NSString *) domain
                                   code:(NSInteger) code
                               userInfo:(NSDictionary *) userInfo;
+ (instancetype) mulleCurrentError;
+ (void) mulleClearCurrentError;

@end



// shortcuts
void      MulleObjCErrorSetCurrentError( NSString *domain, NSInteger code, NSDictionary *userInfo);
NSError  *MulleObjCErrorGetCurrentError( void);
void      MulleObjCErrorClearCurrentError( void);

@interface NSObject( RecoveryAttempting)

- (void) attemptRecoveryFromError:(NSError *) error
                      optionIndex:(NSUInteger) recoveryOptionIndex
                         delegate:(id) delegate
               didRecoverSelector:(SEL) didRecoverSelector
                      contextInfo:(void *) contextInfo;

- (BOOL) attemptRecoveryFromError:(NSError *) error
                      optionIndex:(NSUInteger) recoveryOptionIndex;

@end
