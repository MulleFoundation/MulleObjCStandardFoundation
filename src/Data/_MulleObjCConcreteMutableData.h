//
//  MulleObjCConcreteMutableData.h
//  MulleObjCFoundation
//
//  Created by Nat! on 01.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSMutableData.h"
#import <mulle_container/mulle_container.h>



@interface _MulleObjCConcreteMutableData : NSMutableData
{
   struct mulle_buffer   _storage;
}

+ (instancetype) newWithLength:(NSUInteger) length;
+ (instancetype) newWithCapacity:(NSUInteger) capacity;
+ (instancetype) newWithBytes:(void *) buf
                       length:(NSUInteger) length;

+ (id) newWithBytesNoCopy:(void *) bytes
                   length:(NSUInteger) length
                allocator:(struct mulle_allocator *) allocator;
@end
