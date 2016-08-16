/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: _MulleObjCInstanceVariableAccess.m,v b9a3127cf1df 2010/08/11 16:35:38 nat $
 *
 *  $Log$
 */
#import "_MulleObjCInstanceVariableAccess.h"

// other files in this library
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"
#import "MulleObjCFoundationValue.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCBaseFunctions.h"

// std-c and dependencies


//
// no pretenses, this is totally limited and probably just good for our fetching stuff
// don't pass in mutable objects...
//
void   _MulleObjCSetInstanceVariableForType( id p, unsigned int offset, id value, char valueType)
{
   void   *dst;
   id     old;
   
   dst = &((char *) p)[ offset];
   
   //
   // optimize the 'nil' path, it should be worth it during fetches f.e.
   // because we don't need to call objc_msgSend
   //
   
   if( ! value)
      switch( valueType)
      {
#ifdef _C_BOOL
      case _C_BOOL : *(_Bool *)          dst = 0; return;
#endif 
      case _C_CHR  : *(char *)           dst = 0; return;
      case _C_UCHR : *(unsigned char *)  dst = 0; return;
      case _C_SHT  : *(short *)          dst = 0; return;
      case _C_USHT : *(unsigned short *) dst = 0; return;
         
      case _C_INT  : *(int *)           dst = 0; return;
      case _C_UINT : *(unsigned int *)  dst = 0; return;
      case _C_LNG  : *(long *)          dst = 0; return;
      case _C_ULNG : *(unsigned long *) dst = 0; return;
      case _C_SEL  : *(SEL *)           dst = 0; return;
      
      case _C_LNG_LNG  : *(long long *)          dst = 0; return;
      case _C_ULNG_LNG : *(unsigned long long *) dst = 0; return;
         
      case _C_FLT      : *(float *)  dst = 0; return;
      case _C_DBL      : *(double *) dst = 0; return;
      case _C_LNG_DBL  : *(double *) dst = 0; return;
      case _C_COPY_ID :
         old         = *(id *) dst;
         *(id *) dst = 0;
         if( old)
            [old autorelease];   // if you crash here, better make clean your project!
         return;
         
      case _C_ASSIGN_ID :
         *(id *) dst = 0;
         return;
         
      case _C_CLASS :
      case _C_ID    :
         old         = *(id *) dst;
         *(id *) dst = 0;
         if( old)
            [old autorelease];   // if you crash here, better make clean your project!
         return;
         
      default  :
         [NSException raise:NSInvalidArgumentException
                     format:@"%s failed to handle \"%c\". I just don't know what to do with it", __PRETTY_FUNCTION__, valueType];
      }
   
   switch( valueType)
   {
#ifdef _C_BOOL
   case _C_BOOL : *(_Bool *)          dst = [value boolValue]; return;
#endif 
   case _C_CHR  : *(char *)           dst = [value charValue]; return;
   case _C_UCHR : *(unsigned char *)  dst = [value unsignedCharValue]; return;
   case _C_SHT  : *(short *)          dst = [value shortValue]; return;
   case _C_USHT : *(unsigned short *) dst = [value unsignedShortValue]; return;
      
   case _C_INT  : *(int *)            dst = [value intValue]; return;
   case _C_UINT : *(unsigned int *)   dst = [value unsignedIntValue]; return;
   case _C_LNG  : *(long *)           dst = [value longValue]; return;
   case _C_ULNG : *(unsigned long *)  dst = [value unsignedLongValue]; return;
      
   case _C_LNG_LNG  : *(long long *)          dst = [value longLongValue]; return;
   case _C_ULNG_LNG : *(unsigned long long *) dst = [value unsignedLongLongValue]; return;
      
   case _C_FLT     :  *(float *)       dst = [value floatValue]; return;
   case _C_DBL     : *(double *)      dst = [value doubleValue]; return;
   case _C_LNG_DBL : *(long double *) dst = [value longDoubleValue]; return;
      
   case _C_SEL     : *(SEL *)         dst = (SEL) [value longValue]; return;

   case _C_COPY_ID :
      old         = *(id *) dst;
      *(id *) dst = [value copy];
      if( old)
         [old autorelease];   // if you crash here, better make clean your project!
      return;
      
   case _C_ASSIGN_ID :
      *(id *) dst = value;
      break;
      
   case _C_CLASS :
   case _C_ID    :
      old         = *(id *) dst;
      *(id *) dst = [value retain];
      if( old)
         [old autorelease];   // if you crash here, better make clean your project!
      return;
      
   default :
      [NSException raise:NSInvalidArgumentException
                  format:@"%s failed to handle \"%c\". I just don't know what to do with it", __PRETTY_FUNCTION__, valueType];
   }
}


id   _MulleObjCGetInstanceVariableForType( id p, unsigned int offset, char valueType)
{
   void   *dst;
   
   dst = &((char *) p)[ offset];
   
   switch( valueType)
   {
#ifdef _C_BOOL
   case _C_BOOL : return( [NSNumber numberWithBool:*(_Bool *) dst]);
#endif 
   case _C_CHR  : return( [NSNumber numberWithChar:*(char *) dst]);
   case _C_UCHR : return( [NSNumber numberWithUnsignedChar:*(unsigned char *) dst]);
   case _C_SHT  : return( [NSNumber numberWithShort:*(short *) dst]);
   case _C_USHT : return( [NSNumber numberWithUnsignedShort:*(unsigned short *) dst]);

   case _C_INT  : return( [NSNumber numberWithInt:*(int *) dst]);
   case _C_UINT : return( [NSNumber numberWithUnsignedInt:*(unsigned int *) dst]);
   case _C_LNG  : return( [NSNumber numberWithLong:*(long *) dst]);
   case _C_ULNG : return( [NSNumber numberWithUnsignedLong:*(unsigned long *) dst]);

   case _C_LNG_LNG  : return( [NSNumber numberWithLongLong:*(long long *) dst]);
   case _C_ULNG_LNG : return( [NSNumber numberWithUnsignedLongLong:*(unsigned long long *) dst]);
         
   case _C_FLT     : return( [NSNumber numberWithFloat:*(float *) dst]);
   case _C_DBL     : return( [NSNumber numberWithDouble:*(double *) dst]);
   case _C_LNG_DBL : return( [NSNumber numberWithLongDouble:*(long double *) dst]);

   case _C_SEL     : return( [NSNumber numberWithLong:(long) *(SEL *) dst]);

   case _C_COPY_ID :
   case _C_ASSIGN_ID :
   case _C_CLASS   :
   case _C_ID      :
      break;
      
   default :
      [NSException raise:NSInvalidArgumentException
                  format:@"%s failed to handle \"%c\". I just don't know what to do with it", __PRETTY_FUNCTION__, valueType];
   }
   return( *(id *) dst);
}
