/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSData+Unicode.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, __MyCompanyName__ 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "MulleObjCFoundationCore.h"

typedef enum
{
   _MulleObjCNoByteOrderMark,
   _MulleObjCUTF8ByteOrderMark,
   _MulleObjCUTF16LittleEndianByteOrderMark,
   _MulleObjCUTF16BigEndianByteOrderMark
} _MulleObjCByteOrderMark;


@interface NSData( Unicode)

- (_MulleObjCByteOrderMark) _byteOrderMark;

@end
