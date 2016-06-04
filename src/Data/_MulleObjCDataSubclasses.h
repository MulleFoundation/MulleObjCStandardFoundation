/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  _MulleObjCDataSubclasses.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSData.h"


@interface _MulleObjCConcreteData : NSData

+ (id) newWithBytes:(void *) bytes;

@end

@interface _MulleObjCZeroBytesData : _MulleObjCConcreteData
@end
@interface _MulleObjCEightBytesData : _MulleObjCConcreteData
@end
@interface _MulleObjCSixteenBytesData : _MulleObjCConcreteData
@end

@interface _MulleObjCTinyData : _MulleObjCConcreteData
{
   uint8_t         _length;         // 1-256
   unsigned char   _storage[ 3];
}

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length;

@end


@interface _MulleObjCMediumData : _MulleObjCConcreteData
{
   uint16_t        _length;         // 257-65792 
   unsigned char   _storage[ 2];
}

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length;
@end

                  
@interface _MulleObjCAllocatorData : _MulleObjCConcreteData
{
   NSUInteger   _length;
   void         *_storage;
   void         *_allocator;
}

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length;

+ (id) newWithBytesNoCopy:(void *) bytes
                   length:(NSUInteger) length
                allocator:(struct mulle_allocator *) allocator;

@end


@interface _MulleObjCSharedData : _MulleObjCAllocatorData
{
   id   _other;
}

+ (id) newWithBytesNoCopy:(void *) bytes
                   length:(NSUInteger) length
                    owner:(id) owner;

@end

