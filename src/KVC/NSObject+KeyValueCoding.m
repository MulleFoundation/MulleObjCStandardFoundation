/*
 *  MulleFoundation - the mulle-objc class library
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
#import "NSNumber+MulleObjCArithmetic.h"

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


// TODO: make this a plugin format, so that one can specify
//       dynamically collection operators
enum collection_operator
{
   no_opcode = -2,
   unknown_opcode = -1,
   count_opcode = 0,
   avg_opcode,
   min_opcode,
   max_opcode,
   sum_opcode
};
   
static enum collection_operator  operator_opcode( char *s, size_t len)
{
   if( len < 2 || *s != '@')
      return( no_opcode);

   switch( s[ 1])
   {
   case 'a' :
      if( ! strncmp( s, "@avg", len))
         return( avg_opcode);
      break;

   case 'c' :
      if( ! strncmp( s, "@count", len))
         return( count_opcode);
      break;
         
   case 'm' :
      if( ! strncmp( s, "@min", len))
         return( min_opcode);
      if( ! strncmp( s, "@max", len))
         return( max_opcode);
      break;
         
   case 's' :
      if( ! strncmp( s, "@sum", len))
         return( sum_opcode);
      break;
   }
   return( unknown_opcode);
}


static int  handle_operator( NSString *key, char *s, size_t len, char *rest, size_t rest_len, id *obj)
{
   enum collection_operator   opcode;
   NSEnumerator               *rover;
   id                         element;
   NSString                   *restPath;
   id                         previous;
   id                         value;
   id                         total;
   NSUInteger                 count;
   
   opcode = operator_opcode( (char *) s, len);
   switch( opcode)
   {
   case unknown_opcode :
      [NSException raise:NSInvalidArgumentException
                  format:@"%@ doesn't know what to do with %@", *obj, key];
   case no_opcode :
      return( 0);
      
   case count_opcode :
      *obj = [NSNumber numberWithUnsignedInteger:[*obj count]];
      return( 1);
   default :
      break;
   }

   restPath = nil;
   if( rest && rest_len)
      restPath = [NSString _stringWithUTF8Characters:(void *) rest
                                              length:rest_len];
   rover    = [*obj objectEnumerator];

   value    = nil;
   previous = nil;
   switch( opcode)
   {
   case min_opcode :
   case max_opcode :
      while( element = [rover nextObject])
      {
         value = element;
         if( restPath)
            value = [element valueForKeyPath:restPath];
         
         if( ! previous)
         {
            previous = value;
            continue;
         }
         if( ! value)
            continue;
         
         switch( [previous compare:value])
         {
         case NSOrderedSame :
            continue;
         case NSOrderedAscending :
            if( opcode == max_opcode)
               previous = value;
            break;
         case NSOrderedDescending :
            if( opcode == min_opcode)
               previous = value;
            break;
         }
      }
      *obj = previous;
      return( 1);
         
      // specification says to add "doubles" but this is
      // wrong when dealing with money (NSDecimalNumber)
         
   case avg_opcode :
   case sum_opcode :
      count = 0;
      total = nil;
      while( element = [rover nextObject])
      {
         value = element;
         if( restPath)
            value = [element valueForKeyPath:restPath];

         total = [value _add:total];
         count++;
      }
      if( opcode == avg_opcode && count)
         *obj = [total _divideByInteger:count];
      else
         *obj = total;
   }
   return( 1);
}


- (id) valueForKeyPath:(NSString *) keyPath
{
   NSUInteger                                    len;
   char                                          *buf;
   char                                          *memo;
   char                                          *s;
   char                                          *sentinel;
   char                                          *substring;
   id                                            key;
   id                                            obj;
   size_t                                        substring_len;
   struct _MulleObjCCheatingASCIIStringStorage   tmp;
   
   s   = (char *) [keyPath UTF8String];
   len = [keyPath _UTF8StringLength];
   
   buf = alloca( len + 1);
   memcpy( buf, s, len);

   // this travese_key_path handles operators
   {
      sentinel = &buf[ len];
      memo     = buf;
      obj      = self;
      
      for( s = buf; s < sentinel; s++)
      {
         if( *s != '.')
            continue;
         
         *s            = 0;
         substring     = memo;
         substring_len = s - memo;
         memo          = s + 1;
         
         key  = _MulleObjCCheatingASCIIStringStorageInit( &tmp, substring, substring_len);
         if( handle_operator( key, substring, substring_len, memo, &buf[ len] - memo, &obj))
            return( obj);
         
         obj = [obj valueForKey:key];
      }
      
      *s            = 0;
      substring     = memo;
      substring_len = s - memo;
      
      key = _MulleObjCCheatingASCIIStringStorageInit( &tmp, substring, substring_len);
      if( handle_operator( key,
                          _MulleObjCCheatingASCIIStringStorageGetStorage( &tmp),
                          _MulleObjCCheatingASCIIStringStorageGetLength( &tmp),
                          NULL,
                          0,
                          &obj))
      {
         return( obj);
      }
   }

   return( [obj valueForKey:key]);
}        


static id   traverse_key_path( id obj,
                              char *buf,
                              size_t len,
                              struct _MulleObjCCheatingASCIIStringStorage *tmp)
{
   char     *memo;
   char     *s;
   char     *sentinel;
   char     *substring;
   id       key;
   size_t   substring_len;
   
   sentinel = &buf[ len];
   memo     = buf;
   
   for( s = buf; s < sentinel; s++)
   {
      if( *s != '.')
         continue;
      
      *s            = 0;
      substring     = memo;
      substring_len = s - memo;
      memo          = s + 1;
      
      key  = _MulleObjCCheatingASCIIStringStorageInit( tmp, substring, substring_len);
      obj = [obj valueForKey:key];
   }
   
   *s            = 0;
   substring     = memo;
   substring_len = s - memo;
   
   key = _MulleObjCCheatingASCIIStringStorageInit( tmp, substring, substring_len);
   return( obj);
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
