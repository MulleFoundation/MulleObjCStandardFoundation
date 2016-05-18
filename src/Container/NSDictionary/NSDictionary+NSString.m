//
//  NSDictionary+NSString.m
//  MulleObjCFoundation
//
//  Created by Nat! on 03.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
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
