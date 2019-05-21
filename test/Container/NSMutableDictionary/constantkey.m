//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


static NSString   *XNSErrorKey          = @"NSError";
static NSString   *XMulleErrorClassKey  = @"MulleErrorClass";

static NSString   *XNSOSStatusErrorDomain  = @"NSOSStatusError";
static NSString   *XNSMachErrorDomain      = @"NSMachError";
static NSString   *XMulleErrnoErrorDomain  = @"MulleErrnoError";
 
static NSString   *XNSFilePathErrorKey       = @"NSFilePathError";
static NSString   *XNSStringEncodingErrorKey = @"NSStringEncodingError";
static NSString   *XNSURLErrorKey            = @"NSURLError";
static NSString   *XNSUnderlyingErrorKey     = @"NSUnderlyingError";
 
static NSString   *XNSHelpAnchorErrorKey                  = @"NSHelpAnchorError";
static NSString   *XNSLocalizedDescriptionKey             = @"NSLocalizedDescription";
static NSString   *XNSLocalizedFailureReasonErrorKey      = @"NSLocalizedFailureReasonError";
static NSString   *XNSLocalizedRecoveryOptionsErrorKey    = @"NSLocalizedRecoveryOptionsError";
static NSString   *XNSLocalizedRecoverySuggestionErrorKey = @"NSLocalizedRecoverySuggestionError";
static NSString   *XNSRecoveryAttempterErrorKey           = @"NSRecoveryAttempterError";



@interface Foo : NSObject
@end


@implementation Foo : NSObject

+ (void) mulleResetCurrentErrorClass
{
   NSMutableDictionary   *threadDictionary;

   threadDictionary = [[NSThread currentThread] threadDictionary];
   [threadDictionary setObject:self
                        forKey:XMulleErrorClassKey];
}


+ (void) load
{
   [self mulleResetCurrentErrorClass];
}

@end



int main(int argc, const char * argv[])
{
   NSMutableDictionary   *threadDictionary;

   threadDictionary = [[NSThread currentThread] threadDictionary];
   if( [threadDictionary objectForKey:XMulleErrorClassKey] != [Foo class])
      return( 1);
   return( 0);
}
