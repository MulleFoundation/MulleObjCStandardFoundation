/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  MulleObjCASCIIString.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSString.h"

#include <mulle_utf/mulle_utf.h>

//
// subclasses provide length
// ASCII is something that's provided "hidden". It's the best,
// because it can provide mulle_utf8_t and mulle_utf32_t w/o composition
// 
@interface _MulleObjCASCIIString : NSString
{
}
@end


@interface _MulleObjCASCIIString( _Subclasses)

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length;
+ (id) newWithUTF32Characters:(mulle_utf32_t *) chars
                       length:(NSUInteger) length;

@end


//
// just some shortcuts to avoid having to store the length, when our byte size
// length would blow up the string by another 4 bytes (because of malloc 
// alignment) (and we like to keep/have the trailing zero)
// 
//
@interface _MulleObjC03LengthASCIIString : _MulleObjCASCIIString
@end
@interface _MulleObjC07LengthASCIIString : _MulleObjCASCIIString
@end
@interface _MulleObjC11LengthASCIIString : _MulleObjCASCIIString
@end
@interface _MulleObjC15LengthASCIIString : _MulleObjCASCIIString
@end


@interface _MulleObjCTinyASCIIString : _MulleObjCASCIIString
{
   uint8_t   _length;         // 1 - 256
   char      _storage[ 3];
}

@end


@interface _MulleObjCGenericASCIIString : _MulleObjCASCIIString
{
   NSUInteger   _length;         // 257-max
   char         _storage[ 1];
}
@end


@interface _MulleObjCReferencingASCIIString : _MulleObjCASCIIString
{
   NSUInteger   _length;
   char         *_storage;
}

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length;

@end


@interface _MulleObjCAllocatorASCIIString  : _MulleObjCReferencingASCIIString
{
   struct mulle_allocator   *_allocator;
}

+ (id) newWithASCIICharactersNoCopy:(char *) chars
                             length:(NSUInteger) length
                          allocator:(struct mulle_allocator *) allocator;

@end


@interface _MulleObjCSharedASCIIString : _MulleObjCReferencingASCIIString
{
   id   _sharingObject;
}

+ (id) newWithASCIICharactersNoCopy:(char *) chars
                             length:(NSUInteger) length
                      sharingObject:(id) sharingObject;

@end
