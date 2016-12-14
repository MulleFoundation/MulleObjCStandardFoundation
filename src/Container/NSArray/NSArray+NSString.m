//
//  NSArray+NSString.m
//  MulleObjCFoundation
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
#import "NSArray+NSString.h"

// other files in this library
#import "NSEnumerator.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@implementation NSArray( NSString)

- (NSString *) componentsJoinedByString:(NSString *) separator
{
   NSEnumerator      *rover;
   SEL               selNext;
   IMP               impNext;
   SEL               selAppend;
   IMP               impAppend;
   NSMutableString   *buffer;
   NSString          *s;
   
   switch( [self count])
   {
   case 0 : return( @"");
   case 1 : return( [self lastObject]);
   }
   
   buffer    = [NSMutableString string];
   selAppend = @selector( appendString:);
   impAppend = [buffer methodForSelector:selAppend];

   rover  = [self objectEnumerator];
   selNext = @selector( nextObject);
   impNext = [rover methodForSelector:selNext];

   s = (*impNext)( rover, selNext, NULL);
   (*impAppend)( buffer, selAppend, s);
   
   while( s = (*impNext)( rover, selNext, NULL))
   {
      (*impAppend)( buffer, selAppend, separator);
      (*impAppend)( buffer, selAppend, s);
   }
   return( buffer);
}


BOOL   NSArrayCompatibleDescription = YES;

- (NSString *) _descriptionWithSelector:(SEL) sel
{
   NSMutableString   *s;
   NSEnumerator      *rover;
   BOOL              flag;
   id                p;
   NSString          *initalSpaceOne;
   NSString          *initalSpaceMany;
   NSString          *secondSpace;
   NSString          *firstNewLine;
   NSUInteger        count;
   
   count = [self count];
   if( ! count)
      return( NSArrayCompatibleDescription ? @"(\n)" : @"()");

   if( NSArrayCompatibleDescription)
   {
      initalSpaceOne  = @"\n    ";
      initalSpaceMany = @"\n";
      secondSpace     = @"    ";
      firstNewLine    = @"\n";
   }
   else
   {
      initalSpaceOne  = @" ";
      initalSpaceMany = @"\n";
      secondSpace     = @"   ";
      firstNewLine    = @" ";
   }

   flag  = NO;
   s     = [NSMutableString stringWithString:@"("];
   if( count > 1)
      [s appendString:initalSpaceMany];
   else
      [s appendString:initalSpaceOne];

   rover = [self objectEnumerator];
   while( p = [rover nextObject])
   {
      if( flag)
         [s appendString:@",\n"];
      flag = YES;

      if( count > 1)
         [s appendString:secondSpace];

      [s appendString:[p performSelector:sel]];
   }

   if( count == 1)
      [s appendString:firstNewLine];
   else
      [s appendString:@"\n"];

   [s appendString:@")"];

   return( s);
}


- (NSString *) description
{
   return( [self _descriptionWithSelector:_cmd]);
}


- (NSString *) _debugContentsDescription
{
   return( [self _descriptionWithSelector:_cmd]);
}


@end
