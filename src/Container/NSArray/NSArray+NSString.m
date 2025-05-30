//
//  NSArray+NSString.m
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
#pragma clang diagnostic ignored "-Wparentheses"

#import "NSArray+NSString.h"

// other files in this library
#import "MulleObjCContainerDescription.h"

// std-c and dependencies
#import "import-private.h"


@implementation NSArray( NSString)

- (NSString *) componentsJoinedByString:(NSString *) separator
{
   SEL               selAppend;
   IMP               impAppend;
   NSMutableString   *buffer;
   NSString          *s;
   NSString          *sep;

   switch( [self count])
   {
   case 0 : return( @"");
   case 1 : return( [self lastObject]);
   }

   buffer    = [NSMutableString string];
   selAppend = @selector( appendString:);
   impAppend = [buffer methodForSelector:selAppend];

   sep = nil;
   for( s in self)
   {
      (*impAppend)( buffer, selAppend, sep);
      (*impAppend)( buffer, selAppend, s);
      sep = separator;
   }
   return( buffer);
}


static struct MulleObjCObjectContainerDescriptionInfo  info =
{
   .opener        = @"(",
   .closer        = @")",
   .empty         = @"()",
   .separator     = @",",
   .lastSeparator = @"\n",
   .indent        = @"\n    " // 4 spaces for mulle test
};


- (NSString *) mulleDescriptionWithSelector:(SEL) sel
{
   return( MulleObjCObjectContainerDescriptionWithSelector( self, sel, &info));
}


- (NSString *) description
{
   return( [self mulleDescriptionWithSelector:@selector( mulleQuotedDescriptionIfNeeded)]);
}


- (NSString *) mulleDebugContentsDescription      MULLE_OBJC_THREADSAFE_METHOD
{
   return( [self mulleDescriptionWithSelector:@selector( debugDescription)]);
}


@end
