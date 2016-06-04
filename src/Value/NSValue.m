/*
 *  MulleFoundation - the mulle-objc class library
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
#import "_MulleObjCConcreteValue.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <string.h>
#include <mulle_container/mulle_container.h>



#define MulleObjCValueAllocPlaceholderHash         0x331bd8f6291d398e  // MulleObjCValueAllocPlaceholder
#define MulleObjCValueInstantiatePlaceholderHash   0x56fb1f12fb5bee1f  // MulleObjCValueInstantiatePlaceholder



@implementation NSObject( _NSValue)

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


#pragma mark -
#pragma mark classcluster ?

- (id) initWithBytes:(void *) value
            objCType:(char *) type
{
   [self release];
   return( [_MulleObjCConcreteValue newWithBytes:value
                                        objCType:type]);
}


#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSValue class]);
}


// it is assumed, that NSValue and subclasses store their
// "value" at the first instance variable of type
// [self objCType]. If not override in your subclass
//
- (void) encodeWithCoder:(NSCoder *) coder
{
   char  *type;
   
   type = [self objCType];
   [coder encodeBytes:type
               length:strlen( type) + 1];
   [coder encodeValueOfObjCType:type
                             at:self];
}


// if this is a bottleneck, improve in subclasses
- (id) initWithCoder:(NSCoder *) coder
{
   char         *type;
   void         *buf;
   NSUInteger   size;
   
   type = [coder decodeBytesWithReturnedLength:NULL];

   NSGetSizeAndAlignment( type, &size, NULL);
   buf  = alloca( size);
   [coder decodeValueOfObjCType:type
                             at:buf];

   return( [self initWithBytes:buf
                      objCType:type]);
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}


#pragma mark -
#pragma mark convenience constructors

// compiler: need an @alias( alloc, whatever), so that implementations
//           can  be shared


+ (id) value:(void *) bytes 
withObjCType:(char *) type
{
   return( [[[self alloc] initWithBytes:bytes
                              objCType:type] autorelease]);
}


+ (id) valueWithBytes:(void *) bytes 
             objCType:(char *) type
{
   return( [[[self alloc] initWithBytes:bytes
                              objCType:type] autorelease]);
}


+ (id) valueWithPointer:(void *) pointer
{
   return( [[[self alloc] initWithBytes:&pointer
                               objCType:@encode( void *)] autorelease]);
}


+ (id) valueWithRange:(NSRange) range
{
   return( [[[self alloc] initWithBytes:&range
                               objCType:@encode( NSRange)] autorelease]);
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
   
   buf  = mulle_malloc( size * 2);
   buf2 = &buf[ size];

   [self getValue:&buf];
   [other getValue:&buf2];

   flag = ! memcmp( buf, buf2, size);
   mulle_free( buf);
   
   return( flag);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSValue])
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

- (id) copy
{
   return( [self retain]);
}

@end

