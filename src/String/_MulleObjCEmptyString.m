/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  MulleObjCEmptyString+NSUTF8String.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCEmptyString.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCEmptyString

- (unichar) characterAtIndex:(NSUInteger) index
{
   MulleObjCThrowInvalidIndexException( index);
}


- (NSUInteger) _UTF8StringLength
{ 
   return( 0); 
}


- (NSUInteger) length
{
   return( 0);
}


- (char *) _fastASCIIStringContents
{
   return( "");
}


- (mulle_utf8_t *) _fastUTF8StringContents
{
   return( (mulle_utf8_t *) "");
}

@end
