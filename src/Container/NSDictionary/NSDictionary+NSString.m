//
//  NSDictionary+NSString.m
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

#import "NSDictionary.h"

// other files in this library
#import "NSEnumerator.h"
#import "NSArray.h"
#import "NSDictionary+NSArray.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies




@implementation NSDictionary (NSString)

// it is convenient for testing to absolutely be
// identical in output to Apple Foundation

BOOL NSDictionaryCompatibleDescription = YES;


static BOOL   allKeysRespondToCompare( NSArray *keys)
{
   id   key;
   
   for( key in keys)
      if( ! [key respondsToSelector:@selector( compare:)])
         return( NO);
    return( YES);
}


- (NSString *) _descriptionWithSelector:(SEL) sel
{
   NSArray           *keys;
   NSMutableString   *s;
   NSString          *key;
   NSUInteger        count;
   id                value;
   NSString          *initalSpaceOne;
   NSString          *initalSpaceMany;
   NSString          *secondSpace;
   NSString          *firstNewLine;
   NSString          *secondNewLine;
   
   count = [self count];
   if( ! count)
      return( NSDictionaryCompatibleDescription ? @"{\n}" : @"{}");

   if( NSDictionaryCompatibleDescription)
   {
      initalSpaceOne  = @"\n    ";
      initalSpaceMany = @"\n";
      secondSpace     = @"    ";
      firstNewLine    = @"\n";
      secondNewLine   = @"\n";
   }
   else
   {
      initalSpaceOne  = @" ";
      initalSpaceMany = @"\n";
      secondSpace     = @"    ";
      firstNewLine    = @" ";
      secondNewLine   = @"\n";
   }
   
   s = [NSMutableString stringWithString:@"{"];
   if( count > 1)
      [s appendString:initalSpaceMany];
   else
      [s appendString:initalSpaceOne];

// TODO: If each key in the dictionary responds to compare:, the entries are listed
// in ascending order, by key. Otherwise, the order in which the entries are
// listed is undefined.


   keys = [self allKeys];
   if( NSDictionaryCompatibleDescription && allKeysRespondToCompare( keys))
      keys  = [[self allKeys] sortedArrayUsingSelector:@selector( compare:)];

   for( key in keys)
   {
      value = [self objectForKey:key];

      if( count > 1)
         [s appendString:secondSpace];

      [s appendString:[key performSelector:sel]];
      [s appendString:@" = "];
      [s appendString:[value performSelector:sel]];
      [s appendString:@";"];
      if( count > 1)
         [s appendString:secondNewLine];
   }

   if( count == 1)
      [s appendString:firstNewLine];
   [s appendString:@"}"];

   return( s);
}


- (id) description
{
   return( [self _descriptionWithSelector:_cmd]);
}


- (NSString *) _debugContentsDescription
{
   return( [self _descriptionWithSelector:_cmd]);
}

@end
