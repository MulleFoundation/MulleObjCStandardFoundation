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
   return( MulleObjCClassFromString( s));
}


static inline SEL   NSSelectorFromString( NSString *s)
{
   return( MulleObjCSelectorFromString( s));
}


static inline NSString   *NSStringFromClass( Class cls)
{
   return( MulleObjCStringFromClass( cls));
}


static inline NSString   *NSStringFromSelector( SEL sel)
{
   return( MulleObjCStringFromSelector( sel));
}
