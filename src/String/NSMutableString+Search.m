//
//  NSMutableString.m
//  MulleObjCValueFoundation
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
#import "NSMutableString+Search.h"

// other files in this library
#import "NSString+Search.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardFoundationException.h"

// std-c and dependencies
#import "import-private.h"
#include <ctype.h>


@implementation NSMutableString( Search)

- (void) replaceOccurrencesOfString:(NSString *) s
                         withString:(NSString *) replacement
                            options:(NSStringCompareOptions) options
                              range:(NSRange) range
{
   NSRange      found;
   NSUInteger   r_length;
   NSUInteger   end;

   range = MulleObjCValidateRangeAgainstLength( range, _length);

   r_length = [replacement length];
   options &= NSLiteralSearch|NSCaseInsensitiveSearch|NSNumericSearch;

   for(;;)
   {
      found = [self rangeOfString:s
                          options:options
                            range:range];
      if( ! found.length)
         return;

      [self replaceCharactersInRange:found
                          withString:replacement];

      // mover over to end for next check
      end             = range.location + range.length;
      range.location  = found.location + found.length;
      range.length    = end - range.location;

      // adjust for change in length due to replacement
      range.location += r_length - found.length;
   }
}

@end
