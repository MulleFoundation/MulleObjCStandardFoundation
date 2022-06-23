//
//  NSSortDescriptor.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2006 Nat! - Mulle kybernetiK.
//  Copyright (c) 2006 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "import.h"


@class NSArray;
@class NSString;


@interface NSSortDescriptor : NSObject <NSCopying, MulleObjCImmutable>
{
   SEL        _selector;
   NSString   *_key;
   BOOL        _ascending;
}

+ (NSSortDescriptor *) sortDescriptorWithKey:(NSString *) key
                                   ascending:(BOOL) flag;
+ (NSSortDescriptor *) sortDescriptorWithKey:(NSString *) key
                                   ascending:(BOOL) flag
                                    selector:(SEL) selector;

- initWithKey:(NSString *) key
    ascending:(BOOL) flag;
- initWithKey:(NSString *) key
    ascending:(BOOL) flag
     selector:(SEL) selector;

- (NSString *) key;
- (SEL) selector;
- (BOOL) ascending;

- (NSSortDescriptor *) reversedSortDescriptor;

@end


@interface NSSortDescriptor( Future)

- (NSComparisonResult) compareObject:(id) a
                            toObject:(id) b;

@end



MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL
NSComparisonResult   MulleObjCSortDescriptorArrayCompare( id a, id b, NSArray *descriptors);
