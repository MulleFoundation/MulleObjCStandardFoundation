/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: _MulleObjCInstanceVariableAccess.h,v 94531dccc5a4 2008/06/05 10:13:59 nat $
 *
 *  $Log$
 */
#import <MulleObjC/MulleObjC.h>


void   _MulleObjCSetInstanceVariableForType( id p, unsigned int offset, id value, char valueType);
id     _MulleObjCGetInstanceVariableForType( id p, unsigned int offset, char valueType);
