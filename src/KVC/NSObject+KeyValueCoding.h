/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSObject+KeyValueCoding.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import <MulleObjC/MulleObjC.h>


@class NSArray;
@class NSString;
@class NSDictionary;


extern NSString   *NSUndefinedKeyException;


@interface NSObject( _KeyValueCoding)

- (id) valueForKey:(NSString *) key;
- (void) takeValue:(id) value
            forKey:(NSString *)key;


+ (BOOL) useStoredAccessor;

- (id) storedValueForKey:(NSString *) key;

- (void) takeStoredValue:(id) value 
                  forKey:(NSString *) key;

- (id) valueForKeyPath:(NSString *)keyPath;
- (void) takeValue:(id) value
        forKeyPath:(NSString *)keyPath;

- (id) handleQueryWithUnboundKey:(NSString *) key;
- (id) valueForUndefinedKey:(NSString *) key;   
- (void) handleTakeValue:(id) value 
           forUnboundKey:(NSString *) key;

- (void) unableToSetNilForKey:(NSString *)key ;
- (NSDictionary *) valuesForKeys:(NSArray *) keys;
- (void) takeValuesFromDictionary:(NSDictionary *) properties;

@end


@interface NSObject( _KeyValueCodingCompatibility)

// "modern" KVC interface
- (void) setValue:(id)value 
           forKey:(NSString *) key;

- (void) setValue:(id)value 
       forKeyPath:(NSString *) key;

- (void) setValue:(id) value 
   forUndefinedKey:(NSString *) key;

- (void) setNilValueForKey:(NSString *)key;

- (NSDictionary *) dictionaryWithValuesForKeys:(NSArray *) keys;
           
@end


void    MulleObjCThrowUndefinedKeyException( id self, NSString *key);
