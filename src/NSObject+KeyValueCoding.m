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

#import "_MulleObjCKeyValueCodingFoundation.h"
#import "_MulleObjCKeyValueCodingFoundationParentIncludes.h"


NSString   *NSUndefinedKeyException = @"NSUndefinedKeyException";


@implementation NSObject( _KeyValueCoding)

+ (BOOL) useStoredAccessor
{
   return( YES);
}


- (id) valueForKey:(NSString *) key
{
   _NSKVCInformation   kvc;
   id                  value;
   
   [isa _divineValueForKeyKVCInformation:&kvc
                                     key:key];
   value = _NSGetObjectValueWithKVCInformation( self, &kvc);
   _NSClearKVCInformation( &kvc);
   return( value);
}


- (id) storedValueForKey:(NSString *) key
{
   _NSKVCInformation   kvc;
   id                  value;
   
   [isa _divineStoredValueForKeyKVCInformation:&kvc
                                           key:key];
   value = _NSGetObjectValueWithKVCInformation( self, &kvc);
   _NSClearKVCInformation( &kvc);
   return( value);
}


- (void) takeValue:(id) value 
             forKey:(NSString *) key
{
   _NSKVCInformation   kvc;
   
   [isa _divineTakeValueForKeyKVCInformation:&kvc
                                         key:key];
   _NSSetObjectValueWithKVCInformation( self, value, &kvc);
   _NSClearKVCInformation( &kvc);
}


- (void) takeStoredValue:(id) value 
                  forKey:(NSString *) key
{
   _NSKVCInformation   kvc;
   
   [isa _divineTakeStoredValueForKeyKVCInformation:&kvc
                                               key:key];
   _NSSetObjectValueWithKVCInformation( self, value, &kvc);
   _NSClearKVCInformation( &kvc);
}                  


static id   tarverse_key_path( id obj, char *buf, size_t len, _NSCheatingCStringStorage *tmp)
{
   id       key;
   char     *p;
   char     *memo;
   char     *sentinel;

   sentinel = &buf[ len];
   memo     = buf;
//   obj      = self;
   
   for( p = buf; p < sentinel;)
   {
      if( *p++ != '.')
         continue;

      *p   = 0;
      key  = _NSInitCheatingCStringInStorage( tmp, memo, p - memo);
      memo = p;
      obj  = [obj valueForKey:key];
   }
   
   *p = 0;
   _NSInitCheatingCStringInStorage( tmp, memo, p - memo);

   return( obj);
}


- (id) valueForKeyPath:(NSString *) keyPath
{
   char     *buf;
   id       obj;
   id       key;
   size_t   len;
   _NSCheatingCStringStorage  tmp;
   _NSCStringContents         contents;   
   
   contents = [keyPath _cStringContents];
   len      = contents.length;   
   buf      = _NSSafeAlloca( len + 1);
   
   memcpy( buf, contents.string, len);

   obj  = tarverse_key_path( self, buf, len, &tmp);
   key  = NSObjectFrom_NSObject( (_NSObject *) &tmp);

   return( [obj valueForKey:key]);
}        

- (void) takeValue:(id) value 
        forKeyPath:(NSString *) keyPath
{
   char     *buf;
   id       obj;
   id       key;
   size_t   len;
   _NSCheatingCStringStorage  tmp;
   _NSCStringContents         contents;  
   
   contents = [keyPath _cStringContents];
   
   len      = contents.length;   
   buf = _NSSafeAlloca( len + 1);
   memcpy( buf, contents.string, len);

   
   obj  = tarverse_key_path( self, buf, len, &tmp);
   key  = NSObjectFrom_NSObject( (_NSObject *) &tmp);

   [obj takeValue:value
           forKey:key];
}        


void    __NSThrowUndefinedKeyException( id self, NSString *key)
{
   [NSException raise:NSUndefinedKeyException
               format:@"%@ undefined on %@", key, self];
}


- (id) handleQueryWithUnboundKey:(NSString *) key;
{
   __NSThrowUndefinedKeyException( self, key);
   return( nil);
}


- (id) valueForUndefinedKey:(NSString *) key
{  
   __NSThrowUndefinedKeyException( self, key);
   return( nil);
}


- (void) handleTakeValue:(id) value 
           forUnboundKey:(NSString *) key
{
   __NSThrowInvalidArgumentException( self, [key cString]);
}           
       
               
- (void) unableToSetNilForKey:(NSString *)key
{
   __NSThrowInvalidArgumentException( self, [key cString]);
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
