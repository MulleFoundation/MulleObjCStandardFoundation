//
//  MulleObjCFoundation.h
//  MulleObjCFoundation
//
//  Created by Nat! on 14.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundation.h"

// the forwarding method in this particular runtime
void   *_objc_msgForward( void *self, mulle_objc_methodid_t _cmd, void *_param);

void  NSLog( NSString *format, ...);
