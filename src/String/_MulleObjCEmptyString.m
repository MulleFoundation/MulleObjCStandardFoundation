/*
 *  MulleFoundation - the mulle-objc class library
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


- (mulle_utf8_t *) _fastUTF8Characters
{
   return( (mulle_utf8_t *) "");
}


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   if( range.location || range.length)
      MulleObjCThrowInvalidRangeException( range);
}

@end
