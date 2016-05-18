/*
 *  MulleEOFoundation - Base Functionality of MulleEOF (Project Titmouse) 
 *                      Part of the Mulle EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, Mulle kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSSortDescriptor.m,v 766a39083b74 2010/08/27 11:38:26 nat $
 *
 *  $Log$
 */
#import "NSSortDescriptor.h"

// other files in this library
#import "NSObject+KeyValueCoding.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"
#import "MulleObjCFoundationValue.h"

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



- (id) initWithKey:(NSString *) key 
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


- (id) initWithKey:(NSString *) key 
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
#pragma mark NSCoding


/**/
- (id) initWithCoder:(NSCoder *) coder
{
   NSString   *s;
   
   self = [super init];
   if( ! self)
      return( self);
   
   [coder decodeValuesOfObjCTypes:"@@c", &_key, &s, &_ascending];
   _selector = NSSelectorFromString( s);
   
   return( self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSString   *s;

   s = NSStringFromSelector( _selector);
   [coder encodeValuesOfObjCTypes:"@@c", &_key, &s, &_ascending];
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


- (NSComparisonResult) compareObject:(id) a
                            toObject:(id) b
{
   NSComparisonResult   result;
   id    aValue;
   id    bValue;
   
   aValue = [a valueForKeyPath:_key];
   bValue = [b valueForKeyPath:_key];

   if( aValue == bValue)
      return( NSOrderedSame);
   
   result = (NSComparisonResult) [aValue performSelector:_selector
                                              withObject:bValue];
   return( _ascending ? result : -result);
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


