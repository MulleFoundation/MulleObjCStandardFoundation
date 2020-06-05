#import "NSArray+StringComponents.h"

#import "import-private.h"

#import <MulleObjCValueFoundation/_MulleObjCTaggedPointerChar5String.h>
#import <MulleObjCValueFoundation/_MulleObjCTaggedPointerChar7String.h>
#import <MulleObjCValueFoundation/_MulleObjCASCIIString.h>
#import <MulleObjCValueFoundation/_MulleObjCUTF16String.h>
#import <MulleObjCValueFoundation/_MulleObjCUTF32String.h>

#include <assert.h>


@implementation NSArray( StringComponents)

struct string_context
{
   Class       stringClass;
   id          sharingObject;
   NSUInteger  sepLen;
};


typedef NSString   *(*MakeStringFunction)( void *start,
                                           void **end,
                                           struct string_context *ctxt);


static NSString   *makeUTF8String( mulle_utf8_t *start,
                                   mulle_utf8_t *end,
                                   struct string_context *ctxt)
{
   NSUInteger   length;

   if( ctxt->sepLen == -1)
      _mulle_utf8_previous_utf32character( &end);
   else
      end -= ctxt->sepLen;

   assert( start <= end);
   length = end - start;
   if( ! length)
      return( @"");
   return( [[ctxt->stringClass alloc] mulleInitWithUTF8Characters:start
                                                           length:length]);
}


//
// src must be known to be ASCII, and contain no zeroes
//
static enum mulle_utf_charinfo    _mulle_ascii_quickinfo( char *src, size_t len)
{
   char   _c;
   char   *start;
   char   *sentinel;

   assert( len);

   if( len <= mulle_char7_get_maxlength())
      return( mulle_utf_is_char7);

   if( len > mulle_char5_get_maxlength())
      return( mulle_utf_is_not_char5_or_char7);

   start    = src;
   sentinel = &start[ len];
   for( ; src < sentinel; src++)
   {
      _c = *src;
      if( ! mulle_utf16_is_char5character( _c))
         return( mulle_utf_is_not_char5_or_char7);
   }
   return( mulle_utf_is_char5);
}


static NSString   *makeASCIIString( char *start,
                                    char *end,
                                    struct string_context *ctxt)
{
   NSUInteger   length;

   end -= ctxt->sepLen;
   assert( start <= end);
   length = end - start;
   if( ! length)
      return( @"");

#ifdef __MULLE_OBJC_TPS__
   switch( _mulle_ascii_quickinfo( start, length))
   {
   case mulle_utf_is_char7 :
      return( MulleObjCTaggedPointerChar7StringWithASCIICharacters( start,
                                                                    length));
   case mulle_utf_is_char5 :
      return( MulleObjCTaggedPointerChar5StringWithASCIICharacters( start,
                                                                    length));
   default :
      break;
   }
#endif
   if( ctxt->sharingObject)
      return( [_MulleObjCSharedASCIIString newWithASCIICharactersNoCopy:start
                                                                 length:length
                                                          sharingObject:ctxt->sharingObject]);
   return( [_MulleObjCGenericASCIIString newWithASCIICharacters:start
                                                         length:length]);
}


static NSString   *makeUTF16String( mulle_utf16_t *start,
                                    mulle_utf16_t *end,
                                    struct string_context *ctxt)
{
   NSUInteger   length;

   end -= ctxt->sepLen;
   assert( start <= end);
   length = end - start;
   if( ! length)
      return( @"");
   // try to benefit from TPS

#ifdef __MULLE_OBJC_TPS__
   switch( _mulle_utf16_charinfo( start, length))
   {
   case mulle_utf_is_char7 :
      return( MulleObjCTaggedPointerChar7StringWithUTF16Characters( start,
                                                                    length));
   case mulle_utf_is_char5 :
      return( MulleObjCTaggedPointerChar5StringWithUTF16Characters( start,
                                                                    length));
   default :
      break;
   }
#endif

   if( ctxt->sharingObject)
      return( [_MulleObjCSharedUTF16String newWithUTF16CharactersNoCopy:start
                                                                 length:length
                                                           sharingObject:ctxt->sharingObject]);
   return( [_MulleObjCGenericUTF16String newWithUTF16Characters:start
                                                         length:length]);
}


static NSString   *makeUTF32String( mulle_utf32_t *start,
                                    mulle_utf32_t *end,
                                    struct string_context *ctxt)
{
   NSUInteger   length;

   end -= ctxt->sepLen;
   assert( start <= end);
   length = end - start;
   if( ! length)
      return( @"");
   // try to benefit from TPS

#ifdef __MULLE_OBJC_TPS__
   switch( _mulle_utf32_charinfo( start, length))
   {
   case mulle_utf_is_char7 :
      return( MulleObjCTaggedPointerChar7StringWithCharacters( start,
                                                               length));
   case mulle_utf_is_char5 :
      return( MulleObjCTaggedPointerChar5StringWithCharacters( start,
                                                               length));
   default :
      break;
   }
#endif

   if( ctxt->sharingObject)
      return( [_MulleObjCSharedUTF32String newWithUTF32CharactersNoCopy:start
                                                                 length:length
                                                          sharingObject:ctxt->sharingObject]);
   return( [_MulleObjCGenericUTF32String newWithUTF32Characters:start
                                                         length:length]);
}



// We get:
//       pointers[0]
//      /
//     / / pointers[1]
//    v v
//  a,b,c
//  ^
//  \---- buf.bytes, buf.length = 5
//
// sepLen = is delimiter size, or -1 for UTF8 meaning one UTF character
//
+ (instancetype) mulleArrayFromData:(struct mulle_data) buf
               createStringFunction:(MakeStringFunction) makeString
                       pointerQueue:(struct mulle__pointerqueue *) pointers
                             stride:(NSUInteger) sepLen
                      sharingObject:(id) object
{
   NSArray                                *array;
   NSString                               **strings;
   NSString                               **dst;
   NSUInteger                             i;
   void                                   *p;
   void                                   *q;
   NSUInteger                             len;
   NSUInteger                             nStrings;
   struct mulle_allocator                 *allocator;
   struct mulle__pointerqueueenumerator   rover;
   struct string_context                  ctxt;

   assert( buf.length >= 1);

   allocator = MulleObjCClassGetAllocator( self);
   nStrings  = _mulle__pointerqueue_get_count( pointers) + 1;
   strings   = mulle_allocator_malloc( allocator, nStrings * sizeof( NSString *));
   dst       = strings;

   ctxt.stringClass   = [NSString class];
   ctxt.sharingObject = object;
   ctxt.sepLen        = sepLen;

   /* create strings for pointers make a little string of it and place it in
      strings array
     */
   p     = buf.bytes;
   rover = mulle__pointerqueue_enumerate( pointers);
   while( (q = _mulle__pointerqueueenumerator_next( &rover)))
   {
      assert( (char *) q >= (char *) p);
      *dst++ = (*makeString)( p, q, &ctxt);
      p      = q;
   }
   mulle__pointerqueueenumerator_done( &rover);

   q      = &((char *) buf.bytes)[ buf.length];
   // can happen if there was not trailing delimiter
   ctxt.sepLen = 0;
   *dst++ = (*makeString)( p, q, &ctxt);

   assert( dst - strings == nStrings);
   array = [[[self alloc] mulleInitWithRetainedObjectStorage:strings
                                                       count:dst - strings
                                                        size:nStrings] autorelease];
   return( array);
}


+ (instancetype) _mulleArrayFromASCIIData:(struct mulle_utf8_data) buf
                             pointerQueue:(struct mulle__pointerqueue *) pointers
                                   stride:(NSUInteger) stride
                             sharingObject:(id) object
{
   struct mulle_data   data;

   return( [self mulleArrayFromData:mulle_data_make( buf.characters, buf.length)
               createStringFunction:(MakeStringFunction) makeASCIIString
                       pointerQueue:pointers
                             stride:stride
                      sharingObject:object]);
}


+ (instancetype) mulleArrayFromUTF8Data:(struct mulle_utf8_data) buf
                           pointerQueue:(struct mulle__pointerqueue *) pointers
                                 stride:(NSUInteger) stride
                          sharingObject:(id) object
{
   return( [self mulleArrayFromData:mulle_data_make( buf.characters, buf.length)
               createStringFunction:(MakeStringFunction) makeUTF8String
                       pointerQueue:pointers
                             stride:stride
                      sharingObject:object]);
}



// just the same for utf16, but must be utf_15 bit clean
+ (instancetype) _mulleArrayFromUTF16Data:(struct mulle_utf16_data) buf
                             pointerQueue:(struct mulle__pointerqueue *) pointers
                                   stride:(NSUInteger) stride
                           sharingObject:(id) object
{
   return( [self mulleArrayFromData:mulle_data_make( buf.characters,
                                                     buf.length * sizeof( mulle_utf16_t))
               createStringFunction:(MakeStringFunction) makeUTF16String
                       pointerQueue:pointers
                             stride:stride
                      sharingObject:object]);
}


+ (instancetype) mulleArrayFromUTF32Data:(struct mulle_utf32_data) buf
                            pointerQueue:(struct mulle__pointerqueue *) pointers
                                  stride:(NSUInteger) stride
                           sharingObject:(id) object
{
   return( [self mulleArrayFromData:mulle_data_make( buf.characters,
                                                     buf.length * sizeof( mulle_utf32_t))
               createStringFunction:(MakeStringFunction) makeUTF32String
                       pointerQueue:pointers
                             stride:stride
                      sharingObject:object]);
}

@end
