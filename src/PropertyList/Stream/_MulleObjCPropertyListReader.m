/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _MulleObjCPropertyListReader.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, __MyCompanyName__ 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCPropertyListReader.h"

// other files in this library
#import "_MulleObjCPropertyListReader+InlineAccessors.h"
#import "_MulleObjCBufferedDataInputStream.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCPropertyListReader

- (id) initWithBufferedInputStream:(_MulleObjCBufferedDataInputStream *) stream
{
   //
   // this will consume first character
   //
   self = [super initWithBufferedInputStream:stream];
   if( self)
   {
      _MulleObjCPropertyListReaderSkipWhite( self); // dial up to first interesting char
   }
   return( self);
}

//- (id) init
//{
//   [super init];
//   
//   [self setMutableContainers:NO];
//   [self setMutableLeaves:NO];
//   
//   return( self);
//}
   
- (void) setMutableContainers:(BOOL) flag
{
   if( flag)
   {
      nsArrayClass      = [NSMutableArray class];
      nsSetClass        = [NSMutableSet class];
      nsDictionaryClass = [NSMutableDictionary class];   
      return;
   }

   nsArrayClass      = [NSArray class];
   nsSetClass        = [NSSet class];
   nsDictionaryClass = [NSDictionary class];   
}


- (void) setMutableLeaves:(BOOL) flag
{
   if( flag)
   {
      nsStringClass = [NSMutableString class];
      nsDataClass   = [NSMutableData class];
      return;
   }

   nsStringClass = [NSString class];
   nsDataClass   = [NSData class];
}

@end
