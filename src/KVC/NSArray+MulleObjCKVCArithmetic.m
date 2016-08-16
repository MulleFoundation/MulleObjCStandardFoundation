//
//  NSArray+MulleObjCKVCArithmetic.m
//  MulleObjCFoundation
//
//  Created by Nat! on 04.08.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "MulleObjCFoundationContainer.h"

#import "NSNumber+MulleObjCKVCArithmetic.h"


@implementation NSArray (MulleObjCKVCArithmetic)

- (NSNumber *) _numberValue
{
   NSNumber   *nr;
   id         element;
   
   nr = [NSNumber numberWithInt:0];
   for( element in self)
      nr = [element _add:nr];
   return( nr);
}


- (NSNumber *) _add:(NSNumber *) nr
{
   nr = [nr _add:[self _numberValue]];;
   return( nr);
}


- (NSNumber *) _divideByInteger:(NSUInteger) divisor
{
   NSNumber   *nr;
   
   nr = [NSNumber numberWithInt:0];
   nr = [self _add:nr];
   return( [nr _divideByInteger:divisor]);
}

@end
