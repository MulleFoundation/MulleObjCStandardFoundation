//
//  MulleObjCArchiver.m
//  MulleObjCFoundation
//
//  Created by Nat! on 20.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCArchiver.h"

// other files in this library
#import "MulleObjCArchiver+Private.h"
#include "mulle_buffer_archiver.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies


NSString  *NSInconsistentArchiveException = @"NSInconsistentArchiveException";


#pragma mark -

@implementation MulleObjCArchiver

- (id) init
{
   _allocator = *MulleObjCObjectGetAllocator( self);
   
   mulle_buffer_init( &_buffer, &_allocator);
   
   self->_callback.keycallback   =  mulle_container_keycallback_nonowned_pointer;
   self->_callback.valuecallback =  mulle_container_valuecallback_intptr;
   
   MulleObjCPointerHandleMapInit( &_objects, 0x10000, &_callback, &_allocator);
   MulleObjCPointerHandleMapInit( &_conditionalObjects, 0x10000, &_callback, &_allocator);
   MulleObjCPointerHandleMapInit( &_classes, 0x100, &_callback, &_allocator);
   MulleObjCPointerHandleMapInit( &_selectors, 0x100, &_callback, &_allocator);
   
   self->_blob_callback.keycallback   =  mulle_container_keycallback_owned_pointer;
   self->_blob_callback.valuecallback =  mulle_container_valuecallback_intptr;
   
   self->_blob_callback.keycallback.hash     = (uintptr_t (*)()) blob_hash;
   self->_blob_callback.keycallback.is_equal = (int (*)()) blob_is_equal;
   
   MulleObjCPointerHandleMapInit( &_blobs, 0x100, &_blob_callback, &_allocator);
   
   _classNameSubstitutions = _NSCreateMapTableWithAllocator( mulle_container_keycallback_copied_cstring,
                                              mulle_container_valuecallback_copied_cstring, 16, &_allocator);
   _objectSubstitutions    = _NSCreateMapTableWithAllocator( NSObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 16, &_allocator);
   
   _offsets                = _NSCreateMapTableWithAllocator( NSNonOwnedPointerMapKeyCallBacks,
                                              mulle_container_valuecallback_intptr, 16, &_allocator);
   return( self);
}


- (void) dealloc
{
   MulleObjCPointerHandleMapDone( &_objects);
   MulleObjCPointerHandleMapDone( &_conditionalObjects);
   MulleObjCPointerHandleMapDone( &_classes);
   MulleObjCPointerHandleMapDone( &_selectors);
   MulleObjCPointerHandleMapDone( &_blobs);
   
   NSFreeMapTable( _offsets);
   NSFreeMapTable( _classNameSubstitutions);
   NSFreeMapTable( _objectSubstitutions);
   
   mulle_buffer_done( &_buffer);
   
   [super dealloc];
}


- (void) _writeHeader
{
   mulle_buffer_add_bytes( &_buffer, "mulle-obj-stream", 16);
   mulle_buffer_add_integer( &_buffer, [self systemVersion]); // archive version
}


- (void) encodeRootObject:(id) rootObject
{
   id             obj;
   size_t         startBlob;
   size_t         startClass;
   size_t         startData;
   size_t         startObject;
   size_t         startSelector;
   unsigned int   i, curr;
   unsigned int   start;
   
   mulle_buffer_reset( &_buffer);
   
   [self _writeHeader];
   
   startData = mulle_buffer_get_seek( &_buffer);
   mulle_buffer_add_bytes( &_buffer, "**dta**", 8);
   
   curr = 0;
   
   [self _appendObject:rootObject];
   
   // now just continue encoding objects until done
   for(;;)
   {
      start = curr;
      curr  = mulle_pointerarray_get_count( &_objects.array);
      if( curr == start)
         break;
      
      for( i = start; i < curr; i++)
      {
         obj = (id) mulle_pointerarray_get( &_objects.array, i);
         NSMapInsertKnownAbsent( _offsets, obj, (void *) mulle_buffer_get_seek( &_buffer));
         
         [obj encodeWithCoder:self];
         mulle_buffer_add_byte( &_buffer, 0);  // terminate with a zero
                                               // useful for key coder
      }
   }
   
   startObject = mulle_buffer_get_seek( &_buffer);
   [self _appendObjectTable];
   
   startClass = mulle_buffer_get_seek( &_buffer);
   [self _appendClassTable];
   
   startSelector = mulle_buffer_get_seek( &_buffer);
   [self _appendSelectorTable];
   
   startBlob = mulle_buffer_get_seek( &_buffer);
   [self _appendBlobTable];
   
   // dump table offsets at end
   mulle_buffer_add_bytes( &_buffer, "**off**", 8);
   mulle_buffer_add_long_long( &_buffer, startData);
   mulle_buffer_add_long_long( &_buffer, startObject);
   mulle_buffer_add_long_long( &_buffer, startClass);
   mulle_buffer_add_long_long( &_buffer, startSelector);
   mulle_buffer_add_long_long( &_buffer, startBlob);
   
   if( mulle_buffer_has_overflown( &_buffer))
      [NSException raise:NSInconsistentArchiveException
                  format:@"could not archive object %p", rootObject];
}


# pragma mark -
# pragma mark conveniences

+ (NSData *) archivedDataWithRootObject:(id) rootObject
{
   NSArchiver *archiver;
   
   archiver = [[self new] autorelease];
   [archiver encodeRootObject:rootObject];
   return( [archiver archiverData]);
}


# pragma mark -
# pragma mark accessor

- (NSMutableData *) archiverData
{
   size_t   len;
   
   len = mulle_buffer_get_length( &_buffer);
   if( ! len)
      return( nil);
   
   return( [NSMutableData dataWithBytes:mulle_buffer_get_bytes( &_buffer)
                                 length:len]);
}


# pragma mark -
# pragma mark output

- (void) _appendBytes:(void *) bytes
               length:(size_t) len
{
   intptr_t       handle;
   struct blob    search;
   struct blob    *blob;
   
   if( ! len)
   {
      mulle_buffer_add_integer( &_buffer, 0);
      return;
   }
   
   search._length  = len;
   search._storage = bytes;
   
   handle = (intptr_t) mulle_map_get( &_blobs.map, &search);
   if( ! handle)
   {
      handle         = mulle_map_get_count( &_blobs.map) + 1;
      blob           = mulle_allocator_malloc( &_allocator, sizeof( struct blob) + len);
      blob->_storage = blob + 1;
      blob->_length  = len;
      memcpy( blob->_storage, bytes, len);
      
      mulle_map_set( &_blobs.map, blob, (void *) handle);
      mulle_pointerarray_add( &_blobs.array, blob);
   }
   
   mulle_buffer_add_integer( &_buffer, handle);
}


- (void) _appendCString:(char *) s
{
   [self _appendBytes:s
               length:strlen( s) + 1]; // always with terminating zero
}


- (void) _appendClass:(Class) class
{
   intptr_t   handle;
   
   handle = class ? MulleObjCPointerHandleMapGet( &_classes, class) : 0;
   mulle_buffer_add_integer( &_buffer, handle);
}


- (void) _appendSelector:(SEL) sel
{
   intptr_t   handle;
   
   handle = sel ? MulleObjCPointerHandleMapGet( &_selectors, (void *) sel) : 0;
   mulle_buffer_add_integer( &_buffer, handle);
}


- (void) _appendObject:(id) obj
{
   intptr_t   handle;
   id         other;
   
   if( ! obj)
   {
      mulle_buffer_add_integer( &_buffer, 0);
      return;
   }
   
   other = NSMapGet( _objectSubstitutions, obj);
   if( other)
      obj = other;
   
   handle = (intptr_t) mulle_map_get( &_objects.map, obj);
   if( ! handle)
   {
      handle = (intptr_t) mulle_map_get( &_conditionalObjects.map, obj);
      if( ! handle)
         handle = ++_objectHandle;
      else
         mulle_map_remove( &_conditionalObjects.map, obj);
      
      mulle_map_set( &_objects.map, obj, (void *) handle);
      mulle_pointerarray_add( &_objects.array, obj);
   }
   
   mulle_buffer_add_integer( &_buffer, handle);
}


- (void) _appendConditionalObject:(id) obj
{
   intptr_t   handle;
   id         other;
   
   if( ! obj)
   {
      mulle_buffer_add_integer( &_buffer, 0);
      return;
   }
   
   other = NSMapGet( _objectSubstitutions, obj);
   if( other)
      obj = other;
   
   handle = (intptr_t) mulle_map_get( &_objects.map, obj);
   if( ! handle)
   {
      handle = (intptr_t) mulle_map_get( &_conditionalObjects.map, obj);
      if( ! handle)
         handle = ++_objectHandle;
      
      mulle_map_set( &_conditionalObjects.map, obj, (void *) handle);
   }
   
   mulle_buffer_add_integer( &_buffer, handle);
}


- (void *) _encodeValueOfObjCType:(char *) type
                               at:(void *) p
{
   assert( type);
   assert( p);
   
   switch( *type)
   {
   case _C_CHR      : mulle_buffer_add_byte( &_buffer, *(char *) p);
                      return( (char *) p + 1);
   case _C_UCHR     : mulle_buffer_add_byte( &_buffer, *(unsigned char *) p);
                      return( (unsigned char *) p + 1);
   case _C_SHT      : mulle_buffer_add_integer( &_buffer, *(short *) p);
                      return( (short *) p + 1);
   case _C_USHT     : mulle_buffer_add_integer( &_buffer, *(unsigned short *) p);
                      return( (unsigned short *) p + 1);
   case _C_INT      : mulle_buffer_add_integer( &_buffer, *(int *) p);
                      return( (int *) p + 1);
   case _C_UINT     : mulle_buffer_add_integer( &_buffer, *(unsigned int *) p);
                      return( (unsigned int *) p + 1);
   case _C_LNG      : mulle_buffer_add_integer( &_buffer, *(long *) p);
                      return( (long *) p + 1);
   case _C_ULNG     : mulle_buffer_add_integer( &_buffer, *(unsigned long *) p);
                      return( (unsigned long *) p + 1);
   case _C_LNG_LNG  : mulle_buffer_add_integer( &_buffer, *(long long *) p);
                      return( (long long *) p + 1);
   case _C_ULNG_LNG : mulle_buffer_add_integer( &_buffer, *(unsigned long long *) p);
                      return( (unsigned long long *) p + 1);
      
   case _C_FLT      : mulle_buffer_add_float( &_buffer, *(float *) p);
                      return( (float *) p + 1);
   case _C_DBL      : mulle_buffer_add_double( &_buffer, *(double *) p);
                      return( (double *) p + 1);
   case _C_LNG_DBL  : mulle_buffer_add_long_double( &_buffer, *(long double *) p);
                      return( (long double *) p + 1);
      
   case _C_CHARPTR  : [self _appendCString:*(char **) p];
                      return( (char *) p + 1);
   case _C_COPY_ID  :
   case _C_ID       : [self _appendObject:*(id *) p];
                      return( (id *) p + 1);
   case _C_ASSIGN_ID: [self _appendConditionalObject:*(id *) p];
                      return( (id *) p + 1);
   case _C_CLASS    : [self _appendClass:*(Class *) p];
                      return( (Class *) p + 1);
   case _C_SEL      : [self _appendSelector:*(SEL *) p ];
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
         c = *s;
         if( c < '0' || c > '9')
            break;
         
         n  = n * 10;
         n += c - '0';
         ++s;
      }
      
      assert( *s != _C_ARY_E);
      mulle_buffer_add_integer( &_buffer, n);
      for( i = 0; i < n; i++)
         p = [self _encodeValueOfObjCType:s
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
         p = [self _encodeValueOfObjCType:s
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

         p = [self _encodeValueOfObjCType:max_type
                                       at:p];
         return( p);
      }
   }
   
   [NSException raise:NSInconsistentArchiveException
               format:@"NSArchiver cannot encode type=\"%s\" (%d) ", type, *type];
   return( NULL);
}



#pragma mark -
#pragma mark uniqueing mechanisms


- (void) _appendObjectTable
{
   id             obj;
   unsigned int   i, n;
   size_t         offset;
   Class          cls;
   
   mulle_buffer_add_bytes( &_buffer, "**obj**", 8);
   
   n = mulle_pointerarray_get_count( &_objects.array);
   mulle_buffer_add_integer( &_buffer, n);
   
   for( i = 0; i < n; i++)
   {
      obj = (id) mulle_pointerarray_get( &_objects.array, i);
      cls = [obj classForCoder];
      
      [self _appendClass:cls];
      
      offset = (size_t) NSMapGet( _offsets, obj);
      mulle_buffer_add_integer( &_buffer, offset);
   }
}


- (void) _appendClassTable
{
   Class          cls;
   char           *name;
   char           *substitute;
   unsigned int   i, n;
   
   mulle_buffer_add_bytes( &_buffer, "**cls**", 8);
   
   n = mulle_pointerarray_get_count( &_classes.array);
   mulle_buffer_add_integer( &_buffer, n);
   
   for( i = 0; i < n; i++)
   {
      cls = (Class) mulle_pointerarray_get( &_classes.array, i);
      
      // write down version
      mulle_buffer_add_integer( &_buffer, [cls version]);
      
      // write down ivar hash for pedantic checks
      mulle_buffer_add_integer( &_buffer, _mulle_objc_class_get_ivarhash( cls));
      
      // write down class name
      name = _mulle_objc_class_get_name( cls);
      substitute = NSMapGet( _classNameSubstitutions, name);
      if( substitute)
         name = substitute;
      [self _appendCString:name];
   }
}


- (void) _appendSelectorTable
{
   SEL            sel;
   unsigned int   i, n;
   char           *name;
   
   mulle_buffer_add_bytes( &_buffer, "**sel**", 8);
   
   n = mulle_pointerarray_get_count( &_selectors.array);
   mulle_buffer_add_integer( &_buffer, n);
   for( i = 0; i < n; i++)
   {
      sel = (SEL) mulle_pointerarray_get( &_selectors.array, i);
      
      // get name for selector
      name = mulle_objc_lookup_methodname( (mulle_objc_methodid_t) sel);
      if( ! name)
         [NSException raise:NSInconsistentArchiveException
                     format:@"can't archive selector \"%p\" that is not registered in the runtime", sel];
      [self _appendCString:name];
   }
}


- (void) _appendBlobTable
{
   struct blob    *str;
   unsigned int   i, n;
   
   mulle_buffer_add_bytes( &_buffer, "**blb**", 8);
   
   n = mulle_pointerarray_get_count( &_blobs.array);
   mulle_buffer_add_integer( &_buffer, n);
   for( i = 0; i < n; i++)
   {
      str = (struct blob *) mulle_pointerarray_get( &_blobs.array, i);
      mulle_buffer_add_integer( &_buffer, str->_length);
      mulle_buffer_add_bytes( &_buffer, str->_storage, str->_length);
   }
}



#pragma mark -
#pragma mark hackish

- (NSString *) classNameEncodedForTrueClassName:(NSString *) trueName
{
   mulle_utf8_t   *s;
   
   s = NSMapGet( _classNameSubstitutions, [trueName UTF8String]);
   if( ! s)
      return( nil);
   
   return( [NSString stringWithUTF8String:s]);
}


- (void) encodeClassName:(NSString *) runtime
           intoClassName:(NSString *) archive
{
   NSParameterAssert( [runtime length]);
   NSParameterAssert( [archive length]);
   
   NSMapInsert( _classNameSubstitutions,
               [runtime UTF8String],
               [archive UTF8String]);
}


- (void) replaceObject:(id) original
            withObject:(id) replacement
{
   NSMapInsert( _objectSubstitutions,  original, replacement);
}

@end
