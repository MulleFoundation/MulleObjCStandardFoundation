/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  _MulleObjCPropertyListReader.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, __MyCompanyName__ 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCUTF8StreamReader.h"


@interface _MulleObjCPropertyListReader : _MulleObjCUTF8StreamReader
{
@public
   Class   nsArrayClass;   
   Class   nsSetClass;
   Class   nsDictionaryClass;   
   Class   nsStringClass;      
   Class   nsDataClass;   
}

- (void) setMutableContainers:(BOOL) flag;
- (void) setMutableLeaves:(BOOL) flag;

@end
