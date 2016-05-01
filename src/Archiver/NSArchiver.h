//
//  NSArchiver.h
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 17.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCArchiver.h"

//
// this subclass implements the necessary methods for an MulleObjCUnkeyedArchiver
// nothing more. The protocol "overrides" MulleObjCArchiver in this case
//
@interface NSArchiver : MulleObjCArchiver < MulleObjCUnkeyedArchiver>
@end
