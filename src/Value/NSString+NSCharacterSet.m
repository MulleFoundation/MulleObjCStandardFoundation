//
//  NSString+NSCharacterSet.m
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

#import "NSString+NSCharacterSet.h"

// other files in this library
#import "NSCharacterSet.h"
#import "NSString+Search.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardExceptionFoundation.h"

// std-c and dependencies
#import "import-private.h"


// what's the point of this warning, anyway ?
#pragma clang diagnostic ignored "-Wparentheses"
#pragma clang diagnostic ignored "-Wint-to-void-pointer-cast"


// other libraries of MulleObjCStandardFoundation

// std-c and dependencies

@implementation NSString (NSCharacterSet)

- (NSString *) stringByTrimmingCharactersInSet:(NSCharacterSet *) set
{
   NSRange   startRange;
   NSRange   endRange;
   NSRange   range;
   NSRange   originalRange;

   originalRange = NSRangeMake( 0, [self length]);

   startRange = [self mulleRangeOfCharactersFromSet:set
                                            options:0
                                              range:originalRange];
   endRange   = [self mulleRangeOfCharactersFromSet:set
                                            options:NSBackwardsSearch
                                              range:originalRange];

   if( startRange.length)
   {
      range.location = startRange.length;
      if( endRange.length)
         range.length = endRange.location;
      else
         range.length = originalRange.length - range.location;
   }
   else
   {
      if( ! endRange.length)
         return( self);

      range.location = 0;
      range.length   = endRange.location;
   }
   return( [self substringWithRange:range]);
}

@end

