/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSData.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSData.h"

// other files in this library
#import "_MulleObjCDataSubclasses.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#import <mulle_container/mulle_container.h>




@implementation NSObject ( NSData)

- (BOOL) __isNSData
{
   return( NO);
}

@end


@implementation NSData

- (BOOL) __isNSData
{
   return( YES);
}


+ (id) data
{
   return( [[self new] autorelease]);
}


+ (id) dataWithBytes:(void *) buf 
              length:(NSUInteger) length
{
   return( [[[self alloc] initWithBytes:buf
                                 length:length] autorelease]);
}


+ (id) dataWithBytesNoCopy:(void *) buf
                    length:(NSUInteger) length
{
   return( [[[self alloc] initWithBytesNoCopy:buf
                                       length:length] autorelease]);
}


+ (id) dataWithBytesNoCopy:(void *) buf
                    length:(NSUInteger) length 
              freeWhenDone:(BOOL) flag
{
   return( [[[self alloc] initWithBytesNoCopy:buf
                                       length:length
                                 freeWhenDone:flag] autorelease]);
}


+ (id) dataWithData:(NSData *) data
{
   return( [[[self alloc] initWithData:data] autorelease]);
}



static NSData  *_newData( void *buf, NSUInteger length)
{
   switch( length)
   {
   case 0  : return( [_MulleObjCZeroBytesData newWithBytes:buf]);
   case 8  : return( [_MulleObjCEightBytesData newWithBytes:buf]);
   case 16 : return( [_MulleObjCSixteenBytesData newWithBytes:buf]);
   }
   
   if( length < 0x100 + 1)
      return( [_MulleObjCTinyData newWithBytes:buf
                                            length:length]);
   if( length < 0x10000 + 0x100 + 1)
      return( [_MulleObjCMediumData newWithBytes:buf
                                                length:length]);
   
   return( [_MulleObjCAllocatorData newWithBytes:buf
                                              length:length]);
}


#pragma mark -
#pragma mark class cluster stuff

- (id)  init
{
   [self autorelease];
   return( _newData( 0, 0));
}


// since "self" is the placeholder, we don't need to release it
- (id) initWithBytes:(void *) bytes 
              length:(NSUInteger) length
{
   [self autorelease];
   return( _newData( bytes, length));
}


- (id) initWithBytesNoCopy:(void *) bytes 
                    length:(NSUInteger) length
{
   [self autorelease];
   return( [_MulleObjCAllocatorData newWithBytesNoCopy:bytes
                                                length:length
                                             allocator:&mulle_stdlib_allocator]);
}


- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
               freeWhenDone:(BOOL) flag;
{
   struct mulle_allocator   *allocator;
   
   [self autorelease];

   allocator = flag ? &mulle_stdlib_allocator: NULL;
   return( [_MulleObjCAllocatorData newWithBytesNoCopy:bytes
                                                length:length
                                             allocator:allocator]);
}


- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
                     owner:(id) owner
{
   [self autorelease];

   return( [_MulleObjCSharedData newWithBytesNoCopy:bytes
                                             length:length
                                              owner:owner]);
}


- (id) initWithData:(id) other
{
   [self autorelease];
   
   return( _newData( [other bytes], [other length]));
}


#pragma mark -
#pragma mark common code

- (NSUInteger) hash
{
   long        length;
   char        *buf;
   char        *sentinel;
   uintptr_t   hash;
   
   length   = [self length];
   buf      = (char *) [self bytes];
   sentinel = &buf[ length > 0x400 ? 0x400 : length]; // touch at most a page
   
   // this hashes 4*32 bytes max
   hash = 0x1848;
   while( length > 32)
   {
      hash = mulle_chained_hash( buf, 32, hash);
      buf  = &buf[ 0x100];
      if( buf >= sentinel)
         return( (NSUInteger) hash);
      
      length -= 0x100;
   }
   
   // small and large data goes here
   hash = mulle_chained_hash( buf, length, hash);
   return( (NSUInteger) hash);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSData])
      return( NO);
   return( [self isEqualToData:other]);
}


- (void) getBytes:(void *) buf
{
   assert( buf);
   memcpy( buf, [self bytes], [self length]);
}


- (void) getBytes:(void *) buf 
           length:(NSUInteger) length
{
   MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( NSMakeRange( 0, length), [self length]);
   // need assert
   memcpy( buf, [self bytes], length);
}           

           
- (void) getBytes:(void *) buf 
            range:(NSRange) range
{
   MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( range, [self length]);
   
   // need assert
   memcpy( buf, &((char *)[self bytes])[ range.location], range.length);
}


- (BOOL) isEqualToData:(id) other
{
   NSUInteger   length;
   
   length = [other length];
   if( length != [self length])
      return( NO);
   return( ! memcmp( [self bytes], [other bytes], length));
}


- (id) subdataWithRange:(NSRange) range
{
   MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( range, [self length]);

   return( [NSData dataWithBytes:&((char *)[self bytes])[ range.location]
                           length:range.length]);
}


- (NSRange) rangeOfData:(id) arg1 
                options:(NSUInteger) arg2 
                  range:(NSRange) arg3;
{
   abort();
}

@end





