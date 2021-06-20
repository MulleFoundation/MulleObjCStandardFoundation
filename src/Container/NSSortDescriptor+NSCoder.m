//
//  NSSortDescriptor+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "NSSortDescriptor+NSCoder.h"

#import "MulleObjCStandardValueFoundation.h"


@implementation NSSortDescriptor( NSCoder)

#pragma mark - NSCoding


/**/
- (instancetype) initWithCoder:(id <NSCoding>) coder
{
   NSString   *s;

   self = [super init];
   if( ! self)
      return( self);

   _key = [[coder decodeObject] copy];
   s    = [coder decodeObject];
   _selector = NSSelectorFromString( s);
   [coder decodeValueOfObjCType:@encode( BOOL)
                             at:&_ascending];
   return( self);
}


- (void) encodeWithCoder:(id <NSCoding>) coder
{
   NSString   *s;

   s = NSStringFromSelector( _selector);
   [coder encodeObject:_key];
   [coder encodeObject:s];
   [coder encodeValueOfObjCType:@encode( BOOL)
                             at:&_ascending];
}

@end
