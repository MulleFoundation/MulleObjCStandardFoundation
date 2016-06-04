/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  MulleObjCDataStream.h is a part of MulleFoundation
 *
 *  Copyright (C) 2009 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
 
#import "MulleObjCFoundationCore.h"


//
// A _MulleObjCInputDataStream is basically an NSData
// and a _MulleObjCOutputDataStream is basically (and maybe actually) an 
// NSMutableData
//
@protocol _MulleObjCInputDataStream < NSObject>

- (NSData *) readDataOfLength:(NSUInteger) length;

@end


@protocol _MulleObjCOutputDataStream  < NSObject>

- (void) writeData:(NSData *) data;
- (void) writeBytes:(void *) bytes
             length:(NSUInteger) length;

@end


#pragma mark -
#pragma mark Concrete helper


@interface _MulleObjCMemoryDataInputStream : NSObject < _MulleObjCInputDataStream >
{
   NSData          *_data;
   unsigned char   *_current;
   unsigned char   *_sentinel;
}

- (id) initWithData:(NSData *) data;
- (NSData *) readDataOfLength:(NSUInteger) length;

@end


@interface NSMutableData( _MulleObjCOutputDataStream) < _MulleObjCOutputDataStream >

- (void) writeData:(NSData *) data;
- (void) writeBytes:(void *) bytes
             length:(NSUInteger) length;
@end


#define _MulleObjCMemoryOutputDataStream    NSMutableData

// make it known, that NSFileHandle nicely supports streams as is
//@interface NSFileHandle( _MulleObjCOutputDataStream) < _MulleObjCInputDataStream, _MulleObjCOutputDataStream >
//@end


