/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: struct _MulleObjCKVCInformation.m,v b9a3127cf1df 2010/08/11 16:35:38 nat $
 *
 *  $Log$
 */
#import "_MulleObjCKVCInformation.h"

// other files in this library
#import "NSObject+_MulleObjCKVCInformation.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"
#import "MulleObjCFoundationValue.h"

// std-c and other dependencies
#include <ctype.h>


@interface NSString( Private)

- (NSUInteger) _UTF8StringLength;

@end


#ifndef NS_BLOCK_ASSERTIONS
static BOOL  isSupportedObjCType( char c)
{
   switch( c)
   {
   case _C_CHR : 
   case _C_UCHR :
   case _C_SHT : 
   case _C_USHT : 
      
   case _C_INT : 
   case _C_UINT : 
   case _C_LNG : 
   case _C_ULNG : 
      
   case _C_LNG_LNG : 
   case _C_ULNG_LNG : 
      
   case _C_FLT : 
   case _C_DBL : 
   case _C_LNG_DBL :
   case _C_ID  :
   case _C_ASSIGN_ID :
   case _C_COPY_ID   :
      return( YES);
   }
   return( NO);
}
#endif


static NSString  *_stringByCombiningPrefixAndCapitalizedKey( NSString *prefix,
                                                             NSString *key,
                                                             BOOL     tailColon)
{
   NSUInteger               prefix_len;
   NSUInteger               key_len;
   NSUInteger               len;
   uint8_t                  *buf;
   uint8_t                  c;
   NSString                 *s;
   struct mulle_allocator   *allocator;
   
   allocator  = MulleObjCAllocator();
   
   prefix_len = [prefix _UTF8StringLength];
   key_len    = [key _UTF8StringLength];
   
   if( key_len == 0)
      [NSException raise:NSInvalidArgumentException
                  format:@"Key must not be nil or the empty string"];

   len = key_len + prefix_len + (tailColon == YES);
   
   buf = (uint8_t *) mulle_allocator_malloc( allocator, len);

   [prefix getUTF8Characters:buf];
   [key getUTF8Characters:&buf[ prefix_len]];
   
   c = buf[ prefix_len];
   if( c >= 'a' && c <= 'z')
   {
      c -= 'a' - 'A';
      buf[ prefix_len] = c;
   }
 
   if( tailColon)
      buf[ len - 1] = ':';
         
   s = [[NSString alloc] _initWithUTF8CharactersNoCopy:buf
                                               length:len
                                            allocator:allocator];
   return( s);
}


static NSString  *stringByCombiningPrefixAndCapitalizedKey( NSString *prefix,
                                                            NSString *key,
                                                            BOOL     tailingColon)
{
   return( [_stringByCombiningPrefixAndCapitalizedKey( prefix, key, tailingColon) autorelease]);
}


// TODO: should optionally check if protected or private and issue a warning in 
//       debug mode on access for protected and abort (?) on private. Let it 
//       slide for release. Need to know caller for that, so here just get 
//       information and store it somewhere

static void   handle_ivar( struct _MulleObjCKVCInformation *p, char *cString, struct _mulle_objc_ivar *ivar)
{
   p->cKey      = MulleObjCDuplicateCString( cString);
   p->offset    = _mulle_objc_ivar_get_offset( ivar);
   p->valueType = _mulle_objc_ivar_get_signature( ivar)[ 0];
   
   NSCParameterAssert( isSupportedObjCType( p->valueType));
}


void   _MulleObjCClearKVCInformation( struct _MulleObjCKVCInformation *p)
{
   [p->key release];
   MulleObjCDeallocateMemory( p->cKey);
   
   p->key  = nil;
   p->cKey = NULL;
}


void   _MulleObjCKVCInformationSetDefaultValues( struct _MulleObjCKVCInformation *p, NSString *key)
{
   p->implementation = 0;
   p->selector       = 0;
   p->key            = [key copy];
   p->cKey           = 0;
   p->valueType      = _C_ID;
   p->offset         = 0;
}


void   _MulleObjCKVCInformationUseUnboundKeyMethod( struct _MulleObjCKVCInformation *p, Class aClass, BOOL isSetter)
{
   NSCParameterAssert( p->valueType == _C_ID);
   
   p->selector  = isSetter 
                     ? @selector( handleTakeValue:forUnboundKey:) 
                     : @selector( handleQueryWithUnboundKey:);

   p->implementation = [aClass instanceMethodForSelector:p->selector];
}


static BOOL   useInstanceMethod( struct _MulleObjCKVCInformation *p, Class aClass, NSString *methodName, BOOL isSetter)
{
   SEL                         sel;
   struct _mulle_objc_method   *method;
   char                        *type;
   char                        *s;
   
   sel    = NSSelectorFromString( methodName);
   method = mulle_objc_class_search_method( aClass, (mulle_objc_methodid_t) sel);

   if( ! method)
      return( NO);
   
#warning (nat) ugly fing hack. should parse method_types properly
   type  = _mulle_objc_method_get_signature( method);
   
   if( ! isSetter)
      p->valueType = type[ 0];
   else
   {
      s = &type[ strlen( type)];
      while( s > type && isdigit( *--s));
      p->valueType = s[ 0];
   }
   
   p->selector       = sel;
   p->implementation = (IMP) _mulle_objc_method_get_implementation( method);
   
   NSCParameterAssert( isSupportedObjCType( p->valueType));
   
   return( YES);
}


static BOOL   useInstanceVariable( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key)
{
   char                     *cString;
   struct _mulle_objc_ivar  *ivar;
   mulle_objc_ivarid_t      ivarid;
   
   // check for instance variable
   cString = (void *) [key UTF8String];
   ivarid  = mulle_objc_uniqueid_from_string( cString);
   ivar    = _mulle_objc_class_search_ivar( aClass, ivarid);
   if( ! ivar)
      return( NO);

   handle_ivar( p, cString, ivar);
   return( YES);
}


void   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask)
{
   NSString   *methodName;
   NSString   *underscoreMethodName;
   NSString   *underscoreName;
   
   _MulleObjCKVCInformationSetDefaultValues( p, key);
   
   methodName = stringByCombiningPrefixAndCapitalizedKey( @"set", key, YES);
   underscoreMethodName = [@"_" stringByAppendingString:methodName];
   
   // check for _setKey
   if( mask & _MulleObjCKVCUnderscoreMethodBit)
      if( useInstanceMethod( p, aClass, underscoreMethodName, YES))
         return;
   
   if( [aClass accessInstanceVariablesDirectly])
   {
      underscoreName = [@"_" stringByAppendingString:key];
      if( mask & _MulleObjCKVCUnderscoreIvarBit)
         if( useInstanceVariable( p, aClass, underscoreName))
            return;
   
      if( mask & _MulleObjCKVCIvarBit)
         if( useInstanceVariable( p, aClass, p->key))
            return;
   }
      
   if( mask & _MulleObjCKVCMethodBit)
      if( useInstanceMethod( p, aClass, methodName, YES))
         return;
   
   _MulleObjCKVCInformationUseUnboundKeyMethod( p, aClass, YES);
}


void   __MulleObjCDivineTakeValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask)
{
   NSString   *methodName;
   NSString   *underscoreMethodName;
   NSString   *underscoreName;
   
   _MulleObjCKVCInformationSetDefaultValues( p, key);
   
   methodName = stringByCombiningPrefixAndCapitalizedKey( @"set", key, YES);
   
   // check for _set<Key>:
   if( mask & _MulleObjCKVCMethodBit)  // sic!
      if( useInstanceMethod( p, aClass, methodName, YES))
         return;
   
   underscoreMethodName = [@"_" stringByAppendingString:methodName];
   if( mask & _MulleObjCKVCUnderscoreMethodBit)
      if( useInstanceMethod( p, aClass, underscoreMethodName, YES))
         return;
   
   if( [aClass accessInstanceVariablesDirectly])
   {
#warning (nat) this is apple bug compatible
      // this should be below _underscore
      if( mask & _MulleObjCKVCIvarBit)
         if( useInstanceVariable( p, aClass,key))
            return;

      underscoreName = [@"_" stringByAppendingString:key];
      if( mask & _MulleObjCKVCUnderscoreIvarBit)
         if( useInstanceVariable( p, aClass, underscoreName))
            return;
   }
   
   _MulleObjCKVCInformationUseUnboundKeyMethod( p, aClass, YES);
}


/*
 *  GETTER STUFF
 */
void   __MulleObjCDivineStoredValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask)
{
   NSString   *getMethodName;
   NSString   *underscoreGetMethodName;
   NSString   *underscoreName;
   
   _MulleObjCKVCInformationSetDefaultValues( p, key);
   
   getMethodName = stringByCombiningPrefixAndCapitalizedKey( @"get", key, NO);
   
   underscoreGetMethodName = [@"_" stringByAppendingString:getMethodName];
   if( mask & _MulleObjCKVCUnderscoreGetMethodBit)
      if( useInstanceMethod( p, aClass, underscoreGetMethodName, NO))
         return;
   
   underscoreName = [@"_" stringByAppendingString:key];
   if( mask & _MulleObjCKVCUnderscoreMethodBit)
      if( useInstanceMethod( p, aClass, underscoreName, NO))
         return;
   
   if( [aClass accessInstanceVariablesDirectly])
   {
      if( mask & _MulleObjCKVCUnderscoreIvarBit)
         if( useInstanceVariable( p, aClass, underscoreName))
            return;
      
      if( mask & _MulleObjCKVCIvarBit)
         if( useInstanceVariable( p, aClass, key))
            return;
   }
   
   if( mask & _MulleObjCKVCGetMethodBit)
      if( useInstanceMethod( p, aClass, getMethodName, NO))
         return;
   
   if( mask & _MulleObjCKVCMethodBit)
      if( useInstanceMethod( p, aClass, key, NO))
         return;
   
   _MulleObjCKVCInformationUseUnboundKeyMethod( p, aClass, NO);
}


/* 
 * What should be done is this. Figure out the class the accessor method /instance variable  
 * is defined. Figure out where valueForKey is defined. If valueForKey is nearer or at the
 * same level as the instance variable / accessor, then use valueForKey as it probably has
 * some custom logic. Otherwise use the variable / accessor
 *
 * Possibility #2 check for NSObject and EOGenericObject implementations as they are "known"
 *
 * Possibility #3 ask the class to fill in KVC value information <<<< this is best!!
 * (see NSObject+NSKVCInformation)
 */
void   __MulleObjCDivineValueForKeyKVCInformation( struct _MulleObjCKVCInformation *p, Class aClass, NSString *key, unsigned int mask)
{
   NSString   *getMethodName;
   NSString   *underscoreGetMethodName;
   NSString   *underscoreName;
   
   _MulleObjCKVCInformationSetDefaultValues( p, key);
   
   //   if( _MulleObjCKVCIsUsingDefaultMethodOfType( aClass, _MulleObjCKVCValueForKeyIndex))
   getMethodName = stringByCombiningPrefixAndCapitalizedKey( @"get", key, NO);

   if( mask & _MulleObjCKVCGetMethodBit)
      if( useInstanceMethod( p, aClass, getMethodName, NO))
         return;
   
   if( mask & _MulleObjCKVCMethodBit)
      if( useInstanceMethod( p, aClass, key, NO))
         return;
   
   // check for _getKey
   underscoreGetMethodName = [@"_" stringByAppendingString:getMethodName];
   if( mask & _MulleObjCKVCUnderscoreGetMethodBit)
      if( useInstanceMethod( p, aClass, underscoreGetMethodName, NO))
         return;
   
   if( mask & _MulleObjCKVCUnderscoreMethodBit)
   {
      underscoreName = [@"_" stringByAppendingString:key];
      if( useInstanceMethod( p, aClass, underscoreName, NO))
         return;
   }
   
   if( [aClass accessInstanceVariablesDirectly])
   {
      underscoreName = [@"_" stringByAppendingString:p->key];
      if( mask & _MulleObjCKVCUnderscoreIvarBit)
         if( useInstanceVariable( p, aClass, underscoreName))
            return;

      if( mask & _MulleObjCKVCIvarBit)
         if( useInstanceVariable( p, aClass, key))
            return;
   }

   _MulleObjCKVCInformationUseUnboundKeyMethod( p, aClass, NO);
}



static inline SEL   _MulleObjCKVCSelectorForMethodType( _MulleObjCKVCMethodType  type)
{
   switch( type)
   {
   case _MulleObjCKVCValueForKeyIndex           : return( @selector( valueForKey:));
   case _MulleObjCKVCStoredValueForKeyIndex     : return( @selector( storedValueForKey:));
   case _MulleObjCKVCTakeValueForKeyIndex       : return( @selector( takeValue:forKey:));
   case _MulleObjCKVCTakeStoredValueForKeyIndex : return( @selector( takeStoredValue:forKey:));
   }
   return( (SEL) 0);
}


static inline _MulleObjCKVCMethodType   _MulleObjCKVCMethodTypeForSelector( SEL sel)
{
   if( sel == @selector( takeStoredValue:forKey:))
       return( _MulleObjCKVCTakeStoredValueForKeyIndex);
   if( sel == @selector( takeValue:forKey:))
      return( _MulleObjCKVCTakeValueForKeyIndex);
   if( sel == @selector( valueForKey:))
      return( _MulleObjCKVCValueForKeyIndex);
   if( sel == @selector( storedValueForKey:))
      return( _MulleObjCKVCStoredValueForKeyIndex);
   
   return( -1);
}


BOOL  _MulleObjCKVCIsUsingSameMethodOfTypeAsClass( Class aClass, _MulleObjCKVCMethodType type, Class referenceClass)
{
   struct _mulle_objc_method  *methodClass;
   struct _mulle_objc_method  *methodNSObject;
   mulle_objc_methodid_t      sel;
   
   sel            = (mulle_objc_methodid_t) _MulleObjCKVCSelectorForMethodType( type);
   methodClass    = mulle_objc_class_search_method( aClass, sel);  // EOFault returns nil f.e.
   methodNSObject = mulle_objc_class_search_method( referenceClass, sel);
   
   NSCParameterAssert( methodNSObject);
   
   if( methodClass && _mulle_objc_method_get_implementation( methodClass) ==
                     _mulle_objc_method_get_implementation( methodNSObject))
      return( YES);

   return( NO);
}


BOOL  _MulleObjCKVCIsUsingDefaultMethodOfType( Class aClass, _MulleObjCKVCMethodType type)
{
   return( _MulleObjCKVCIsUsingSameMethodOfTypeAsClass( aClass, type, [NSObject class]));
}


void  __MulleObjCSetObjectValueWithAccessorForType( id obj, SEL sel, id value, IMP imp, char valueType)
{
   void   *parameter;
   union
   {
      float                f;
      double               d;
      long                 l;
      long long            q;
      long double          D;
      unsigned long long   Q;
   } param;
   
   // so far we just do numbers
   NSCParameterAssert( ! value || [value isKindOfClass:[NSNumber class]]);
   
   // optimize nil path for speed and profit
   if( ! value)
   {
      switch( valueType)
      {
      case _C_CHR  : 
      case _C_UCHR : 
      case _C_SHT  : 
      case _C_USHT : 
         
      case _C_INT  :
      case _C_UINT : (*imp)( obj, sel, 0); return;
            
      case _C_LNG      :
      case _C_ULNG     :
      case _C_LNG_LNG  :
      case _C_ULNG_LNG :
            if( mulle_objc_signature_get_metaabiparamtype( &valueType) == 2)
            {
               param.q = 0;
               (*imp)( obj, sel, &param);
            }
            else
               (*imp)( obj, sel, 0);
            return;
            
      case _C_FLT     : param.f = 0.0; (*imp)( obj, sel, &param); return;
      case _C_DBL     : param.d = 0.0; (*imp)( obj, sel, &param); return;
      case _C_LNG_DBL : param.D = 0.0; (*imp)( obj, sel, &param); return;
      default         :
         [NSException raise:NSInvalidArgumentException
                     format:@"%s failed to handle \"%c\" for -[%@ %@ %@]. I don't know what to do with it",
             __PRETTY_FUNCTION__, valueType, obj, NSStringFromSelector( sel), value];

      }
      return;
   }

   switch( valueType)
   {
   case _C_CHR  : parameter = (void *) [value charValue]; break;
   case _C_UCHR : parameter = (void *) [value unsignedCharValue]; break;
   case _C_SHT  : parameter = (void *) [value shortValue]; break;
   case _C_USHT : parameter = (void *) [value unsignedShortValue]; break;
      
   case _C_INT  : parameter = (void *) [value intValue]; break;
   case _C_UINT : parameter = (void *) [value unsignedIntValue]; break;
   case _C_LNG  :
      if( mulle_objc_signature_get_metaabiparamtype( &valueType) == 2)
      {
         param.q   = [value longValue];
         parameter = &param;
         break;
      }
      parameter = (void *) [value longValue];
      break;
      
   case _C_ULNG :
      if( mulle_objc_signature_get_metaabiparamtype( &valueType) == 2)
      {
         param.Q   = [value unsignedLongValue];
         parameter = &param;
         break;
      }
      parameter = (void *) [value unsignedLongValue];
      break;
      
   case _C_LNG_LNG  :
      if( mulle_objc_signature_get_metaabiparamtype( &valueType) == 2)
      {
         param.q   = [value longLongValue];
         parameter = &param;
         break;
      }
      parameter = (void *) [value longLongValue];
      break;

   case _C_ULNG_LNG  :
      if( mulle_objc_signature_get_metaabiparamtype( &valueType) == 2)
      {
         param.Q   = [value unsignedLongLongValue];
         parameter = &param;
         break;
      }
      parameter = (void *) [value unsignedLongLongValue];
      break;
         
   case _C_FLT  :
         param.f   = [value floatValue];
         parameter = &param;
         break;
         
   case _C_DBL  :
         param.d   = [value doubleValue];
         parameter = &param;
         break;
         
   case _C_LNG_DBL :
         param.D   = [value longDoubleValue];
         parameter = &param;
         break;
         
   default      :
         [NSException raise:NSInvalidArgumentException
                     format:@"%s failed to handle \"%c\" for -[%@ %@ %@]. I don't know what to do with it",
          __PRETTY_FUNCTION__, valueType, obj, NSStringFromSelector( sel), value];
   }

   (*imp)( obj, sel, &parameter);
   return;
}


id   __MulleObjCGetObjectValueWithAccessorForType( id obj, SEL sel, IMP imp, char valueType)
{
   union rval_t
   {
      float                f;
      double               d;
      long double          D;
      long                 l;
      unsigned long        L;
      long long            q;
      unsigned long long   Q;
   };
   

   // so far we just do numbers
   switch( valueType)
   {
   case _C_CHR  : return( [NSNumber numberWithChar:(* (char (*)()) imp)( obj, sel)]);
   case _C_UCHR : return( [NSNumber numberWithUnsignedChar:(* (unsigned char (*)()) imp)( obj, sel)]);
   case _C_SHT  : return( [NSNumber numberWithShort:(* (short (*)()) imp)( obj, sel)]);
   case _C_USHT : return( [NSNumber numberWithUnsignedShort:(* (unsigned short (*)()) imp)( obj, sel)]);

   case _C_INT  : return( [NSNumber numberWithInt:(* (int (*)()) imp)( obj, sel)]);
   case _C_UINT : return( [NSNumber numberWithUnsignedInt:(* (unsigned int (*)()) imp)( obj, sel)]);
         
   case _C_LNG  :
      if( mulle_objc_signature_get_metaabireturntype( &valueType) == 2)
         return( [NSNumber numberWithLong:(* (union rval_t *(*)()) imp)( obj, sel)->l]);
      [NSNumber numberWithLong:(* (long (*)()) *imp)( obj, sel)];
      break;
         
   case _C_ULNG  :
      if( mulle_objc_signature_get_metaabireturntype( &valueType) == 2)
         return( [NSNumber numberWithUnsignedLong:(* (union rval_t *(*)()) imp)( obj, sel)->L]);
      [NSNumber numberWithUnsignedLong:(* (unsigned long (*)()) imp)( obj, sel)];
      break;

   case _C_LNG_LNG  :
      if( mulle_objc_signature_get_metaabireturntype( &valueType) == 2)
         return( [NSNumber numberWithLongLong:(* (union rval_t *(*)()) imp)( obj, sel)->q]);
      [NSNumber numberWithLongLong:(* (long long (*)()) imp)( obj, sel)];
      break;
      
   case _C_ULNG_LNG  :
      if( mulle_objc_signature_get_metaabireturntype( &valueType) == 2)
         return( [NSNumber numberWithUnsignedLongLong:(* (union rval_t *(*)()) imp)( obj, sel)->Q]);
      [NSNumber numberWithUnsignedLongLong:(* (unsigned long long (*)()) imp)( obj, sel)];
      break;
      
   case _C_FLT     : return( [NSNumber numberWithFloat:(* (union rval_t *(*)()) imp)( obj, sel)->f]);
   case _C_DBL     : return( [NSNumber numberWithDouble:(* (union rval_t *(*)()) imp)( obj, sel)->d]);
   case _C_LNG_DBL : return( [NSNumber numberWithLongDouble:(* (union rval_t *(*)()) imp)( obj, sel)->D]);
   default         :
      [NSException raise:NSInvalidArgumentException
                  format:@"%s failed to handle \"%c\" for -[%@ %@]. I don't know what to do with it",
          __PRETTY_FUNCTION__, valueType, obj, NSStringFromSelector( sel)];
   }
   return( nil);
}


@implementation _MulleObjCCompleteKVCInformation

- (id) initWithClass:(Class) aClass  
              forKey:(NSString *) key
{
   [super init];
   
   [aClass _divineValueForKeyKVCInformation:&self->infos_[ _MulleObjCKVCValueForKeyIndex]
                                       key:key];
   [aClass _divineTakeValueForKeyKVCInformation:&self->infos_[ _MulleObjCKVCTakeValueForKeyIndex]
                                           key:key];
   [aClass _divineStoredValueForKeyKVCInformation:&self->infos_[ _MulleObjCKVCStoredValueForKeyIndex]
                                             key:key];
   [aClass _divineTakeStoredValueForKeyKVCInformation:&self->infos_[ _MulleObjCKVCTakeStoredValueForKeyIndex]
                                           key:key];
   
   return( self);
}


- (void) dealloc
{
   unsigned int   i;
   
   for( i = 0; i < _MulleObjCKVCNumberOfMethodIndexes; i++)
      _MulleObjCClearKVCInformation( &self->infos_[ i]);
   [super dealloc];
}

@end
