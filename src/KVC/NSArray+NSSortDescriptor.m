/*
 *  MulleEOFoundation - Base Functionality of MulleEOF (Project Titmouse) 
 *                      Part of the Mulle EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, Mulle kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSArray+NSSortDescriptor.m,v 045c5bd5eb4b 2011/03/22 14:47:42 nat $
 *
 *  $Log$
 */
#import "NSArray+NSSortDescriptor.h"

// other files in this library
#import "NSSortDescriptor.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSArray ( NSSortDescriptor)

- (NSArray *) sortedArrayUsingDescriptors:(NSArray *) orderings
{
   return( [self sortedArrayUsingFunction:(void *) MulleObjCSortDescriptorArrayCompare
                                  context:orderings]);
}

@end


@implementation NSMutableArray ( NSSortDescriptor)

- (void) sortUsingDescriptors:(NSArray *) orderings
{
   [self sortUsingFunction:(void *) MulleObjCSortDescriptorArrayCompare
                   context:orderings];
}

@end

