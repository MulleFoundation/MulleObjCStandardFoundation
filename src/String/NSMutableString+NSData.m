//
//  NSMutableString+NSData.m
//  MulleObjCFoundation
//
//  Created by Nat! on 15.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSMutableString.h"

// other files in this library
#import "NSString+NSData.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSMutableString (NSData)

- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
                      encoding:(NSStringEncoding) encoding;
{
   NSString  *s;
   
   s = nil;
   if( length)
   {
      s = [[NSString alloc] initWithBytes:bytes
                                   length:length
                                 encoding:encoding];
      if( ! s)
      {
         [self release];
         return( nil);
      }
   }
   
   self = [self initWithStrings:&s
                          count:s? 1 : 0];
   [s release];

   return( self);
}


// this method is a lie, it will copy
// use initWithCharactersNoCopy:
// also your bytes will be freed immediately, when freeWhenDone is YES
- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
                            encoding:(NSStringEncoding) encoding
                        freeWhenDone:(BOOL) flag;
{
   NSString  *s;
   
   s = [[NSString alloc] initWithBytesNoCopy:bytes
                                      length:length
                                    encoding:encoding
                                freeWhenDone:flag];
   if( ! s)
   {
      [self release];
      return( nil);
   }
   
   self = [self initWithStrings:&s
                          count:1];
   [s release];
   
   return( self);
}

@end
