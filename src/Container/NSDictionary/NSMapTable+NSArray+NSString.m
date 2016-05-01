//
//  NSMapTable+Array_String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 21.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSMapTable+NSArray+NSString.h"

#include "NSArray.h"
#include "NSMutableArray.h"

#include "MulleObjCFoundationString.h"


NSArray   *NSAllMapTableKeys( NSMapTable *table)
{
   NSMutableArray    *array;
   NSMapEnumerator    rover;
   void              *key;

   array = nil;
   
   rover = NSEnumerateMapTable( table);
   while( NSNextMapEnumeratorPair( &rover, &key, NULL))
   {
      if( ! array)
         array = [NSMutableArray array];
      [array addObject:key];
   }
   NSEndMapTableEnumeration( &rover);

   return( array);
}


NSArray   *NSAllMapTableValues( NSMapTable *table)
{
   NSMutableArray    *array;
   NSMapEnumerator    rover;
   void              *value;

   array = nil;
   
   rover = NSEnumerateMapTable( table);
   while( NSNextMapEnumeratorPair( &rover, NULL, &value))
   {
      if( ! array)
         array = [NSMutableArray array];
      [array addObject:value];
   }
   NSEndMapTableEnumeration( &rover);

   return( array);
}


NSString   *NSStringFromMapTable( NSMapTable *table)
{
   NSMutableString     *s;
   NSString            *description;
   NSMapEnumerator    rover;
   void                *key;
   void                *value;
   NSString            *separator;
   
   if( NSCountMapTable( table) == 0)
      return( @"{}");
   
   s         = [NSMutableString stringWithString:@"{\n   "];
   separator = nil;
   
   rover = NSEnumerateMapTable( table);
   while( NSNextMapEnumeratorPair( &rover, &key, &value))
   {
      [s appendString:separator];

      description = (*table->_callback.keycallback.describe)( &table->_callback.keycallback,
                                                             key,
                                                             table->_allocator);
      [s appendString:description];
      [s appendString:@" = "];
      description = (*table->_callback.valuecallback.describe)( &table->_callback.valuecallback,
                                                                value,
                                                                table->_allocator);
      [s appendString:description];
      separator = @";\n   ";
   }
   NSEndMapTableEnumeration( &rover);

   [s appendString:@"\n}"];
   return( s);
}
