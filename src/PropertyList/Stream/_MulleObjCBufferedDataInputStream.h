//
//  _MulleObjCBufferedDataInputStream.h
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

#import "_MulleObjCDataStream.h"


//
// _MulleObjCBufferedDataInputStream is an abstraction to be used if reading
// or writing to NSFilehandles
//
typedef struct
{
   unsigned char   *bytes;
   size_t          length;
} MulleObjCMemoryRegion;



@interface _MulleObjCBufferedDataInputStream : NSObject < _MulleObjCInputDataStream>
{
#ifdef _MULLE_OBJC_BUFFERED_DATA_INPUT_STREAM_IVAR_VISIBILITY
_MULLE_OBJC_BUFFERED_DATA_INPUT_STREAM_IVAR_VISIBILITY      // allow public access for internal use
#endif
   id <_MulleObjCInputDataStream >  _stream;

   NSData          *_data;
   unsigned char   *_current;
   unsigned char   *_sentinel;

   unsigned char   *_bookmark;
   NSMutableData   *_bookmarkData;
}

- (instancetype) initWithData:(NSData *) data;
- (instancetype) initWithInputStream:(id <_MulleObjCInputDataStream>) stream;

- (NSData *) readDataOfLength:(NSUInteger) size;

// you can only set one bookmark
- (void) bookmark;

// this returns the bookmark and clears it. use bytes before getting next
// character...
- (MulleObjCMemoryRegion) bookmarkedRegion;   // usually better
- (NSData *) bookmarkedData;            // use if you want a NSData anyway

@end
