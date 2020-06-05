//
//  MulleObjCStream.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2009 Nat! - Mulle kybernetiK.
//  Copyright (c) 2009 Codeon GmbH.
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

#import "MulleObjCFoundationCore.h"


//
// A MulleObjCInputStream is basically an NSData
// and a MulleObjCOutputStream is basically (and maybe actually) an
// NSMutableData. Conceivably you could use an NSFileHandle as a
// MulleObjCInputStream or MulleObjCOutputStream

@protocol MulleObjCInputStream < NSObject>

// named like NSFileHandle
- (NSData *) readDataOfLength:(NSUInteger) length;

@end


PROTOCOLCLASS_INTERFACE( MulleObjCOutputStream, NSObject)

- (void) mulleWriteBytes:(void *) bytes
                  length:(NSUInteger) length;

@optional
- (void) writeData:(NSData *) data;

PROTOCOLCLASS_END();


#pragma mark - Concrete helper


@interface MulleObjCInMemoryInputStream : NSObject < MulleObjCInputStream >
{
   NSData          *_data;
   unsigned char   *_current;
   unsigned char   *_sentinel;
}

- (instancetype) initWithData:(NSData *) data;
- (NSData *) readDataOfLength:(NSUInteger) length;

@end


@interface NSMutableData( MulleObjCOutputStream) < MulleObjCOutputStream >

- (void) writeData:(NSData *) data;
- (void) mulleWriteBytes:(void *) bytes
                  length:(NSUInteger) length;
@end


#define _MulleObjCMemoryOutputDataStream    NSMutableData

// make it known, that NSFileHandle nicely supports streams as is
//@interface NSFileHandle( MulleObjCOutputStream) < MulleObjCInputStream, MulleObjCOutputStream >
//@end
