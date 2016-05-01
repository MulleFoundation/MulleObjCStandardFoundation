/*
 *  NSDictionary+PropertyListPrinting.h
 *  MulleObjCEOUtil
 *  $Id$ 
 *  Created by Nat! on 10.08.09.
 *  Copyright 2009 MulleObjC kybernetiK. All rights reserved.
 *
 *  $Log$
 *
 */
#import "NSDictionary+PropertyListPrinting.h"

// other files in this library
#import "NSObject+PropertyListPrinting.h"

// std-c and dependencies


@implementation NSDictionary( PropertyListPrinting)

typedef struct
{
    NSString   *keyDescription;
    NSString   *valueDescription;
} __KeyValueDescription;


- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                                  indent:(unsigned int) indent
{
   id              key, value;
   NSEnumerator    *enumerator;
   NSData          *keyData;
   NSData          *valueData;
   NSData          *indentation1;
   static NSData   *assignment;
   static NSData   *terminator;
   static NSData   *closer;
   unsigned        indent1;
   
   indent1 = indent + 1;
   
   if( ! [self count])
   {
      [handle writeData:[@"{}" dataUsingEncoding:NSUTF8StringEncoding]];
      return;
   }
   
   [handle writeData:[@"{\n" dataUsingEncoding:NSUTF8StringEncoding]];
   
   indentation1 = [self propertyListUTF8DataIndentation:indent1];
   
   if( ! assignment)
   {
      assignment = [[@" = " dataUsingEncoding:NSUTF8StringEncoding] retain];
      terminator = [[@";\n" dataUsingEncoding:NSUTF8StringEncoding] retain];
      closer     = [[@"}" dataUsingEncoding:NSUTF8StringEncoding] retain];
   }
   
   // don't really care if sorted or not but WTF.. :)
   enumerator = [[[self allKeys] sortedArrayUsingSelector:@selector( compare:)] objectEnumerator];
   
   while( key = [enumerator nextObject]) 
   {
      value = [self objectForKey:key];
      
      keyData   = [key propertyListUTF8DataWithIndent:indent1];
      valueData = [value propertyListUTF8DataWithIndent:indent1];
      
      [handle writeData:indentation1];
      [handle writeData:keyData];
      [handle writeData:assignment];
      [handle writeData:valueData];
      [handle writeData:terminator];
   }
   
   [handle writeData:[self propertyListUTF8DataIndentation:indent]]; 
   [handle writeData:closer];
}

@end
