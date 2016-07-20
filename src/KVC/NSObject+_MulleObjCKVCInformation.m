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
#import <MulleObjC/NSObject+KVCSupport.h>



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


static inline unsigned int   kvcMaskForMethodOfType( Class cls, enum _MulleObjCKVCMethodType type)
{
   unsigned int   mask;
   
   mask = _MulleObjCKVCGenericMethodOnly;
   if( _MulleObjCKVCIsUsingDefaultMethodOfType( cls, type))
      mask = _MulleObjCKVCStandardMask;

   return( mask);
}


- (void) _divineKVCInformation:(struct _MulleObjCKVCInformation *) info
                        forKey:(NSString *) key
                    methodType:(enum _MulleObjCKVCMethodType) type
{
   unsigned int   mask;
   Class          cls;
   
   cls = isa;
   if( ! [cls useStoredAccessor])
      type &= (_MulleObjCKVCValueForKeyIndex|_MulleObjCKVCTakeValueForKeyIndex);

   switch( type)
   {
   case _MulleObjCKVCValueForKeyIndex :
      mask = kvcMaskForMethodOfType( cls, _MulleObjCKVCValueForKeyIndex);
      __MulleObjCDivineValueForKeyKVCInformation( info, cls, key, mask);
      break;
      
   case _MulleObjCKVCTakeValueForKeyIndex :
      mask = kvcMaskForMethodOfType( cls, _MulleObjCKVCTakeValueForKeyIndex);
      __MulleObjCDivineTakeValueForKeyKVCInformation( info, cls, key, mask);
      break;
      
   case _MulleObjCKVCStoredValueForKeyIndex :
      mask = kvcMaskForMethodOfType( cls, _MulleObjCKVCStoredValueForKeyIndex);
      __MulleObjCDivineStoredValueForKeyKVCInformation( info, cls, key, mask);
      break;
      
   case _MulleObjCKVCTakeStoredValueForKeyIndex :
      mask = kvcMaskForMethodOfType( cls, _MulleObjCKVCTakeStoredValueForKeyIndex);
      __MulleObjCDivineTakeStoredValueForKeyKVCInformation( info, cls, key, mask);
      break;
   }
}

@end
