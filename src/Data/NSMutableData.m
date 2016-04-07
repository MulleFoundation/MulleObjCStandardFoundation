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
   NSMutableData   *data;
   
   data = [self dataWithCapacity:length];
   [data setLength:length];
   return( data);
}


+ (id) dataWithCapacity:(NSUInteger) length
{
   NSMutableData   *data;
   
   data = [[[self alloc] initWithCapacity:length] autorelease];
   return( data);
}


+ (id) dataWithBytes:(void *) buf 
              length:(NSUInteger) len
{
   NSMutableData   *data;
   
   data = [[[self alloc] initWithCapacity:len] autorelease];
   [data appendBytes:buf
              length:len];
   return( data);
}


+ (id) dataWithData:(NSData *) other
{
   NSMutableData   *data;
   
   data = [[[self alloc] initWithCapacity:[other length]] autorelease];
   [data appendData:other];
   return( data);
}


# pragma mark -
# pragma mark classcluster


- (id) initWithCapacity:(NSUInteger) capacity
{
   [self autorelease];

   return( [[_MulleObjCConcreteMutableData alloc] initWithCapacity:capacity]);
}


- (id) initWithLength:(NSUInteger) length
{
   [self autorelease];

   return( [[_MulleObjCConcreteMutableData alloc] initWithLength:length]);
}



- (id) initWithBytes:(void *) bytes
             length:(NSUInteger) length
{
   [self autorelease];

   return( [[_MulleObjCConcreteMutableData alloc] initWithBytes:bytes
                                                         length:length]);
}


- (id) initWithData:(NSData *) data
{
   [self autorelease];

   return( [[_MulleObjCConcreteMutableData alloc] initWithBytes:[data bytes]
                                                         length:[data length]]);
}




- (void) setData:(NSData *) aData
{
   NSRange   range;
   
   range.location = 0;
   range.length   = [aData length];
   [self setLength:range.length];
   [self replaceBytesInRange:range
                   withBytes:[aData bytes]];
}


+ (id) dataWithBytesNoCopy:(void *) buf 
                    length:(NSUInteger) length
{
   return( [self dataWithBytes:buf
                        length:length]);
}


+ (id) dataWithBytesNoCopy:(void *) buf 
                    length:(NSUInteger) length 
              freeWhenDone:(BOOL) flag
{
   NSMutableData   *data;
   
   data = [self dataWithBytes:buf
                       length:length];
   if( flag)
      free( buf);
      
   return( data);
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
   return( [[NSData alloc] initWithData:self]);
}

@end


@implementation NSData( NSMutableCopying)

- (id) mutableCopy
{
   return( [[NSMutableData alloc] initWithData:self]);
}

@end


