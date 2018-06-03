//
//  NSObjCStringFunctions.h
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationBase.h"

@class NSString;

Class       NSClassFromString( NSString *s);
SEL         NSSelectorFromString( NSString *s);
NSString   *NSStringFromClass( Class cls);
NSString   *NSStringFromSelector( SEL sel);
NSString   *NSStringFromRange( NSRange range);
