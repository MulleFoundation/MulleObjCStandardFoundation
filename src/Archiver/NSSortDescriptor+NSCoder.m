//
//  NSSortDescriptor+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationContainer.h"

#import "NSCoder.h"
#import "MulleObjCFoundationString.h"


@interface NSSortDescriptor( NSCoder) < NSCoding>
@end


@implementation NSSortDescriptor( NSCoder)

#pragma mark -
#pragma mark NSCoding


/**/
- (id) initWithCoder:(NSCoder *) coder
{
   NSString   *s;

   self = [super init];
   if( ! self)
      return( self);

   [coder decodeValuesOfObjCTypes:"@@c", &_key, &s, &_ascending];
   _selector = NSSelectorFromString( s);

   return( self);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSString   *s;

   s = NSStringFromSelector( _selector);
   [coder encodeValuesOfObjCTypes:"@@c", &_key, &s, &_ascending];
}

@end
