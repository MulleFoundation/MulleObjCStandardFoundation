/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: struct _MulleObjCKVCInformation.h,v e5b08b0445dc 2010/01/05 12:27:23 nat $
 *
 *  $Log$
 */
#import "_MulleObjCInstanceVariableAccess.h"

#import <MulleObjC/NSObject+KVCSupport.h>


@class NSString;



typedef enum
{
   _MulleObjCKVCGenericMethodOnly      = 0x0,
   _MulleObjCKVCUnderscoreMethodBit    = 0x1,
   _MulleObjCKVCMethodBit              = 0x2,
   _MulleObjCKVCUnderscoreIvarBit      = 0x4,
   _MulleObjCKVCIvarBit                = 0x8,
   _MulleObjCKVCUnderscoreGetMethodBit = 0x10,
   _MulleObjCKVCGetMethodBit           = 0x20,
   _MulleObjCKVCStandardMask           = 0x7FFF
} _MulleObjCKVCMethodMask;   


void   __MulleObjCDivineValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineTakeValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);
void   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask);


static inline void   _MulleObjCDivineValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   __MulleObjCDivineValueForKeyKVCInformation( p, aClass, key, _MulleObjCKVCStandardMask);
}


static inline void   _MulleObjCDivineStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   __MulleObjCDivineStoredValueForKeyKVCInformation( p, aClass, key, _MulleObjCKVCStandardMask);
}


static inline void   _MulleObjCDivineTakeValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   __MulleObjCDivineTakeValueForKeyKVCInformation( p, aClass, key, _MulleObjCKVCStandardMask);
}


static inline void   _MulleObjCDivineTakeStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( p, aClass, key, _MulleObjCKVCStandardMask);
}


BOOL   _MulleObjCKVCIsUsingDefaultMethodOfType( Class aClass, enum _MulleObjCKVCMethodType type);
BOOL   _MulleObjCKVCIsUsingSameMethodOfTypeAsClass( Class aClass, enum _MulleObjCKVCMethodType type, Class referenceClass);
void   _MulleObjCKVCInformationUseUnboundKeyMethod( struct _MulleObjCKVCInformation *p, Class aClass, BOOL isSetter);

void   __MulleObjCSetObjectValueWithAccessorForType( id obj, SEL sel, id value, IMP imp, char valueType);
id     __MulleObjCGetObjectValueWithAccessorForType( id obj, SEL sel, IMP imp, char valueType);


static inline void   _MulleObjCSetObjectValueWithKVCInformation( id obj, id value, struct _MulleObjCKVCInformation *info)
{
   if( ! info->implementation)
   {
      _MulleObjCSetInstanceVariableForType( obj, info->offset, value, info->valueType);
      return;
   }
   
   switch( info->valueType)
   {
   case _C_CLASS     :
   case _C_COPY_ID   :
   case _C_ASSIGN_ID :
   case _C_RETAIN_ID :
      (*info->implementation)( obj, info->selector, value);
      return;
   }
   __MulleObjCSetObjectValueWithAccessorForType( obj, info->selector, value, info->implementation, info->valueType);
}


static inline id   _MulleObjCGetObjectValueWithKVCInformation( id obj, struct _MulleObjCKVCInformation *info)
{
   if( ! info->implementation)
      return( _MulleObjCGetInstanceVariableForType( obj, info->offset, info->valueType));
   
   switch( info->valueType)
   {
   case _C_CLASS   :
   case _C_COPY_ID :
   case _C_ASSIGN_ID :
   case _C_RETAIN_ID :
      return( (*info->implementation)( obj, info->selector, NULL));
   }
   return( __MulleObjCGetObjectValueWithAccessorForType( obj, info->selector, info->implementation, info->valueType));
}
