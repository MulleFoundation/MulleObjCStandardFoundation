//
//  NSSortDescriptor.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2006 Nat! - Mulle kybernetiK.
//  Copyright (c) 2006 Codeon GmbH.
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
#import "NSSortDescriptor.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@implementation NSSortDescriptor

+ (NSSortDescriptor *) sortDescriptorWithKey:(NSString *) key
                                   ascending:(BOOL) ascending
                                    selector:(SEL) sel
{
   return( [[[self alloc] initWithKey:key
                            ascending:ascending
                             selector:sel] autorelease]);
}


+ (NSSortDescriptor *) sortDescriptorWithKey:(NSString *) key
                                   ascending:(BOOL) ascending
{
   return( [[[self alloc] initWithKey:key
                            ascending:ascending
                             selector:@selector( compare:)] autorelease]);
}



- (instancetype) initWithKey:(NSString *) key
         ascending:(BOOL) ascending
          selector:(SEL) selector
{

   NSParameterAssert( [key isKindOfClass:[NSString class]]);
   NSParameterAssert( selector);

   self = [self init];
   assert( self);

   _key       = [key copy];
   _selector  = selector;
   _ascending = ascending;
   return( self);
}


- (instancetype) initWithKey:(NSString *) key
         ascending:(BOOL) ascending
{
   return( [self initWithKey:key
                  ascending:ascending
                   selector:@selector( compare:)]);
}


- (void) dealloc
{
   [_key release];
   [super dealloc];
}


#pragma mark -
#pragma mark NSCopying

- (id) copy
{
   return( [self retain]);  // we are immutable!
}


#pragma mark -
#pragma mark petty accessors

- (NSString *) key
{
   return( _key);
}


- (BOOL) ascending
{
   return( _ascending);
}


- (SEL) selector
{
   return( _selector);
}


#pragma mark -
#pragma mark operations


// maximally naive implementation for now
NSComparisonResult   MulleObjCSortDescriptorArrayCompare( id a, id b, NSArray *descriptors)
{
   NSComparisonResult   result;
   NSSortDescriptor     *descriptor;

   for( descriptor in descriptors)
   {
      result = [descriptor compareObject:a
                                toObject:b];
      if( result != NSOrderedSame)
         return( result);
   }

   return( NSOrderedSame);
}


- (NSSortDescriptor *) reversedSortDescriptor
{
   return( [NSSortDescriptor sortDescriptorWithKey:_key
                                         ascending:! _ascending
                                          selector:_selector]);
}


- (NSString *) description
{
   return( [NSString stringWithFormat:@"%@ %@ %s", _key, NSStringFromSelector( _selector), _ascending ? "asc" : "desc"]);
}

@end
