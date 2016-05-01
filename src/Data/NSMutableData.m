/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMutableData.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSMutableData.h"

#import "_MulleObjCConcreteMutableData.h"


@implementation NSObject( NSMutableData_Private)

- (BOOL) __isNSMutableData
{
   return( NO);
}

@end


@implementation NSMutableData

- (BOOL) __isNSMutableData
{
   return( YES);
}


# pragma mark -
# pragma mark conveniences

+ (id) data
{
   return( [self dataWithCapacity:0]);
}   


+ (id) dataWithLength:(NSUInteger) length
{
   return( [[[self alloc] initWithLength:length] autorelease]);
}


+ (id) dataWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


+ (id) dataWithBytes:(void *) buf 
              length:(NSUInteger) len
{
   return( [[[self alloc] initWithBytes:buf
                                 length:len] autorelease]);
}


+ (id) dataWithData:(NSData *) other
{
   return( [[[self alloc] initWithBytes:[other bytes]
                                 length:[other length]] autorelease]);
}


# pragma mark -
# pragma mark classcluster

- (id) initWithCapacity:(NSUInteger) capacity
{
   [self release];

   return( [_MulleObjCConcreteMutableData newWithCapacity:capacity]);
}


- (id) initWithLength:(NSUInteger) length
{
   [self release];

   return( [_MulleObjCConcreteMutableData newWithLength:length]);
}


- (id) initWithBytes:(void *) bytes
              length:(NSUInteger) length
{
   [self release];

   return( [_MulleObjCConcreteMutableData newWithBytes:bytes
                                                length:length]);
}


- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
               freeWhenDone:(BOOL) flag
{
   struct mulle_allocator   *allocator;
   
   allocator = &mulle_stdlib_allocator;

   if( flag)
   {
      [self release];
      return( [_MulleObjCConcreteMutableData newWithBytesNoCopy:bytes
                                                         length:length
                                                      allocator:allocator]);
   }
   
   self = [self initWithBytes:bytes
                       length:length];
   mulle_allocator_free( allocator, bytes);
   return( self);
}

- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
                 allocator:(struct mulle_allocator *) allocator
{
   [self release];

   return( [_MulleObjCConcreteMutableData newWithBytesNoCopy:bytes
                                                      length:length
                                                   allocator:allocator]);
}


- (id) initWithData:(NSData *) data
{
   [self release];

   return( [_MulleObjCConcreteMutableData newWithBytes:[data bytes]
                                                length:[data length]]);
}



#pragma mark -
#pragma mark operations

- (void) setData:(NSData *) aData
{
   NSRange   range;
   
   range.location = 0;
   range.length   = [aData length];
   
   [self setLength:range.length];
   [self replaceBytesInRange:range
                   withBytes:[aData bytes]];
}



- (void) appendData:(NSData *) otherData
{
   [self appendBytes:[otherData bytes]
              length:[otherData length]];
}


+ (id) nonZeroedDataWithLength:(NSUInteger) length
{
   NSMutableData   *data;
   
   data = [self dataWithCapacity:length];
   [data setLengthDontZero:length];
   return( data);
}


- (id) initNonZeroedDataWithLength:(NSUInteger) length;
{
   [self init];
   [self setLengthDontZero:length];
   return( self);
}


- (id) copy
{
   return( (id) [[NSData alloc] initWithData:self]);
}

@end


@implementation NSData( NSMutableCopying)

- (id) mutableCopy
{
   return( [[NSMutableData alloc] initWithData:self]);
}

@end


