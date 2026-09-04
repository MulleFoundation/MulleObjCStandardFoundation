//
//  NSArray+StringComponents.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
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
// Routines specifically written for componentsSeparatedBy...
//
@interface NSArray( StringComponents)

+ (instancetype) _mulleArrayFromASCIIData:(struct mulle_asciidata) buf
                             pointerQueue:(struct mulle__pointerqueue *) offsets
                                   stride:(NSUInteger) sepLen
                            sharingObject:(id) object;

//
// sepLen==-1 is special as it will consume one utf32 character after each string
// (works for any UTF8). otherwise sepLen is the number of utf8 bytes
//
+ (instancetype) mulleArrayFromUTF8Data:(struct mulle_utf8data) buf
                           pointerQueue:(struct mulle__pointerqueue *) offsets
                                 stride:(NSUInteger) sepLen
                           sharingObject:(id) object;

// sepLen==0 will consume one utf character after each string
// works only if data is utf15 really though!
+ (instancetype) _mulleArrayFromUTF16Data:(struct mulle_utf16data) buf
                             pointerQueue:(struct mulle__pointerqueue *) offsets
                                   stride:(NSUInteger) sepLen
                           sharingObject:(id) object;

// sepLen==0 will consume one utf character after each string
+ (instancetype) mulleArrayFromUTF32Data:(struct mulle_utf32data) buf
                            pointerQueue:(struct mulle__pointerqueue *) offsets
                                  stride:(NSUInteger) sepLen
                           sharingObject:(id) object;

@end

