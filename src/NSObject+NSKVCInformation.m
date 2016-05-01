/*
 *  _NSEOFoundation - Base Functionality of _NSEOF (Project Titmouse) 
 *                      Part of the _NS EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _NS kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSObject+NSKVCInformation.m,v b9a3127cf1df 2010/08/11 16:35:38 nat $
 *
 *  $Log$
 */
#import "NSObject+NSKVCInformation.h"

#import "_MulleObjCKeyValueCodingFoundation.h"



@implementation NSObject ( _NSKVCInformation)

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


static inline unsigned int   kvcMaskForMethodOfType( NSObject *self, _NSKVCMethodType type)
{
   unsigned int   mask;
   
   mask = _NSKVCGenericMethodOnly;
   if( _NSKVCIsUsingDefaultMethodOfType( _NSObjCIsa( self), type))
      mask = _NSKVCStandardMask;

   return( mask);
}


+ (unsigned int) _kvcMaskForMethodOfType:(_NSKVCMethodType) type
{
   return( kvcMaskForMethodOfType( self, type));
}


+ (void) _divineTakeStoredValueForKeyKVCInformation:(_NSKVCInformation *) info
                                               key:(NSString *) key
{
   unsigned int   mask;
   
   if( ! [self useStoredAccessor])
   {
      [self _divineTakeValueForKeyKVCInformation:info
                                            key:key];
      return;
   }
   
   mask = kvcMaskForMethodOfType( self, _NSKVCTakeStoredValueForKeyIndex);
   __NSDivineTakeStoredValueForKeyKVCInformation( info, self, key, mask);
}


+ (void) _divineTakeValueForKeyKVCInformation:(_NSKVCInformation *) info
                                         key:(NSString *) key
{
   unsigned int   mask;

   mask = kvcMaskForMethodOfType( self, _NSKVCTakeValueForKeyIndex);
   __NSDivineTakeValueForKeyKVCInformation( info, self, key, mask);
}


+ (void) _divineStoredValueForKeyKVCInformation:(_NSKVCInformation *) info
                                           key:(NSString *) key
{
   unsigned int   mask;
   
   if( ! [self useStoredAccessor])
   {
      [self _divineValueForKeyKVCInformation:info
                                        key:key];
      return;
   }
   
   mask = kvcMaskForMethodOfType( self, _NSKVCStoredValueForKeyIndex);
   __NSDivineStoredValueForKeyKVCInformation( info, self, key, mask);
}


+ (void) _divineValueForKeyKVCInformation:(_NSKVCInformation *) info
                                     key:(NSString *) key
{
   unsigned int   mask;
   
   mask = kvcMaskForMethodOfType( self, _NSKVCValueForKeyIndex);
   __NSDivineValueForKeyKVCInformation( info, self, key, mask);
}

@end
