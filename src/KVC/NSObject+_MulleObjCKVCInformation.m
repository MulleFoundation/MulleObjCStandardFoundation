//
//  NSObject+_MulleObjCKVCInformation.m
//  MulleObjCFoundation
//
//  Copyright (c) 2006 Nat! - Mulle kybernetiK.
//  Copyright (c) 2006 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
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

   cls = [self class];
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
