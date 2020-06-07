//
//  NSNumber+PropertyListPrinting.m
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

#import "NSNumber+PropertyListPrinting.h"

// other files in this library
#import "NSString+PropertyListPrinting.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardFoundationLocale.h"

// private classes of MulleObjCValueFoundation
#import <MulleObjCValueFoundation/_MulleObjCConcreteNumber.h>
#import <MulleObjCValueFoundation/_MulleObjCTaggedPointerIntegerNumber.h>
#import <MulleObjCValueFoundation/private/NSNumber-Private.h>

// std-c and dependencies


@implementation NSNumber( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                               indent:(NSUInteger) indent
{
   NSString   *s;
   NSData     *data;

   s  = [self descriptionWithLocale:_MulleObjCPropertyListCanonicalPrintingLocale];
   [s mulleWriteToStream:handle
           usingEncoding:NSUTF8StringEncoding];
}


- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   NSString   *s;

   s = [self descriptionWithLocale:_MulleObjCJSONCanonicalPrintingLocale];
   [s mulleWriteToStream:handle
           usingEncoding:NSUTF8StringEncoding];
}

@end



@implementation _MulleObjCBoolNumber( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                               indent:(NSUInteger) indent
{
   if( [self boolValue])
      [handle mulleWriteBytes:"YES"
                       length:3];
   else
      [handle mulleWriteBytes:"NO"
                       length:2];
}

- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   if( [self boolValue])
      [handle mulleWriteBytes:"true"
                       length:4];
   else
      [handle mulleWriteBytes:"false"
                       length:5];
}

@end


@implementation NSNull( PropertyListPrinting)

- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   [handle mulleWriteBytes:"null"
                    length:4];
}

@end


//
// integer values are not dependent on locale so...
//
static void   printNumberToStream( NSNumber *self, id <MulleObjCOutputStream> handle)
{
   char                      tmp[ 64];
   struct mulle_ascii_data   data;
   struct mulle_ascii_data   string;

   string = [self _mulleConvertToASCIICharacters:mulle_ascii_data_make( tmp, sizeof( tmp))];
   [handle mulleWriteBytes:string.characters
                    length:string.length];
}


@implementation _MulleObjCUInt64Number( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                               indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

@end


@implementation _MulleObjCUInt32Number( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                               indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

@end


@implementation _MulleObjCInt32Number( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                               indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

@end


@implementation _MulleObjCInt64Number( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                               indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

@end



@implementation _MulleObjCTaggedPointerIntegerNumber( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                               indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

- (void) jsonUTF8DataToStream:(id <MulleObjCOutputStream>) handle
                       indent:(NSUInteger) indent
{
   printNumberToStream( self, handle);
}

@end

