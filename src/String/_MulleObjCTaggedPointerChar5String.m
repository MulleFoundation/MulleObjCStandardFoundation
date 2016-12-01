//
//  _MulleObjCChar5String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 10.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCTaggedPointerChar5String.h"

#import "MulleObjCFoundationData.h"


@implementation _MulleObjCTaggedPointerChar5String

+ (void) load
{
   if( MulleObjCTaggedPointerRegisterClassAtIndex( self, 0x1))
   {
      perror( "Need tag pointer aware runtime for _MulleObjCTaggedPointerChar5String with empty slot #1\n");
      abort();
   }
}


NSString  *MulleObjCTaggedPointerChar5StringWithASCIICharacters( char *s, NSUInteger length)
{
   uintptr_t   value;
   
   assert( [_MulleObjCTaggedPointerChar5String isTaggedPointerEnabled]);
   
   value = mulle_char5_encode( s, (size_t) length);
   return( _MulleObjCTaggedPointerChar5StringFromValue( value));
}


static inline NSUInteger  MulleObjCTaggedPointerChar5StringGetLength( _MulleObjCTaggedPointerChar5String *self)
{
   uintptr_t    value;
   NSUInteger   length;
   
   value  = _MulleObjCTaggedPointerChar5ValueFromString( self);
   length = (NSUInteger) mulle_char5_strlen( value);
   return( length);
}


- (NSUInteger) length
{
   return( MulleObjCTaggedPointerChar5StringGetLength( self));
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   uintptr_t    value;
   NSUInteger   length;
   
   value  = _MulleObjCTaggedPointerChar5ValueFromString( self);
   length = (NSUInteger) mulle_char5_strlen( value);

   if( index >= length)
      MulleObjCThrowInvalidIndexException( index);
   
   return( (unichar) mulle_char5_get( value, (unsigned int) index));
}


struct buffer
{
   char     *s;
   size_t   n;
};


//
// len will be #bytes
//
static void  buffer_add( struct buffer *p, void *bytes, size_t len)
{
   memcpy( &p->s[ p->n], bytes, len);
   p->n += len;
}


static void   grab_utf8( id self,
                         NSUInteger len,
                         mulle_utf8_t *dst,
                         NSRange range)
{
   uintptr_t   value;
   
   // check both because of overflow range.length == (unsigned) -1 f.e.
   if( range.length + range.location > len || range.length > len)
      MulleObjCThrowInvalidRangeException( range);
   
   value = _MulleObjCTaggedPointerChar5ValueFromString( self);
   if( range.location)
   {
      mulle_utf8_t   buf[ len];
      
      mulle_char5_decode( value, (char *) buf, len);
      memcpy( dst, &buf[ range.location], range.length);
      return;
   }

   mulle_char5_decode( value, (char *) dst, range.length);
}


static void   grab_utf32( id self,
                          NSUInteger len,
                          mulle_utf32_t *dst,
                          NSRange range)
{
   mulle_utf8_t    buf[ len];
   struct buffer   ctxt;

   grab_utf8( self, len, buf, range);
   
   ctxt.s = (char *) dst;
   ctxt.n = 0;
   
   mulle_utf8_convert_to_utf32_bytebuffer( buf, range.length, &ctxt, (void (*)()) buffer_add);
}


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   grab_utf32( self,
               MulleObjCTaggedPointerChar5StringGetLength( self),
               buf,
               range);
}


- (void) _getUTF8Characters:(mulle_utf8_t *) buf
                  maxLength:(NSUInteger) maxLength
{
   NSUInteger   length;
   
   length = MulleObjCTaggedPointerChar5StringGetLength( self);
   if( length > maxLength)
      length = maxLength;
   grab_utf8( self,
              length,
              buf,
              NSMakeRange( 0, length));
}


- (NSUInteger) hash
{
   NSRange       range;
   NSUInteger    len;
   
   len = MulleObjCTaggedPointerChar5StringGetLength( self);
   {
      mulle_utf8_t   buf[ len];

      grab_utf8( self,
                 len,
                 buf,
                 NSMakeRange( 0, len));
   
      range = MulleObjCHashRange( len);
      return( MulleObjCStringHash( (char *) &buf[ range.location], range.length));
   }
}


- (NSUInteger) _UTF8StringLength
{
   return( MulleObjCTaggedPointerChar5StringGetLength( self));
}


- (char *) UTF8String
{
   NSUInteger      len;
   NSMutableData   *data;
   mulle_utf8_t    *s;
   
   len  = MulleObjCTaggedPointerChar5StringGetLength( self);
   data = [NSMutableData dataWithLength:len + 1];
   s    = [data mutableBytes];
   
   grab_utf8( self,
              len,
              s,
              NSMakeRange( 0, len));
   s[ len] = 0;
   return( (char *) s);
}


- (NSString *) substringWithRange:(NSRange) range
{
   NSUInteger   length;
   uintptr_t    value;
   
   length = MulleObjCTaggedPointerChar5StringGetLength( self);
   
   // check both because of overflow range.length == (unsigned) -1 f.e.
   if( range.length + range.location > length || range.length > length)
      MulleObjCThrowInvalidRangeException( range);
   
   value = _MulleObjCTaggedPointerChar5ValueFromString( self);
   value = mulle_char5_substring( value,
                                 (unsigned int) range.location,
                                 (unsigned int) range.length);
   return( _MulleObjCTaggedPointerChar5StringFromValue( value));
}

@end
