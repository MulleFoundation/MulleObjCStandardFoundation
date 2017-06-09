//
//  NSNumber+NSString.m
//  MulleObjCFoundation
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

#import "NSNumber+NSString.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c dependencies


@implementation NSNumber (NSString)

//
// default implementation, actually it's kinda good enough
// but there are also overrides in _MulleObjCConcreteNumber+NSString.m
//
- (NSString *) stringValue
{
   char   *type;

   type = [self objCType];
   switch( *type)
   {
   default :
      return( [NSString stringWithFormat:@"%ld", [self longValue]]);

   case _C_UCHR :
   case _C_USHT :
   case _C_UINT :
   case _C_ULNG :
      return( [NSString stringWithFormat:@"%lu", [self unsignedLongValue]]);

   case _C_LNG_LNG :
      return( [NSString stringWithFormat:@"%lld", [self longLongValue]]);
   case _C_ULNG_LNG :
      return( [NSString stringWithFormat:@"%llu", [self unsignedLongLongValue]]);

   case _C_FLT :
   case _C_DBL :
      return( [NSString stringWithFormat:@"%f", [self doubleValue]]);

   case _C_LNG_DBL :
      return( [NSString stringWithFormat:@"%Lf", [self longDoubleValue]]);

   }
}


- (NSString *) description
{
   return( [self stringValue]); // or localize
}


- (NSString *) _debugContentsDescription
{
   return( [self description]);
}

@end
