//
//  _MulleObjCCheatingUTF8String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 17.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCCheatingASCIIString.h"


@implementation _MulleObjCCheatingASCIIString


+ (id) alloc               { abort(); }
- (void) dealloc           { abort(); }
- (id) autorelease         { abort(); }
- (id) retain              { abort(); }
- (void) release           { abort(); }

//
// the only way to keep a cheating string
//
NSString  *MulleObjCNewASCIIStringWithASCIICharacters( char *s, NSUInteger length);

- (id) copy
{
   return( MulleObjCNewASCIIStringWithASCIICharacters( _storage, _length));
}

@end
