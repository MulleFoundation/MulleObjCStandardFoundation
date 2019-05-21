//
//  NSObjCStringFunctions.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSStringObjCFunctions.h"

#import "NSString.h"
#import "NSString+Sprintf.h"

#import "NSException.h"


@class NSString;

Class   NSClassFromString( NSString *s)
{
   return( MulleObjCLookupClassByName( [s UTF8String]));
}


SEL   NSSelectorFromString( NSString *s)
{
   return( MulleObjCCreateSelector( [s UTF8String]));
}


NSString   *NSStringFromClass( Class cls)
{
   char   *s;

   s = MulleObjCClassGetName( cls);
   if( ! s)
   {
      if( ! cls)
         return( nil);
      MulleObjCThrowInternalInconsistencyException( @"unknown class %p", cls);
   }

   return( [NSString stringWithUTF8String:s]);
}


NSString   *NSStringFromSelector( SEL sel)
{
   char   *s;

   s = MulleObjCSelectorGetName( sel);
   if( ! s)
   {
      if( ! sel)
         return( nil);
      MulleObjCThrowInternalInconsistencyException( @"unknown selector id %08x (register selector first)", (uint32_t ) sel);
   }
   return([NSString stringWithUTF8String:s]);
}


NSString   *NSStringFromProtocol( PROTOCOL proto)
{
   char   *s;

   s = MulleObjCProtocolGetName( proto);
   if( ! s)
   {
      if( ! proto)
         return( nil);
      MulleObjCThrowInternalInconsistencyException( @"unknown protocol id %08x", (uint32_t ) proto);
   }
   return([NSString stringWithUTF8String:s]);
}


NSString   *NSStringFromRange( NSRange range)
{
   return( [NSString stringWithFormat:@"%lu, %lu", range.location, range.length]);
}




