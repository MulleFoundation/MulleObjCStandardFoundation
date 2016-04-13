//
//  NSString+ClassCluster.h
//  MulleObjCFoundation
//
//  Created by Nat! on 10.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"


@interface NSString( ClassCluster)  < MulleObjCClassCluster>

- (id) initWithCharacters:(unichar *) s
                   length:(NSUInteger) len;

- (id) initWithUTF8Characters:(mulle_utf8char_t *) s
                       length:(NSUInteger) len;

- (id) initWithUTF8String:(mulle_utf8char_t *) s;
- (id) initWithUTF8CharactersNoCopy:(mulle_utf8char_t *) s
                             length:(NSUInteger) lengt
                          allocator:(struct mulle_allocator *) allocator;
@end
