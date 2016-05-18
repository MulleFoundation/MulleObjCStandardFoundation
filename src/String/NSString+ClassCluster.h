//
//  NSString+ClassCluster.h
//  MulleObjCFoundation
//
//  Created by Nat! on 10.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"


@interface NSString( ClassCluster)

- (instancetype) initWithCharacters:(unichar *) s
                             length:(NSUInteger) len;
- (instancetype) initWithCharactersNoCopy:(unichar *) chars
                                   length:(NSUInteger) length
                             freeWhenDone:(BOOL) flag;

- (instancetype) initWithUTF8String:(mulle_utf8_t *) s;


# pragma mark -
# pragma mark mulle additions

- (instancetype) _initWithUTF8Characters:(mulle_utf8_t *) s
                                  length:(NSUInteger) len;

- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                        length:(NSUInteger) length
                                  freeWhenDone:(BOOL) flag;

- (instancetype) _initWithCharactersNoCopy:(unichar *) s
                                    length:(NSUInteger) length
                                 allocator:(struct mulle_allocator *) allocator;

- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                        length:(NSUInteger) lengt
                                     allocator:(struct mulle_allocator *) allocator;

- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                        length:(NSUInteger) length
                                 sharingObject:(id) object;

- (instancetype) _initWithCharactersNoCopy:(unichar *) s
                                    length:(NSUInteger) length
                             sharingObject:(id) object;

@end
