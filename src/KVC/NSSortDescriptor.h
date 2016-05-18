/*
 *  MulleEOFoundation - Base Functionality of MulleEOF (Project Titmouse) 
 *                      Part of the Mulle EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, Mulle kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSSortDescriptor.h,v e5b08b0445dc 2010/01/05 12:27:23 nat $
 *
 *  $Log$
 */
#import <MulleObjC/MulleObjC.h>


@class NSArray;
@class NSString;


@interface NSSortDescriptor : NSObject <NSCoding, NSCopying>
{
   SEL        _selector;
   NSString   *_key;
   BOOL       _ascending;
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

- (NSComparisonResult) compareObject:(id) a
                            toObject:(id) b;

- (NSSortDescriptor *) reversedSortDescriptor;

@end


NSComparisonResult   MulleObjCSortDescriptorArrayCompare( id a, id b, NSArray *descriptors);


