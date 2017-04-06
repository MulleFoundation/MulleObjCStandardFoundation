//
//  NSObjCStringFunctions.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSStringObjCFunctions.h"

#import "NSString.h"
#import "NSString+Sprintf.h"


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
   return( [NSString stringWithUTF8String:s]);
}


NSString   *NSStringFromSelector( SEL sel)
{
   char   *s;
   
   s = MulleObjCSelectorGetName( sel);
   return( s ? [NSString stringWithUTF8String:s] : @"<invalid selector>");
}


NSString   *NSStringFromRange( NSRange range)
{
   return( [NSString stringWithFormat:@"%lu, %lu", range.location, range.length]);
}




