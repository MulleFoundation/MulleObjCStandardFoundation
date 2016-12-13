//
//  NSMapTable.h
//  MulleObjCFoundation
//
//  Created by Nat! on 14.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import <MulleObjC/MulleObjC.h>

#include "ns_map_table.h"


// this is just a wrapper for the C NSMapTable currently

@interface NSMapTable : NSObject
{
   struct _NSMapTable   table;
}
@end
