//
//  NSHashTable+Array_String.h
//  MulleObjCFoundation
//
//  Created by Nat! on 21.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import <MulleObjC/MulleObjC.h>

#import "ns_hash_table.h"


@class NSArray;
@class NSString;

NSArray    *NSAllHashTableObjects( NSHashTable *table);
NSString   *NSStringFromHashTable( NSHashTable *table);
