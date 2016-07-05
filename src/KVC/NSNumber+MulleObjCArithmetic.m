//
//  NSNumber+MulleObjCArithmetic.m
//  MulleObjCFoundation
//
//  Created by Nat! on 17.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSNumber+MulleObjCArithmetic.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and other dependencies


@implementation NSNumber (MulleObjCArithmetic)


static int  simplify_type_for_arithmetic( int type)
{
   switch( type)
   {
   case _C_CHR :
   case _C_SHT :
   case _C_INT :
   case _C_UCHR :
   case _C_USHT :
   case _C_UINT :
   case _C_LNG :
   case _C_ULNG :
   case _C_LNG_LNG :
   case _C_ULNG_LNG :
      return( _C_LNG_LNG);
      
   case _C_FLT     :
      return( _C_DBL);
   }
   return( type);
}


- (NSNumber *) _add:(NSNumber *) other
{
   char          *p_type;
   char          *p_other_type;
   long long     a64, b64;
   double        da, db;
   long double   lda, ldb;
   int           type;
   int           other_type;
   
   p_type       = [self objCType];
   p_other_type = other ? [other objCType] : @encode( int);
   
   NSCParameterAssert( p_type && strlen( p_type) == 1);
   NSCParameterAssert( p_other_type && strlen( p_other_type) == 1);
   
   type       = simplify_type_for_arithmetic( *p_type);
   other_type = simplify_type_for_arithmetic( *p_other_type);
   
   switch( type)
   {
   default  : goto bail;
   case _C_LNG_LNG :
      switch( other_type)
      {
      default           : goto bail;
      case _C_LNG_LNG   : goto do_64_64_add;
      case _C_DBL       : goto do_d_d_add;
      case _C_LNG_DBL   : goto do_ld_ld_add;
      }
         
   case _C_DBL          : goto do_d_d_add;
   case _C_LNG_DBL      : goto do_ld_ld_add;
   }

   // integer overflows to 64
do_64_64_add :
   a64 = [self longLongValue];
   b64 = [other longLongValue];
   return( [NSNumber numberWithLongLong:a64 + b64]);
   
do_d_d_add :
   da = [self doubleValue];
   db = [other doubleValue];
   return( [NSNumber numberWithDouble:da + db]);
   
do_ld_ld_add :
   lda = [self longDoubleValue];
   ldb = [other longDoubleValue];
   return( [NSNumber numberWithLongDouble:lda + ldb]);
   
bail:
   MulleObjCThrowInternalInconsistencyException( @"unknown objc-type");
   return( 0);
}


- (NSNumber *) _divideByInteger:(NSUInteger) divisor
{
   char          *p_type;
   long long     a64;
   double        da;
   long double   lda;
   int           type;
   
   p_type = [self objCType];
   
   NSCParameterAssert( p_type && strlen( p_type) == 1);
   
   type = simplify_type_for_arithmetic( *p_type);
   
   switch( type)
   {
   default          : goto bail;
   case _C_LNG_LNG  : goto do_64_64_div;
   case _C_DBL      : goto do_d_d_div;
   case _C_LNG_DBL  : goto do_ld_ld_div;
   }
   
   // integer overflows to 64
do_64_64_div :
   a64 = [self longLongValue];
   return( [NSNumber numberWithLongLong:a64 / divisor]);
   
do_d_d_div :
   da = [self doubleValue];
   return( [NSNumber numberWithDouble:da / divisor]);
   
do_ld_ld_div :
   lda = [self longDoubleValue];
   return( [NSNumber numberWithLongDouble:lda / divisor]);
   
bail:
   MulleObjCThrowInternalInconsistencyException( @"unknown objc-type");
   return( 0);
}


@end
