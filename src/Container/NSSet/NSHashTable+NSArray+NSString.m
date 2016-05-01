//
//  NSHashTable+Array_String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 21.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "NSHashTable+NSArray+NSString.h"

// other files in this library
#import "NSArray.h"
#import "NSMutableArray.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies


NSArray   *NSAllHashTableObjects( NSHashTable *table)
{
   NSMutableArray      *array;
   NSHashEnumerator    rover;
   void                *item;
   
   array = nil;
   
   rover = NSEnumerateHashTable( table);
   while( item = NSNextHashEnumeratorItem( &rover))
   {
      if( ! array)
         array = [NSMutableArray array];
      [array addObject:item];
   }
   NSEndHashTableEnumeration( &rover);

   return( array);
   
}

NSString   *NSStringFromHashTable( NSHashTable *table)
{
   NSMutableString     *s;
   NSString            *description;
   NSHashEnumerator    rover;
   void                *item;
   NSString            *separator;
   
   s         = [NSMutableString stringWithString:@"<[\n"];
   separator = nil;
 
   rover = NSEnumerateHashTable( table);
   while( item = NSNextHashEnumeratorItem( &rover))
   {
      description = (*table->_callback.describe)( &table->_callback,
                                                  item,
                                                  mulle_set_get_allocator( &table->_set));
      [s appendString:separator];
      [s appendString:description];
      separator = @",\n   ";
   }
   NSEndHashTableEnumeration( &rover);

   [s appendString:@"\n]>"];
   return( s);
}
