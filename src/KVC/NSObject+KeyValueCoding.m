/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSObject+KeyValueCoding.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSObject+KeyValueCoding.h"

// other files in this library
#import "_MulleObjCKVCInformation.h"
#import "NSObject+_MulleObjCKVCInformation.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"
#import "_MulleObjCCheatingASCIIString.h"

// std-c and other dependencies


NSString   *NSUndefinedKeyException = @"NSUndefinedKeyException";



@interface NSString( Private)

- (NSUInteger) _UTF8StringLength;

@end



@implementation NSObject( _KeyValueCoding)

+ (BOOL) useStoredAccessor
{
   return( YES);
}


- (id) valueForKey:(NSString *) key
{
   struct _MulleObjCKVCInformation   kvc;
   id                                value;
   
   [[self class] _divineValueForKeyKVCInformation:&kvc
                                              key:key];
   value = _MulleObjCGetObjectValueWithKVCInformation( self, &kvc);
   _MulleObjCClearKVCInformation( &kvc);
   return( value);
}


- (id) storedValueForKey:(NSString *) key
{
   struct _MulleObjCKVCInformation   kvc;
   id                                value;
   
   [[self class] _divineStoredValueForKeyKVCInformation:&kvc
                                                    key:key];
   value = _MulleObjCGetObjectValueWithKVCInformation( self, &kvc);
   _MulleObjCClearKVCInformation( &kvc);
   return( value);
}


- (void) takeValue:(id) value 
            forKey:(NSString *) key
{
   struct _MulleObjCKVCInformation   kvc;
   
   [[self class] _divineTakeValueForKeyKVCInformation:&kvc
                                                  key:key];
   _MulleObjCSetObjectValueWithKVCInformation( self, value, &kvc);
   _MulleObjCClearKVCInformation( &kvc);
}


- (void) takeStoredValue:(id) value 
                  forKey:(NSString *) key
{
   struct _MulleObjCKVCInformation   kvc;
   
   [[self class] _divineTakeStoredValueForKeyKVCInformation:&kvc
                                                        key:key];
   _MulleObjCSetObjectValueWithKVCInformation( self, value, &kvc);
   _MulleObjCClearKVCInformation( &kvc);
}                  


static id   traverse_key_path( id obj,
                               char *buf,
                               size_t len,
                               struct _MulleObjCCheatingASCIIStringStorage *tmp)
{
   id       key;
   char     *p;
   char     *memo;
   char     *sentinel;

   sentinel = &buf[ len];
   memo     = buf;
   
   for( p = buf; p < sentinel;)
   {
      if( *p++ != '.')
         continue;

      *p   = 0;
      key  = _MulleObjCCheatingASCIIStringStorageInit( tmp, memo, p - memo);
      memo = p;
      obj  = [obj valueForKey:key];
   }
   
   *p = 0;
   _MulleObjCCheatingASCIIStringStorageInit( tmp, memo, p - memo);

   return( obj);
}



- (id) valueForKeyPath:(NSString *) keyPath
{
   NSUInteger                                    len;
   char                                          *s;
   char                                          *buf;
   id                                            key;
   id                                            obj;
   struct _MulleObjCCheatingASCIIStringStorage   tmp;
   
   s   = (char *) [keyPath UTF8String];
   len = [keyPath _UTF8StringLength];
   
   buf = alloca( len + 1);
   memcpy( buf, s, len);

   obj  = traverse_key_path( self, buf, len, &tmp);
   key  = _MulleObjCCheatingASCIIStringStorageGetObject( &tmp);

   return( [obj valueForKey:key]);
}        

- (void) takeValue:(id) value 
        forKeyPath:(NSString *) keyPath
{
   NSUInteger                                    len;
   char                                          *s;
   char                                          *buf;
   id                                            key;
   id                                            obj;
   struct _MulleObjCCheatingASCIIStringStorage   tmp;
   
   s   = (char *) [keyPath UTF8String];
   len = [keyPath _UTF8StringLength];
   
   buf = alloca( len + 1);
   memcpy( buf, s, len);

   obj  = traverse_key_path( self, buf, len, &tmp);
   key  = _MulleObjCCheatingASCIIStringStorageGetObject( &tmp);

   [obj takeValue:value
           forKey:key];
}        


void    MulleObjCThrowUndefinedKeyException( id self, NSString *key)
{
   [NSException raise:NSUndefinedKeyException
               format:@"%@ undefined on %@", key, self];
}


- (id) handleQueryWithUnboundKey:(NSString *) key;
{
   MulleObjCThrowUndefinedKeyException( self, key);
   return( nil);
}


- (id) valueForUndefinedKey:(NSString *) key
{  
   MulleObjCThrowUndefinedKeyException( self, key);
   return( nil);
}


- (void) handleTakeValue:(id) value 
           forUnboundKey:(NSString *) key
{
   MulleObjCThrowInvalidArgumentException( self, [key UTF8String]);
}           
       
               
- (void) unableToSetNilForKey:(NSString *)key
{
   MulleObjCThrowInvalidArgumentException( self, [key UTF8String]);
}


- (NSDictionary *) valuesForKeys:(NSArray *) keys
{
   NSMutableDictionary   *dictionary;
   NSEnumerator          *rover;
   NSString              *key;
   id                    value;
   
   dictionary = [NSMutableDictionary dictionary];
   rover = [keys objectEnumerator];
   while( key = [rover nextObject])
   {
      value = [self valueForKey:key];
      if( value)
         [dictionary setObject:value
                         forKey:key];
   }
   return( dictionary);
}


- (void) takeValuesFromDictionary:(NSDictionary *) properties
{
   NSEnumerator   *rover;
   NSString       *key;
   id             value;   
   
   rover = [properties objectEnumerator];
   while( key = [rover nextObject])
   {
      value = [properties objectForKey:key];
      [self takeValue:value
               forKey:key];
   }
}

@end


@implementation NSObject( _KeyValueCodingCompatibility)

// "modern" KVC interface
- (void) setValue:(id)value 
           forKey:(NSString *) key
{
   [self takeValue:value
            forKey:key];
}


- (void) setValue:(id)value 
           forKeyPath:(NSString *) key
{
   [self takeValue:value
        forKeyPath:key];
}


- (void) setValue:(id) value 
   forUndefinedKey:(NSString *) key
{
   [self handleTakeValue:value
          forUnboundKey:key];
}


- (void) setNilValueForKey:(NSString *)key
{
   [self unableToSetNilForKey:key];
}


- (NSDictionary *) dictionaryWithValuesForKeys:(NSArray *) keys
{
   return( [self valuesForKeys:keys]);
}

@end
