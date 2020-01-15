//
//  NSMapTable+NSArray+NSString.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#import "NSMapTable+NSArray+NSString.h"

// other files in this library

// std-c and dependencies
#import "import-private.h"


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
   char                     *cStringDescription;
   NSMapEnumerator          rover;
   NSMutableString          *s;
   NSString                 *separator;
   struct mulle_allocator   *allocator;
   void                     *key;
   void                     *value;

   if( NSCountMapTable( table) == 0)
      return( @"{}");

   s         = [NSMutableString stringWithString:@"{\n   "];
   separator = @"";

   rover = NSEnumerateMapTable( table);
   while( NSNextMapEnumeratorPair( &rover, &key, &value))
   {
      [s appendString:separator];

      allocator          = table->_allocator;
      cStringDescription = (*table->_callback.keycallback.describe)( &table->_callback.keycallback,
                                                                     key,
                                                                     &allocator);
      [s appendFormat:@"%s", cStringDescription];
      if( allocator)
         mulle_allocator_free( allocator, s);
      [s appendString:@" = "];

      allocator          = table->_allocator;
      cStringDescription = (*table->_callback.valuecallback.describe)( &table->_callback.valuecallback,
                                                                       value,
                                                                       &allocator);
      [s appendFormat:@"%s", cStringDescription];
      if( allocator)
         mulle_allocator_free( allocator, s);

      separator = @";\n   ";
   }
   NSEndMapTableEnumeration( &rover);

   [s appendString:@"\n}"];
   return( s);
}
