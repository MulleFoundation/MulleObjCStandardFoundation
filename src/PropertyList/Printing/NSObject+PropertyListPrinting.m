/*
 *  NSObject+PropertyListPrinting.h
 *  MulleEOUtil
 *  $Id$ 
 *  Created by Nat! on 10.08.09.
 *  Copyright 2009 Mulle kybernetiK. All rights reserved.
 *
 *  $Log$
 *
 */
#import "NSObject+PropertyListPrinting.h"

// other files in this library
#import "_MulleObjCDataStream.h"

// std-c and dependencies


@implementation NSObject( PropertyListPrinting)

int    _MulleObjCPropertyListUTF8DataIndentationPerLevel  = 1;
char   _MulleObjCPropertyListUTF8DataIndentationCharacter = '\t';
NSDictionary  *_MulleObjCPropertyListCanonicalPrintingLocale;


- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
{
   [self propertyListUTF8DataToStream:handle
                                  indent:0];
}


- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                               indent:(unsigned int) indent;
{
   NSData   *data;
   
   data = [self propertyListUTF8DataWithIndent:indent];
   [handle writeData:data];
}


- (NSData *) propertyListUTF8DataWithIndent:(unsigned int) indent
{
   return( [[self description] dataUsingEncoding:NSUTF8StringEncoding]);
}


- (NSData *) propertyListUTF8DataIndentation:(unsigned int) level
{
   NSMutableData   *data;
   unsigned int    n;
   
   n = level * _MulleObjCPropertyListUTF8DataIndentationPerLevel;
   data = [NSMutableData dataWithLength:n];
   memset( [data mutableBytes], 
            _MulleObjCPropertyListUTF8DataIndentationCharacter, 
            n);
   return( data);
}

@end
