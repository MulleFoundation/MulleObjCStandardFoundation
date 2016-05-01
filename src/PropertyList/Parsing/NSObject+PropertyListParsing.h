//
//  NSObject+PropertyListParsing.h
//  MulleEOUtil
//
//  Created by Nat! on 13.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MulleObjCFoundationCore.h"

@class _MulleObjCPropertyListReader;

id   _MulleObjCNewFromPropertyListWithStreamReader( _MulleObjCPropertyListReader *reader);
id   _MulleObjCNewObjectParsedUnquotedFromPropertyListWithReader( _MulleObjCPropertyListReader *reader);
