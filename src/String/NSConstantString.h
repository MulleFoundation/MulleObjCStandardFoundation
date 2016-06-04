/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSConstantString.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCASCIIString.h"

// named NSConstantString, because it's compatible...
@interface NSConstantString : _MulleObjCASCIIString
{
   char           *_storage;   // ivar #0:: must be defined EXACTLY like this
   unsigned int   _length;     // ivar #1:: must be defined EXACTLY like this
}
@end

