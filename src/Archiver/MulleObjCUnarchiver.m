//
//  MulleObjCUnarchiver.m
//  MulleObjCFoundation
//
//  Created by Nat! on 20.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCUnarchiver.h"

// other files in this library
#import "MulleObjCArchiver+Private.h"
#include "mulle_buffer_archiver.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@implementation MulleObjCUnarchiver

+ (id) unarchiveObjectWithData:(NSData *) data
{
   MulleObjCUnarchiver   *unarchiver;
   
   unarchiver = [[[self alloc] initForReadingWithData:data] autorelease];
   return( [unarchiver decodeObject]);
}


- (BOOL) atEnd
{
   return( mulle_buffer_is_full( &_buffer));
}


- (NSString *) classNameDecodedForArchiveClassName:(NSString *) archiveName
{
   mulle_utf8_t   *s;
   
   s = NSMapGet( _classNameSubstitutions, [archiveName UTF8String]);
   if( ! s)
      return( nil);
   
   return( [NSString stringWithUTF8String:s]);
}


- (void) decodeClassName:(NSString *) archiveName
             asClassName:(NSString *) runtimeName
{
   NSParameterAssert( [runtimeName length]);
   NSParameterAssert( [archiveName length]);
   
   NSMapInsert( _classNameSubstitutions,
               [archiveName UTF8String],
               [runtimeName UTF8String]);
}


- (void) replaceObject:(id) original
            withObject:(id) replacement
{
   NSMapInsert( _objectSubstitutions,  original, replacement);
}


#pragma mark -
#pragma mark reading

static int   check_header_8( struct mulle_buffer *buffer, char *expect)
{
   char  header[ 8];
   
   if( mulle_buffer_next_bytes( buffer, header, 8) < 0)
      return( NO);
   if( memcmp( header, expect, 8))
      return( NO);
   
   return( YES);
}


- (BOOL) _nextObjectTable
{
   Class          cls;
   id             obj;
   off_t          offset;
   unsigned int   cls_index;
   unsigned int   i, n;
   
   if( ! check_header_8( &_buffer, "**obj**"))
      return( NO);
   
   n = (unsigned int) mulle_buffer_next_integer( &_buffer);
   for( i = 0; i < n; i++)
   {
      cls_index = (unsigned int) mulle_buffer_next_integer( &_buffer);
      offset    = (off_t) mulle_buffer_next_integer( &_buffer);
      
      // write down class name
      cls = NSMapGet( _classes, (void *) cls_index);
      if( ! cls)
         return( NO);
      
      obj = [cls alloc];  // don't replace yet
      NSMapInsert( _objects, (void *) (i + 1), (void *) obj);
      [obj release];
      
      NSMapInsert( _offsets, (void *) (i + 1), (void *) offset);
   }
   return( YES);
}


- (BOOL) _nextClassTable
{
   Class                   cls;
   NSInteger               version;
   char                    *name;
   char                    *substitution;
   mulle_objc_uniqueid_t   clshash;
   mulle_objc_uniqueid_t   ivarhash;
   struct blob             *blob;
   unsigned int            i, n;
   unsigned int            name_index;
   
   if( ! check_header_8( &_buffer, "**cls**"))
      return( NO);
   
   n = (unsigned int) mulle_buffer_next_integer( &_buffer);
   for( i = 0; i < n; i++)
   {
      version    = (NSUInteger) mulle_buffer_next_integer( &_buffer);
      ivarhash   = (mulle_objc_uniqueid_t) mulle_buffer_next_integer( &_buffer);
      name_index = (unsigned int) mulle_buffer_next_integer( &_buffer);
      
      // write down class name
      blob = NSMapGet( _blobs, (void *) name_index);
      if( ! blob)
         return( NO);
      
      name = blob->_storage;
      substitution = NSMapGet( _classNameSubstitutions, name);
      if( substitution)
         name = substitution;
      
      clshash = mulle_objc_uniqueid_from_string( blob->_storage);
      cls     = _mulle_objc_runtime_lookup_class( mulle_objc_get_runtime() , clshash);
      if( ! cls)
         return( NO);
      
      if( [cls version] < version)
         return( NO);
      
      // warn if ivarhash differs in debug mode
      
      NSMapInsert( _classes, (void *) (i + 1), cls);
   }
   return( YES);
}


- (void) _initObjects
{
   NSMapEnumerator                        rover;
   id                                     inited;
   id                                     obj;
   off_t                                  memo;
   off_t                                  offset;
   struct mulle_pointerarray              classcluster;
   struct mulle_pointerarray              regular;
   struct mulle_pointerarray_enumerator   enumerator;
   void                                   *obj_index;
   
   mulle_pointerarray_init( &classcluster, 1024, NULL, MulleObjCAllocator());
   mulle_pointerarray_init( &regular, 1024, NULL, MulleObjCAllocator());
   
   rover = NSEnumerateMapTable( _objects);
   while( NSNextMapEnumeratorPair( &rover, &obj_index, (void **) &obj))
   {
      assert( obj_index);
      if( [obj respondsToSelector:@selector( decodeWithCoder:)])
         mulle_pointerarray_add( &classcluster, (void *) obj_index);
      else
         mulle_pointerarray_add( &regular, (void *) obj_index);
   }
   NSEndMapTableEnumeration( &rover);

   
   memo  = mulle_buffer_get_seek( &_buffer);

   /* do class cluster objects, that may change self */

   enumerator = mulle_pointerarray_enumerate( &classcluster);
   while( obj_index =  mulle_pointerarray_enumerator_next( &enumerator))
   {
      offset = (off_t) NSMapGet( _offsets, obj_index);
      
      if( ! offset || mulle_buffer_set_seek( &_buffer, SEEK_SET, offset))
         [NSException raise:NSInconsistentArchiveException
                     format:@"archive damaged"];
      
      obj    = (id) NSMapGet( _objects, obj_index);
      inited = [self _initObject:obj];
      
      if( ! inited)
         [NSException raise:NSInconsistentArchiveException
                     format:@"%@ returned nil from initWithCoder:", [obj class]];

      if( inited != obj)
         NSMapInsert( _objects, (void *) obj_index, inited);
   }
   mulle_pointerarray_enumerator_done( &enumerator);
   mulle_pointerarray_done( &classcluster);

   /* do regular objects, that must not change self */
   enumerator = mulle_pointerarray_enumerate( &regular);
   while( obj_index = (void *) mulle_pointerarray_enumerator_next( &enumerator))
   {
      offset = (off_t) NSMapGet( _offsets, obj_index);
      
      if( ! offset || mulle_buffer_set_seek( &_buffer, SEEK_SET, offset))
         [NSException raise:NSInconsistentArchiveException
                     format:@"archive damaged"];
      
      obj    = (id) NSMapGet( _objects, obj_index);
      inited = [self _initObject:obj];
      
      if( inited != obj)
         [NSException raise:NSInconsistentArchiveException
                     format:@"%@ must implement -decodeWithCoder: if it wants to return a different object than self", [self class]];
   }
   mulle_pointerarray_enumerator_done( &enumerator);
   mulle_pointerarray_done( &regular);

   mulle_buffer_set_seek( &_buffer, SEEK_SET, memo);
}


- (BOOL) _nextSelectorTable
{
   mulle_objc_methodid_t   sel;
   size_t                  len;
   struct blob             *blob;
   unsigned int            i, n;
   unsigned int            sel_index;
   
   if( ! check_header_8( &_buffer, "**sel**"))
      return( NO);
   
   n = (unsigned int) mulle_buffer_next_integer( &_buffer);
   for( i = 0; i < n; i++)
   {
      len = mulle_buffer_next_integer( &_buffer);
      if( ! len)
         return( NO);
      
      sel_index = (unsigned int) mulle_buffer_next_integer( &_buffer);
      
      blob = NSMapGet( _blobs, (void *) sel_index);
      if( ! blob)
         return( NO);
      
      sel = mulle_objc_uniqueid_from_string( blob->_storage);
      NSMapInsert( _selectors, (void *) (i + 1), (void *) sel);
   }
   return( YES);
}


- (BOOL) _nextBlobTable
{
   size_t                   len;
   struct blob              *blob;
   struct mulle_allocator   *allocator;
   unsigned int             i, n;
   void                     *bytes;
   
   if( ! check_header_8( &_buffer, "**blb**"))
      return( NO);
   
   allocator = MulleObjCAllocator();
   
   n = (unsigned int) mulle_buffer_next_integer( &_buffer);
   for( i = 0; i < n; i++)
   {
      len = mulle_buffer_next_integer( &_buffer);
      if( ! len)
         return( NO);

      bytes = mulle_buffer_reference_bytes( &_buffer, len);
      if( ! bytes)
         return( NO);
      
      blob           = mulle_allocator_malloc( allocator, sizeof( struct blob));
      blob->_storage = bytes;
      blob->_length  = len;
      
      NSMapInsert( _blobs, (void *) (i + 1), blob);
   }
   return( YES);
}


- (BOOL) _readHeader
{
   char       header[ 16];
   NSInteger  version;
   
   if( mulle_buffer_next_bytes( &_buffer, header, 16) < 0)
      return( NO);
   if( memcmp( header, "mulle-obj-stream", 16))
      return( NO);
   
   version =  mulle_buffer_next_integer( &_buffer);
   if( version != [self systemVersion])
      return( NO);
   
   return( YES);
}


- (BOOL) _startDecode
{
   off_t   startData;
   off_t   startClass;
   off_t   startSelector;
   off_t   startObject;
   off_t   startBlob;
   
   [self _readHeader];
   
   // read table offsets at end
   mulle_buffer_set_seek( &_buffer, SEEK_END, (off_t) sizeof( long long) * 5 + 8);
   
   if( ! check_header_8( &_buffer, "**off**"))
      return( NO);
   
   startData     = mulle_buffer_next_long_long( &_buffer);
   startObject   = mulle_buffer_next_long_long( &_buffer);
   startClass    = mulle_buffer_next_long_long( &_buffer);
   startSelector = mulle_buffer_next_long_long( &_buffer);
   startBlob     = mulle_buffer_next_long_long( &_buffer);
   
   if( startClass < startObject)
      return( NO);
   if( startSelector < startClass)
      return( NO);
   if( startBlob < startSelector)
      return( NO);
   
   mulle_buffer_set_seek( &_buffer, SEEK_SET, startBlob);
   if( ! [self _nextBlobTable])
      return( NO);
   
   mulle_buffer_set_seek( &_buffer, SEEK_SET, startSelector);
   if( ! [self _nextSelectorTable])
      return( NO);
   
   mulle_buffer_set_seek( &_buffer, SEEK_SET, startClass);
   if( ! [self _nextClassTable])
      return( NO);
   
   mulle_buffer_set_seek( &_buffer, SEEK_SET, startObject);
   if( ! [self _nextObjectTable])
      return( NO);
   
   mulle_buffer_set_seek( &_buffer, SEEK_SET, startData);
   return( check_header_8( &_buffer, "**dta**"));
}


- (instancetype) initForReadingWithData:(NSData *) data
{
   struct mulle_allocator   *allocator;

   [super init];
   
   allocator = MulleObjCObjectGetAllocator( self);
   _objects   = _NSCreateMapTableWithAllocator( NSIntegerMapKeyCallBacks, NSObjectMapValueCallBacks, 16, allocator);
   _offsets   = _NSCreateMapTableWithAllocator( NSIntegerMapKeyCallBacks, mulle_container_valuecallback_intptr, 16, allocator);
   
   _classes   = _NSCreateMapTableWithAllocator( NSIntegerMapKeyCallBacks, NSNonRetainedObjectMapValueCallBacks, 16, allocator);
   _selectors = _NSCreateMapTableWithAllocator( NSIntegerMapKeyCallBacks, NSIntegerMapValueCallBacks, 16, allocator);
   _blobs     = _NSCreateMapTableWithAllocator( NSIntegerMapKeyCallBacks, NSOwnedPointerMapValueCallBacks, 16, allocator);
   
   _classNameSubstitutions = _NSCreateMapTableWithAllocator( mulle_container_keycallback_copied_cstring,
                                              mulle_container_valuecallback_copied_cstring, 16, allocator);
   _objectSubstitutions    = _NSCreateMapTableWithAllocator( NSObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 16, allocator);
   
   _data = [data retain];
   
   mulle_buffer_init_inflexable_with_static_bytes( &_buffer, [data bytes], [data length]);
   
   if( ! [self _startDecode])
   {
      [self release];
      return( nil);
   }
   return( self);
}


- (void) dealloc
{
   [_data release];
   
   NSFreeMapTable( _objectSubstitutions);
   NSFreeMapTable( _classNameSubstitutions);
   
   NSFreeMapTable( _blobs);
   NSFreeMapTable( _selectors);
   NSFreeMapTable( _classes);
   NSFreeMapTable( _offsets);
   NSFreeMapTable( _objects);
   
   mulle_buffer_done( &_buffer);
   [super dealloc];
}



#pragma mark -
#pragma mark reading code

- (struct blob *) _nextBlob
{
   unsigned int   blob_index;
   struct blob    *blob;
   
   blob_index = (unsigned int) mulle_buffer_next_integer( &_buffer);
   if( ! blob_index)
      return( NULL);
   
   blob = NSMapGet( _blobs, (void *) blob_index);
   if( ! blob)
      [NSException raise:NSInconsistentArchiveException
                  format:@"archive damaged"];
   
   return( blob);
}


- (char *) _nextCString
{
   struct blob    *blob;
   
   blob = [self _nextBlob];
   return( blob ? blob->_storage : NULL);
}


- (id) _initObject:(id) obj
{
   return( [obj initWithCoder:self]);
}


- (id) _nextObject
{
   unsigned int   obj_index;
   id             obj;
   id             replacement;

   // do this delayed, so we pick up changes to the archiver from the user
   if( ! _inited)
   {
      _inited = YES;
      [self _initObjects];
   }
   
   obj_index = (unsigned int) mulle_buffer_next_integer( &_buffer);
   if( ! obj_index)
      return( nil);
   
   obj = NSMapGet( _objects, (void *) obj_index);
   if( ! obj)
      [NSException raise:NSInconsistentArchiveException
                  format:@"archive damaged"];

   // now substitute here (I guess)
   replacement = NSMapGet( _objectSubstitutions, obj);
   return( replacement ? replacement : obj);
}


- (Class) _nextClass
{
   unsigned int   cls_index;
   Class          cls;
   
   cls_index = (unsigned int) mulle_buffer_next_integer( &_buffer);
   if( ! cls_index)
      return( Nil);
   
   cls = NSMapGet( _classes, (void *) cls_index);
   if( ! cls)
      [NSException raise:NSInconsistentArchiveException
                  format:@"archive damaged"];
   return( cls);
}


- (SEL) _nextSelector
{
   unsigned int   sel_index;
   SEL            sel;
   
   sel_index = (unsigned int) mulle_buffer_next_integer( &_buffer);
   if( ! sel_index)
      return( (SEL) 0);
   
   sel = (SEL) NSMapGet( _selectors, (void *) sel_index);
   if( ! sel)
      [NSException raise:NSInconsistentArchiveException
                  format:@"archive damaged"];
   return( sel);
}


- (void *) _decodeBytesForKey:(NSString *) key
               returnedLength:(NSUInteger *) len_p
{
   struct blob          *blob;
   static struct blob   empty_blob;
   
   blob = [self _nextBlob];
   
   if( ! blob)
      blob = &empty_blob;
   if( len_p)
      *len_p = blob->_length;
   
   return( blob->_storage);
}


- (void *) _decodeValueOfObjCType:(char *) type
                               at:(void *) p
{
   assert( type);
   assert( p);
   
   switch( *type)
   {
   case _C_CHR      : *(char *) p = (char) mulle_buffer_next_byte( &_buffer);
                      return( (char *) p + 1);
         
   case _C_UCHR     : *(unsigned char *) p = (unsigned char) mulle_buffer_next_byte( &_buffer);
                      return( (unsigned char *) p + 1);
         
   case _C_SHT      : *(short *) p = (short) mulle_buffer_next_integer( &_buffer);
                      return( (short *) p + 1);
         
   case _C_USHT     : *(unsigned short *) p = (unsigned short) mulle_buffer_next_integer( &_buffer);
                      return( (unsigned short *) p + 1);
         
   case _C_INT      : *(int *) p = (int) mulle_buffer_next_integer( &_buffer);
                      return( (int *) p + 1);
         
   case _C_UINT     : *(unsigned int *) p = (unsigned int) mulle_buffer_next_integer( &_buffer);
                      return( (unsigned int *) p + 1);
         
   case _C_LNG      : *(long *) p = (long) mulle_buffer_next_integer( &_buffer);
                      return( (long *) p + 1);
         
   case _C_ULNG     : *(unsigned long *) p = (unsigned long) mulle_buffer_next_integer( &_buffer);
                      return( (unsigned long *) p + 1);
         
   case _C_LNG_LNG  : *(long long *) p = (long long) mulle_buffer_next_integer( &_buffer);
                      return( (long long *) p + 1);
         
   case _C_ULNG_LNG : *(unsigned long long *) p = (unsigned long long) mulle_buffer_next_integer( &_buffer);
                      return( (unsigned long long *) p + 1);
      
   case _C_FLT      : *(float *) p = (float) mulle_buffer_next_float( &_buffer);
                      return( (float *) p + 1);
         
   case _C_DBL      : *(double *) p = (double) mulle_buffer_next_double( &_buffer);
                      return( (double *) p + 1);
         
   case _C_LNG_DBL  : *(long double *) p = (long double) mulle_buffer_next_long_double( &_buffer);
                      return( (long double *) p + 1);
      
   case _C_CHARPTR  : assert( ! *(char **) p);  // leak protection
                      *(char **) p = MulleObjCDuplicateCString( [self _nextCString]);
                      return( (char *) p + 1);
         
   case _C_COPY_ID  :
   case _C_ID       : assert( ! *(id *) p);  // leak protection
                      *(id *) p = [[self _nextObject] retain];
                      return( (id *) p + 1);
         
   case _C_ASSIGN_ID: *(id *) p = [self _nextObject];
                      return( (id *) p + 1);
         
      
   case _C_CLASS    : *(Class *) p = [self _nextClass];
                      return( (Class *) p + 1);
         
   case _C_SEL      : *(SEL *) p = [self _nextSelector];
                      return( (SEL *) p + 1);
         
   case _C_ARY_B    :
   {
      char     *s;
      char     c;
      size_t   i, n;
      
      n = 0;
      s = type + 1;
      
      //
      // we are dealing with something that looks like this
      // [2{test={MulleObjCRange=QQ}{?=b1}*[16c]}]
      // we parse the integer behind the '['
      //
      assert( *s >= '0' && *s <= '9');
      
      for(;;)
      {
         c    = *s++;
         if( c < '0' || c > '9')
            break;
         n  = n * 10;
         n += *s++ - '0';
      }
      
      n = (size_t) mulle_buffer_next_integer( &_buffer);
      for( i = 0; i < n; i++)
         p = [self _decodeValueOfObjCType:type
                                       at:p];
      return( p);
   }
      
   case _C_STRUCT_B :
   {
      //
      // we are dealing with something that looks like this
      // {test={MulleObjCRange=QQ}{?=b1}*[16c]}]
      // we parse behind the '='
      char     *s;
      
      s = type + 1;
      while( *s++ != '='); // we assume the encoding is friendly
      
      while( *s != _C_STRUCT_E)
      {
         p = [self _decodeValueOfObjCType:s
                                       at:p];
         s = NSGetSizeAndAlignment( s, NULL, NULL);
      }
      return( p);
   }
      
      // the smart thing would be to find the big
   case _C_UNION_B :
   {
      char         *s;
      char         *next;
      char         *max_type;
      NSUInteger   max_size;
      NSUInteger   size;
      
      s = type + 1;
      while( *s++ != '='); // we assume the encoding is friendly
      
      next     = s;
      max_size = 0;
      while( *next != _C_UNION_E)
      {
         next = NSGetSizeAndAlignment( next, &size, NULL);
         if( size >= max_size)
         {
            max_type = next;
            max_size = size;
         }
      }
      p = [self _decodeValueOfObjCType:max_type
                                    at:p];
      return( p);
   }
         
   default :
      [NSException raise:NSInconsistentArchiveException
                  format:@"NSArchiver cannot encode type=\"%s\"", type];
   }
   return( p);
}

@end
