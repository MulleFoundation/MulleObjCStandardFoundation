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
#import "MulleObjCFoundationCore.h"

#import "_MulleObjCDataStream.h"




extern int    _MulleObjCPropertyListUTF8DataIndentationPerLevel;  //   = 1;
extern char   _MulleObjCPropertyListUTF8DataIndentationCharacter; //  = '\t';
extern NSDictionary  *_MulleObjCPropertyListCanonicalPrintingLocale;


@interface NSObject ( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle;

- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                               indent:(unsigned int) indent;

- (NSData *) propertyListUTF8DataWithIndent:(unsigned int) indent;

- (NSData *) propertyListUTF8DataIndentation:(unsigned int) level;

@end
