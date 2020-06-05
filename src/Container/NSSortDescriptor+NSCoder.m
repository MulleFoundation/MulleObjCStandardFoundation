//
//  NSSortDescriptor+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "NSSortDescriptor+NSCoder.h"

#import "NSCoder.h"

#import "MulleObjCStandardFoundationString.h"


@implementation NSSortDescriptor( NSCoder)

#pragma mark - NSCoding


/**/
- (instancetype) initWithCoder:(NSCoder *) coder
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
