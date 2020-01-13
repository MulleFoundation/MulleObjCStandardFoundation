//
//  NSMutableData.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "NSMutableData.h"

// other files in this library
#import "_MulleObjCConcreteMutableData.h"

// other libraries of MulleObjCStandardFoundation
#import "NSException.h"

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
# pragma mark classcluster

- (instancetype) initWithCapacity:(NSUInteger) capacity
{
   self = [_MulleObjCConcreteMutableData mulleNewWithCapacity:capacity];
   return( self);
}


- (instancetype) initWithLength:(NSUInteger) length
{
   self = [_MulleObjCConcreteMutableData mulleNewWithLength:length];
   return( self);
}


- (instancetype)  init
{
   self = [_MulleObjCConcreteMutableData mulleNewWithLength:0];
   return( self);
}

- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
{
   self = [_MulleObjCConcreteMutableData mulleNewWithBytes:bytes
                                                    length:length];
   return( self);
}


- (instancetype) _mulleInitWithNonZeroedAllocatedCapacity:(NSUInteger) capacity;
{
   self = [_MulleObjCConcreteMutableData _mulleNewWithNonZeroedAllocatedCapacity:capacity];
   return( self);
}


- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                                allocator:(struct mulle_allocator *) allocator
{
   self = [_MulleObjCConcreteMutableData mulleNewWithBytes:bytes
                                                    length:length];
   mulle_allocator_free( allocator, bytes);
   return( self);
}


- (instancetype) mulleInitWithBytesNoCopy:(void *) bytes
                                   length:(NSUInteger) length
                                    owner:(id) owner
{
   self = [_MulleObjCConcreteMutableData mulleNewWithBytes:bytes
                                                    length:length];
   return( self);
}


- (instancetype) initWithData:(NSData *) data
{
   self = [_MulleObjCConcreteMutableData mulleNewWithBytes:[data bytes]
                                                    length:[data length]];
   return( self);
}

#pragma mark - convenience constructors

+ (instancetype) dataWithCapacity:(NSUInteger) length
{
   return( [[[self alloc] initWithCapacity:length] autorelease]);
}


+ (instancetype) dataWithLength:(NSUInteger) length;
{
   return( [[[self alloc] initWithLength:length] autorelease]);
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


+ (instancetype) _mulleNonZeroedDataWithLength:(NSUInteger) length
{
   NSMutableData   *data;

   data = [self dataWithCapacity:length];
   [data _mulleSetLengthDontZero:length];
   return( data);
}


- (instancetype) _mulleInitNonZeroedDataWithLength:(NSUInteger) length;
{
   [self init];
   [self _mulleSetLengthDontZero:length];
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
   MulleObjCValidateRangeAgainstLength( range, length);

   diff = (NSInteger) replacementLength - (NSInteger) range.length;

   remainderLocation = range.location + range.length;
   remainderLength   = length - remainderLocation;

   if( diff > 0) // need to grow
      [self setLength:length + diff];

   bytes = [self mutableBytes];
   if( diff > 0) // rescue bytes
      memmove( &bytes[ remainderLocation + diff], &bytes[ remainderLocation], remainderLength);

   // replace
   memmove( &bytes[ range.location], replacementBytes, replacementLength);

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
