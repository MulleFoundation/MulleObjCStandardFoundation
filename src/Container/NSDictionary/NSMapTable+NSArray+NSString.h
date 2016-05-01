//
//  NSMapTable+Array_String.h
//  MulleObjCFoundation
//
//  Created by Nat! on 21.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import <MulleObjC/MulleObjC.h>

#include "ns_map_table.h"


@class NSArray;
@class NSString;


NSArray   *NSAllMapTableKeys( NSMapTable *table);
NSArray   *NSAllMapTableValues( NSMapTable *table);

NSString   *NSStringFromMapTable( NSMapTable *table);
