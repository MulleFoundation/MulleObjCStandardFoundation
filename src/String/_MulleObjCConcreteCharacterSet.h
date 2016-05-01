//
//  _MulleObjCConcreteCharacterSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 15.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSCharacterSet.h"


@interface _MulleObjCConcreteCharacterSet : NSCharacterSet
{
   int   (*_f)( unichar c);
   int   (*_plane_f)( unsigned int c);
   int   _rval;
}

+ (id) newWithMemberFunction:(int (*)( unichar)) f
               planeFunction:(int (*)( unsigned int)) plane_f
                      invert:(BOOL) invert;

@end


