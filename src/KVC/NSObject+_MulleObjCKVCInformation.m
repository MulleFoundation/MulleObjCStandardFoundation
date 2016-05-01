/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSObject+NSKVCInformation.m,v b9a3127cf1df 2010/08/11 16:35:38 nat $
 *
 *  $Log$
 */
#import "NSObject+_MulleObjCKVCInformation.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and other dependencies



@implementation NSObject ( _MulleObjCKVCInformation)

//
// still defined by Mac OS X
//
+ (BOOL) accessInstanceVariablesDirectly
{
   return( YES);
}


+ (BOOL) __accessInstanceVariablesDirectly
{
   return( YES);
}

// 
// still defined by Mac OS X
//
+ (BOOL) useStoredAccessor
{
   return( YES);
}


+ (BOOL) __useStoredAccessor
{
   return( YES);
}


static inline unsigned int   kvcMaskForMethodOfType( NSObject *self, _MulleObjCKVCMethodType type)
{
   unsigned int   mask;
   
   mask = _MulleObjCKVCGenericMethodOnly;
   if( _MulleObjCKVCIsUsingDefaultMethodOfType( [self class], type))
      mask = _MulleObjCKVCStandardMask;

   return( mask);
}


+ (unsigned int) _kvcMaskForMethodOfType:(_MulleObjCKVCMethodType) type
{
   return( kvcMaskForMethodOfType( (id) self, type));
}


+ (void) _divineTakeStoredValueForKeyKVCInformation:(struct _MulleObjCKVCInformation *) info
                                               key:(NSString *) key
{
   unsigned int   mask;
   
   if( ! [self useStoredAccessor])
   {
      [self _divineTakeValueForKeyKVCInformation:info
                                            key:key];
      return;
   }
   
   mask = kvcMaskForMethodOfType( (id) self, _MulleObjCKVCTakeStoredValueForKeyIndex);
   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( info, self, key, mask);
}


+ (void) _divineTakeValueForKeyKVCInformation:(struct _MulleObjCKVCInformation *) info
                                         key:(NSString *) key
{
   unsigned int   mask;

   mask = kvcMaskForMethodOfType( (id) self, _MulleObjCKVCTakeValueForKeyIndex);
   __MulleObjCDivineTakeValueForKeyKVCInformation( info, self, key, mask);
}


+ (void) _divineStoredValueForKeyKVCInformation:(struct _MulleObjCKVCInformation *) info
                                           key:(NSString *) key
{
   unsigned int   mask;
   
   if( ! [self useStoredAccessor])
   {
      [self _divineValueForKeyKVCInformation:info
                                        key:key];
      return;
   }
   
   mask = kvcMaskForMethodOfType( (id) self, _MulleObjCKVCStoredValueForKeyIndex);
   __MulleObjCDivineStoredValueForKeyKVCInformation( info, self, key, mask);
}


+ (void) _divineValueForKeyKVCInformation:(struct _MulleObjCKVCInformation *) info
                                     key:(NSString *) key
{
   unsigned int   mask;
   
   mask = kvcMaskForMethodOfType( (id) self, _MulleObjCKVCValueForKeyIndex);
   __MulleObjCDivineValueForKeyKVCInformation( info, self, key, mask);
}

@end
