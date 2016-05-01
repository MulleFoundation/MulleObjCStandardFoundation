//
//  NSKeyedUnarchiver.h
//  MulleObjCFoundation
//
//  Created by Nat! on 20.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCUnarchiver.h"


@interface NSKeyedUnarchiver : MulleObjCUnarchiver
{
   NSMapTable   *_scope;
}
@end
