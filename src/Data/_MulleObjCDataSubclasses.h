//
//  _MulleObjCDataSubclasses.h
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
#import "NSData.h"


@interface _MulleObjCConcreteData : NSData

+ (instancetype) newWithBytes:(void *) bytes;

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

+ (instancetype) newWithBytes:(void *) bytes
             length:(NSUInteger) length;

@end


@interface _MulleObjCMediumData : _MulleObjCConcreteData
{
   uint16_t        _length;         // 257-65792
   unsigned char   _storage[ 2];
}

+ (instancetype) newWithBytes:(void *) bytes
             length:(NSUInteger) length;
@end


@interface _MulleObjCAllocatorData : _MulleObjCConcreteData
{
   NSUInteger   _length;
   void         *_storage;
   void         *_allocator;
}

+ (instancetype) newWithBytes:(void *) bytes
             length:(NSUInteger) length;

+ (instancetype) newWithBytesNoCopy:(void *) bytes
                   length:(NSUInteger) length
                allocator:(struct mulle_allocator *) allocator;

@end


@interface _MulleObjCSharedData : _MulleObjCAllocatorData
{
   id   _other;
}

+ (instancetype) newWithBytesNoCopy:(void *) bytes
                   length:(NSUInteger) length
                    owner:(id) owner;

@end
