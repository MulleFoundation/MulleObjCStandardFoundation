/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSAssert.h is a part of MulleFoundation
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


extern void   NSAssertionHandlerHandleMethodFailure( SEL, id, char *, int, NSString *, ...);
extern void   NSAssertionHandlerHandleFunctionFailure( char *, char *, int, NSString *, ...);



