/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSData+Unicode.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, __MyCompanyName__
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSData+Unicode.h"


@implementation NSData( _Unicode)

- (_MulleObjCByteOrderMark) _byteOrderMark;
{
   NSUInteger     len;
   unsigned char  *p;

   len = [self length];
   if( len < 2)
      return( _MulleObjCNoByteOrderMark);

// http://de.wikipedia.org/wiki/Byte_Order_Mark
//
//  Kodierung 	        hexadezimale Darstellung
//  UTF-8 	        EF BB BF[3]
//  UTF-16 (BE) 	FE FF
//  UTF-16 (LE) 	FF FE

   p = [self bytes];
   switch( *p)
   {
   case 0xEF :
      if( len >= 3 && p[ 1] == 0xBB && p[2] == 0xBF)
         return( _MulleObjCUTF8ByteOrderMark);
      break;

   case 0xFE :
      if( p[ 1] == 0xFF)
         return( _MulleObjCUTF16BigEndianByteOrderMark);
      break;

   case 0xFF :
      if( p[ 1] == 0xFE)
         return( _MulleObjCUTF16LittleEndianByteOrderMark);
      break;
   }
   return( _MulleObjCNoByteOrderMark);
}

@end
