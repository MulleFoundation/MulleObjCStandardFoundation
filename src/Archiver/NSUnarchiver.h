//
//  NSUnarchiver.h
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 18.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCUnarchiver.h"


@interface NSUnarchiver : MulleObjCUnarchiver < MulleObjCUnkeyedUnarchiver>

- (void) decodeValueOfObjCType:(char *) type
                            at:(void *) p;

- (void *) decodeBytesWithReturnedLength:(NSUInteger *) len_p;

@end
