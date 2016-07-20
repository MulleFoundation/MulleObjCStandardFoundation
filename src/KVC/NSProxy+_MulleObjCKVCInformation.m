/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSProxy+NSKVCInformation.m,v 94531dccc5a4 2008/06/05 10:13:59 nat $
 *
 *  $Log$
 */
#import <MulleObjC/MulleObjC.h>

// other files in this library
#import "NSObject+KeyValueCoding.h"
#import "_MulleObjCKVCInformation.h"

// other libraries of MulleObjCFoundation

// std-c and other dependencies


@implementation NSProxy ( _MulleObjCKVCInformation)

- (void) _divineKVCInformation:(struct _MulleObjCKVCInformation *) info
                        forKey:(NSString *) key
                    methodType:(enum _MulleObjCKVCMethodType) type
{
   Class   cls;

   cls = isa;
   switch( type)
   {
   case _MulleObjCKVCValueForKeyIndex :
      __MulleObjCDivineValueForKeyKVCInformation( info, cls, key, _MulleObjCKVCGenericMethodOnly);
      break;
      
   case _MulleObjCKVCStoredValueForKeyIndex :
      __MulleObjCDivineStoredValueForKeyKVCInformation( info, cls, key, _MulleObjCKVCGenericMethodOnly);
      break;
      
   case _MulleObjCKVCTakeValueForKeyIndex :
      __MulleObjCDivineTakeValueForKeyKVCInformation( info, cls, key, _MulleObjCKVCGenericMethodOnly);
      break;
      
   case _MulleObjCKVCTakeStoredValueForKeyIndex :
      __MulleObjCDivineTakeStoredValueForKeyKVCInformation( info, cls, key, _MulleObjCKVCGenericMethodOnly);
      break;
   }
}

@end
