/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSValue.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSValue.h"

// other files in this library
#import "NSValue+Private.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <string.h>
#include <mulle_container/mulle_container.h>



#define MulleObjCValueAllocPlaceholderHash         0x331bd8f6291d398e  // MulleObjCValueAllocPlaceholder
#define MulleObjCValueInstantiatePlaceholderHash   0x56fb1f12fb5bee1f  // MulleObjCValueInstantiatePlaceholder



@implementation NSObject( NSValue)

- (BOOL) __isNSValue
{
   return( NO);
}

@end


@implementation NSValue

- (BOOL) __isNSValue
{
   return( YES);
}


+ (mulle_objc_classid_t) __allocPlaceholderClassid
{
   return( MULLE_OBJC_CLASSID( MulleObjCValueAllocPlaceholderHash));
}


+ (mulle_objc_classid_t) __instantiatePlaceholderClassid
{
   return( MULLE_OBJC_CLASSID( MulleObjCValueInstantiatePlaceholderHash));
}


// compiler: need an @alias( alloc, whatever), so that implementations
//           can  be shared


+ (id) value:(void *) bytes 
withObjCType:(char *) type
{
   return( [_MulleObjCConcreteValue valueWithBytes:bytes
                                          objCType:type]);
}


+ (id) valueWithBytes:(void *) bytes 
             objCType:(char *) type
{
   return( [_MulleObjCConcreteValue valueWithBytes:bytes
                                          objCType:type]);
}


+ (id) valueWithPointer:(void *) pointer
{
   return( [_MulleObjCConcreteValue valueWithBytes:&pointer
                                          objCType:@encode( void *)]);
}


+ (id) valueWithRange:(NSRange) range
{
   return( [_MulleObjCConcreteValue valueWithBytes:&range
                                          objCType:@encode( NSRange)]);
}


- (BOOL) isEqualToValue:(NSValue *) other
{
   NSUInteger   size;
   NSUInteger   otherSize;
   char         *buf;
   char         *buf2;
   BOOL         flag;
   
   NSParameterAssert( [other isKindOfClass:[NSValue class]]);
   
   if( strcmp( [self objCType], [other objCType]))
      return( NO);
   
   size      = [self _size];
   otherSize = [other _size];
   if( size == otherSize)
      return( NO);
   
   buf = MulleObjCAllocateNonZeroedMemory( size * 2);
   buf2 = &buf[ size];

   [self getValue:&buf];
   [other getValue:&buf2];

   flag = ! memcmp( buf, buf2, size);
   MulleObjCDeallocateMemory( buf);
   
   return( flag);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other isKindOfClass:[NSValue class]])
      return( NO);
   return( [self isEqualToValue:other]);
}


- (NSUInteger) _size
{
   NSUInteger   size;
   
   NSGetSizeAndAlignment( [self objCType], &size, NULL);
   return( size);
}


- (NSUInteger) hash
{
   abort();
}


- (void) getValue:(void *) bytes
             size:(NSUInteger) size
{
   NSUInteger   real;
   
   NSGetSizeAndAlignment( [self objCType], &real, NULL);
   if( real != size)
      MulleObjCThrowInvalidArgumentException( @"size should be %ld bytes on this platform", real);

   [self getValue:bytes];
}


- (void *) pointerValue
{
   void  *pointer;
   
   [self getValue:&pointer
             size:sizeof( void *)];
   return( pointer);
}


- (NSRange) rangeValue
{
   NSRange  range;
   
   [self getValue:&range
             size:sizeof( NSRange)];
   return( range);
}

@end

