/*
 *  MulleCore - Optimized Foundation Replacements and Extensions Functionality 
 *              also a part of MulleEOFoundation of MulleEOF (Project Titmouse) 
 *              which is part of the Mulle EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, Mulle kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSString+MulleFastComponents.h,v bc35f12316af 2011/03/23 14:35:34 nat $
 *
 *  $Log$
 */
#import "MulleObjCFoundationString.h"


// useful for moderately sized strings < 4K i guess
// and short separator strings
// for really large strings use some smarter algorithm or one that can exploit
// long seperator strings. This is used for keyPath decoding
//
@class NSArray;


@interface NSString ( Components)

- (NSArray *) componentsSeparatedByString:(NSString *) s;

#pragma mark -
#pragma mark mulle additions

// will return nil, if no separator found
- (NSArray *) _componentsSeparatedByString:(NSString *) separator;


@end

// this returns nil, if no separator is found
NSArray  *MulleObjCComponentsSeparatedByString( NSString *self, NSString *separator);


