//
//  NSNumber+NSLocale.m
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

#import "NSNumber+NSLocale.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "NSLocale.h"
#import "NSNumberFormatter.h"
#import "NSString+NSLocale.h"


// std-c and dependencies


@implementation NSNumber (NSLocale)


//
// compatibly implemented, but NSString initWithFormat:locale is missing
//
- (NSString *) descriptionWithLocale:(NSLocale *) locale
{
   char  *type;

   type = [self objCType];
   switch( *type)
   {
   default :
      return( [[[NSString alloc] initWithFormat:@"%ld"
                                         locale:locale,
                                                 [self longValue]] autorelease]);

   case _C_CHR :
      return( [[[NSString alloc] initWithFormat:@"%i"
                                         locale:locale,
                                                 [self unsignedCharValue]] autorelease]);
   case _C_UCHR :
      return( [[[NSString alloc] initWithFormat:@"%u"
                                         locale:locale,
                                                 [self unsignedCharValue]] autorelease]);
   case _C_SHT :
      return( [[[NSString alloc] initWithFormat:@"%hi"
                                         locale:locale,
                                                 [self shortValue]] autorelease]);
   case _C_USHT :
      return( [[[NSString alloc] initWithFormat:@"%hu"
                                         locale:locale,
                                                 [self unsignedShortValue]] autorelease]);
   case _C_INT :
      return( [[[NSString alloc] initWithFormat:@"%d"
                                         locale:locale,
                                                 [self intValue]] autorelease]);
   case _C_UINT :
      return( [[[NSString alloc] initWithFormat:@"%u"
                                         locale:locale,
                                                 [self unsignedIntValue]] autorelease]);
   case _C_LNG :
      return( [[[NSString alloc] initWithFormat:@"%ld"
                                         locale:locale,
                                                 [self longValue]] autorelease]);
   case _C_ULNG :
      return( [[[NSString alloc] initWithFormat:@"%lu"
                                         locale:locale,
                                                 [self unsignedLongValue]] autorelease]);
   case _C_LNG_LNG :
      return( [[[NSString alloc] initWithFormat:@"%lld"
                                         locale:locale,
                                                 [self longLongValue]] autorelease]);
   case _C_ULNG_LNG :
      return( [[[NSString alloc] initWithFormat:@"%llu"
                                         locale:locale,
                                                 [self unsignedLongLongValue]] autorelease]);

   case _C_FLT :
      return( [[[NSString alloc] initWithFormat:@"%0.8g"
                                         locale:locale,
                                                 [self floatValue]] autorelease]);
   case _C_DBL :
      return( [[[NSString alloc] initWithFormat:@"%0.17g"
                                         locale:locale,
                                                 [self doubleValue]] autorelease]);
   case _C_LNG_DBL :
      return( [[[NSString alloc] initWithFormat:@"%0.21Lg"
                                         locale:locale,
                                                 [self longDoubleValue]] autorelease]);
   }
}


@end
