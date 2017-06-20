//
//  _MulleObjCConcreteNumber.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "NSNumber.h"


@interface _MulleObjCInt8Number : NSNumber
{
   int8_t  _value;
}

+ (instancetype) newWithInt8:(int8_t) value;

@end


@interface _MulleObjCInt16Number : NSNumber
{
   int16_t  _value;
}

+ (instancetype) newWithInt16:(int16_t) value;

@end


@interface _MulleObjCInt32Number : NSNumber
{
   int32_t  _value;
}

+ (instancetype) newWithInt32:(int32_t) value;

@end


@interface _MulleObjCInt64Number : NSNumber
{
   int64_t  _value;
}

+ (instancetype) newWithInt64:(int64_t) value;

@end


#pragma mark -
#pragma mark unsigned variants (8/16 superflous)


@interface _MulleObjCUInt32Number : NSNumber
{
   uint32_t  _value;
}

+ (instancetype) newWithUInt32:(uint32_t) value;

@end


@interface _MulleObjCUInt64Number : NSNumber
{
   uint64_t  _value;
}

+ (instancetype) newWithUInt64:(uint64_t) value;

@end


// assume float losslessly converts to double and back
@interface _MulleObjCDoubleNumber : NSNumber
{
   double   _value;
}

+ (instancetype) newWithDouble:(double) value;

@end


@interface _MulleObjCLongDoubleNumber : NSNumber
{
   long double   _value;
}

+ (instancetype) newWithLongDouble:(long double) value;

@end
