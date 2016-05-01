//
//  NSError.h
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import <MulleObjC/MulleObjC.h>


@class NSArray;
@class NSDictionary;


extern NSString  *NSErrorKey;

extern NSString   *NSOSStatusErrorDomain;
extern NSString   *NSMachErrorDomain;

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

@property( readonly) NSString       *domain;
@property( readonly) NSInteger      code;
@property( readonly) NSDictionary   *userInfo;

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
+ (void) setCurrentError:(NSError *) eror;
+ (void) setCurrentErrorWithDomain:(NSString *) domain
                              code:(NSInteger) code
                          userInfo:(NSDictionary *) userInfo;
+ (instancetype) currentError;
+ (void) clearCurrentError;

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




