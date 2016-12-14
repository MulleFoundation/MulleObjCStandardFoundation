//
//  NSAssertionHandler.h
//  MulleObjCFoundation
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

#import <MulleObjC/MulleObjC.h>



extern NSString  *NSAssertionHandlerKey;


@interface NSAssertionHandler : NSObject


+ (NSAssertionHandler *) currentHandler;

- (void) handleFailureInMethod:(SEL) selector
                        object:(id)object
                          file:(NSString *)fileName
                    lineNumber:(NSInteger)line
                   description:(NSString *)format, ...;

- (void) handleFailureInFunction:(NSString *) functionname
                          file:(NSString *)filename
                    lineNumber:(NSInteger)line
                   description:(NSString *)format, ...;

@end


void   NSAssertionHandlerHandleMethodFailure( SEL sel,
                                              id obj,
                                              char *filename,
                                              int line,
                                              NSString *format, ...);

void   NSAssertionHandlerHandleFunctionFailure( char *function,
                                                char *file,
                                                int line,
                                                NSString *format, ...);


# pragma mark -
# pragma mark various assert helpers

#ifndef NS_BLOCK_ASSERTIONS

#define MulleObjCAssert( a, b, p1, p2, p3, p4, p5)    \
   do                                           \
   {                                            \
      if( ! (a))                                \
         NSAssertionHandlerHandleMethodFailure( _cmd, self, __FILE__, __LINE__,     \
                                                (b), (p1), (p2), (p3), (p4), (p5)); \
   } while( 0)

#define MulleObjCCAssert( a, b, p1, p2, p3, p4, p5)   \
   do                                           \
   {                                            \
      if( ! (a))                                \
         NSAssertionHandlerHandleFunctionFailure( (char *) __PRETTY_FUNCTION__, __FILE__, __LINE__, \
                                                   (b), (p1), (p2), (p3), (p4), (p5));     \
   } while( 0)

#else

#define MulleObjCAssert( a, b, p1, p2, p3, p4, p5)
#define MulleObjCCAssert( a, b, p1, p2, p3, p4, p5)

#endif


#define NSAssert( a, b)                        NSAssert1( a, b, 0)
#define NSAssert1( a, b, p1)                   NSAssert2( a, b, p1, 0)
#define NSAssert2( a, b, p1, p2)               NSAssert3( a, b, p1, p2, 0)
#define NSAssert3( a, b, p1, p2, p3)           NSAssert4( a, b, p1, p2, p3, 0)
#define NSAssert4( a, b, p1, p2, p3, p4)       NSAssert5( a, b, p1, p2, p3, p4, 0)
#define NSAssert5( a, b, p1, p2, p3, p4, p5)   MulleObjCAssert( a, b, p1, p2, p3, p4, p5)

#define NSCAssert( a, b)                        NSCAssert1( a, b, 0)
#define NSCAssert1( a, b, p1)                   NSCAssert2( a, b, p1, 0)
#define NSCAssert2( a, b, p1, p2)               NSCAssert3( a, b, p1, p2, 0)
#define NSCAssert3( a, b, p1, p2, p3)           NSCAssert4( a, b, p1, p2, p3, 0)
#define NSCAssert4( a, b, p1, p2, p3, p4)       NSCAssert5( a, b, p1, p2, p3, p4, 0)
#define NSCAssert5( a, b, p1, p2, p3, p4, p5)   MulleObjCCAssert( a, b, p1, p2, p3, p4, p5)


#define NSParameterAssert( a)                   NSAssert1( a, @"Invalid parameter not satisfying: %s", # a)
#define NSCParameterAssert( a)                  NSCAssert1( a, @"Invalid parameter not satisfying: %s", # a)
