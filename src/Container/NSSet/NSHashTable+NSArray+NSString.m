//
//  NSHashTable+NSArray+NSString.m
//  MulleObjCFoundation
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
