//
//  NSNumber+NSString.m
//  MulleObjCFoundation
//
//  Created by Nat! on 14.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSNumber+NSString.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c dependencies


@implementation NSNumber (NSString)

//
// default implementation, actually it's kinda good enough
// but there are also overrides in _MulleObjCConcreteNumber+NSString.m
//
- (id) description
{
   char   *type;
   
   type = [self objCType];
   switch( *type)
   {
   default :
      return( [NSString stringWithFormat:@"%ld", [self longValue]]);

   case _C_UCHR :
   case _C_USHT :
   case _C_UINT :
   case _C_ULNG :
      return( [NSString stringWithFormat:@"%lu", [self unsignedLongValue]]);
      
   case _C_LNG_LNG :
      return( [NSString stringWithFormat:@"%lld", [self longLongValue]]);
   case _C_ULNG_LNG :
      return( [NSString stringWithFormat:@"%llu", [self unsignedLongLongValue]]);

   case _C_FLT :
   case _C_DBL :
      return( [NSString stringWithFormat:@"%f", [self doubleValue]]);

   case _C_LNG_DBL :
      return( [NSString stringWithFormat:@"%Lf", [self longDoubleValue]]);
      
   }
}


- (NSString *) _debugContentsDescription
{
   return( [self description]);
}

@end
