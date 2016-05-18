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

// other files in this library
#import "_MulleObjCConcreteMutableData.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSObject( _NSMutableData)

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
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSMutableData class]);
}


- (void) decodeWithCoder:(NSCoder *) coder
{
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


+ (id) _nonZeroedDataWithLength:(NSUInteger) length
{
   NSMutableData   *data;
   
   data = [self dataWithCapacity:length];
   [data _setLengthDontZero:length];
   return( data);
}


- (id) _initNonZeroedDataWithLength:(NSUInteger) length;
{
   [self init];
   [self _setLengthDontZero:length];
   return( self);
}


- (id) copy
{
   return( (id) [[NSData alloc] initWithData:self]);
}


- (void) replaceBytesInRange:(NSRange) range
                   withBytes:(void *) replacementBytes
                      length:(NSUInteger) replacementLength
{
   NSInteger    diff;
   NSUInteger   length;
   NSUInteger   remainderLocation;
   NSUInteger   remainderLength;
   uint8_t      *bytes;
   
   length = [self length];
   if( range.location + range.length > length || range.length > length)
      MulleObjCThrowInvalidRangeException( range);

   diff = (NSInteger) replacementLength - (NSInteger) range.length;

   remainderLocation = range.location + range.length;
   remainderLength   = length - remainderLocation;
   
   if( diff > 0) // need to grow
      [self setLength:length + diff];

   bytes = [self mutableBytes];
   if( diff > 0) // rescue bytes
      memmove( &bytes[ remainderLocation + diff], &bytes[ remainderLocation], remainderLength);
   
   // replace
   memcpy( &bytes[ range.location], replacementBytes, replacementLength);
   
   // possibly fill up hole and shrink
   if( diff < 0) // need to grow
   {
      memmove( &bytes[ range.location + replacementLength], &bytes[ remainderLocation], remainderLength);
      [self setLength:length + diff];
   }
}

- (void) replaceBytesInRange:(NSRange) range
                   withBytes:(void *) bytes
{
   [self replaceBytesInRange:range
                   withBytes:bytes
                      length:range.length];
}

@end


@implementation NSData( NSMutableCopying)

- (id) mutableCopy
{
   return( [[NSMutableData alloc] initWithData:self]);
}

@end


