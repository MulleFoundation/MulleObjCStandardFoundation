/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSException.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import <MulleObjC/MulleObjC.h>


@class NSString;
@class NSDictionary;


extern NSString   *NSInternalInconsistencyException;
extern NSString   *NSGenericException;
extern NSString   *NSInvalidArgumentException;
extern NSString   *NSMallocException;
extern NSString   *NSRangeException;


@interface NSException : NSObject < MulleObjCException>
{
   NSString       *_name;
   NSString       *_reason;
   NSDictionary   *_userInfo;
}

+ (NSException *) exceptionWithName:(NSString *) name
                             reason:(NSString *) reason
                           userInfo:(id) userInfo;

//
// MEMO: don't marker raise as __attribute__(( noreturn)) because
//       when self is nil, it does return.
//
+ (void) raise:(NSString *) name
        format:(NSString *) format
     arguments:(mulle_vararg_list) args;

+ (void) raise:(NSString *) name
        format:(NSString *) format
       va_list:(va_list) va;

+ (void) raise:(NSString *) name
        format:(NSString *) format, ...;


- (id) initWithName:(NSString *) name
             reason:(NSString *) reason
           userInfo:(NSDictionary *) userInfo  ;

- (NSString *) name;
- (NSString *) reason;
- (NSDictionary *) userInfo;

@end


#define NS_DURING		@try {
#define NS_HANDLER		} @catch( NSException *localException) {
#define NS_ENDHANDLER		}
#define NS_VALUERETURN( v,t)	return (v)
#define NS_VOIDRETURN		return


typedef void    NSUncaughtExceptionHandler( NSException *exception);

NSUncaughtExceptionHandler   *NSGetUncaughtExceptionHandler( void);

void   NSSetUncaughtExceptionHandler (NSUncaughtExceptionHandler *handler);

NSUInteger  MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( NSRange range,
                                                              NSUInteger length);

