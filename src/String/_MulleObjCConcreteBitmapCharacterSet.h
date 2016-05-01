//
//  _MulleObjCConcreteBitmapCharacterSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 15.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSCharacterSet.h"


@interface _MulleObjCConcreteBitmapCharacterSet : NSCharacterSet
{
   uint32_t                 *_planes[ 0x11];
   int                      _rval;
   
   struct mulle_allocator   *_allocator;
   id                       _owner;
}


+ (id) newWithBitmapPlanes:(uint32_t **) planes
                    invert:(BOOL) invert
                 allocator:(struct mulle_allocator *)  allocator
                     owner:(id) owner;

@end
