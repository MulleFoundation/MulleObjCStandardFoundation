//
//  MulleObjCBaseFunctions.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import <MulleObjC/MulleObjC.h>


@class NSString;

static inline Class   NSClassFromString( NSString *s)
{
   return( MulleObjCLookupClassByName( s));
}


static inline SEL   NSSelectorFromString( NSString *s)
{
   return( MulleObjCCreateSelector( s));
}


static inline NSString   *NSStringFromClass( Class cls)
{
   return( MulleObjCClassGetName( cls));
}


static inline NSString   *NSStringFromSelector( SEL sel)
{
   return( MulleObjCSelectorGetName( sel));
}


NSString   *NSStringFromRange( NSRange range);
