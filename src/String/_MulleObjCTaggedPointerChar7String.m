//
//  _MulleObjCTaggedPointerASCIIString.m
//  MulleObjCFoundation
//
//  Created by Nat! on 24.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCTaggedPointerChar7String.h"

#import "MulleObjCFoundationData.h"


@implementation _MulleObjCTaggedPointerChar7String

+ (void) load
{
   if( MulleObjCTaggedPointerRegisterClassAtIndex( self, 0x3))
   {
      perror( "Need tag pointer aware runtime for _MulleObjCTaggedPointerChar7String with empty slot #3\n");
      abort();
   }
}


NSString  *MulleObjCTaggedPointerChar7StringWithASCIICharacters( char *s, NSUInteger length)
{
   uintptr_t   value;
   
   assert( [_MulleObjCTaggedPointerChar7String isTaggedPointerEnabled]);
   
   value = mulle_char7_encode( s, (size_t) length);
   return( _MulleObjCTaggedPointerChar7StringFromValue( value));
}


static inline NSUInteger  MulleObjCTaggedPointerChar7StringGetLength( _MulleObjCTaggedPointerChar7String *self)
{
   uintptr_t    value;
   NSUInteger   length;
   
   value  = _MulleObjCTaggedPointerChar7ValueFromString( self);
   length = (NSUInteger) mulle_char7_strlen( value);
   return( length);
}




- (NSUInteger) length
{
   return( MulleObjCTaggedPointerChar7StringGetLength( self));
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   uintptr_t    value;
   NSUInteger   length;
   
   value  = _MulleObjCTaggedPointerChar7ValueFromString( self);
   length = (NSUInteger) mulle_char7_strlen( value);

   if( index >= length)
      MulleObjCThrowInvalidIndexException( index);
   
   return( (unichar) mulle_char7_get( value, (unsigned int) index));
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
   
   value = _MulleObjCTaggedPointerChar7ValueFromString( self);
   if( range.location)
   {
      mulle_utf8_t   buf[ len];
      
      mulle_char7_decode( value, (char *) buf, len);
      memcpy( dst, &buf[ range.location], range.length);
      return;
   }

   mulle_char7_decode( value, (char *) dst, range.length);
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
               MulleObjCTaggedPointerChar7StringGetLength( self),
               buf,
               range);
}


- (void) _getUTF8Characters:(mulle_utf8_t *) buf
                  maxLength:(NSUInteger) maxLength
{
   NSUInteger   length;
   
   length = MulleObjCTaggedPointerChar7StringGetLength( self);
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
   
   len = MulleObjCTaggedPointerChar7StringGetLength( self);
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
   return( MulleObjCTaggedPointerChar7StringGetLength( self));
}


- (char *) UTF8String
{
   NSUInteger      len;
   NSMutableData   *data;
   mulle_utf8_t    *s;
   
   len  = MulleObjCTaggedPointerChar7StringGetLength( self);
   data = [NSMutableData dataWithLength:len + 1];
   s    = [data mutableBytes];
   
   grab_utf8( self,
              len,
              s,
              NSMakeRange( 0, len));
   s[ len] = 0;
   return( (char *) s);
}


// can be done easier just with shifting and masking!
- (NSString *) substringWithRange:(NSRange) range
{
   NSUInteger   length;
   NSUInteger   value;
   
   length = MulleObjCTaggedPointerChar7StringGetLength( self);
   
   // check both because of overflow range.length == (unsigned) -1 f.e.
   if( range.length + range.location > length || range.length > length)
      MulleObjCThrowInvalidRangeException( range);
   
   value = _MulleObjCTaggedPointerChar7ValueFromString( self);
   value = mulle_char7_substring( value,
                                  (unsigned int) range.location,
                                  (unsigned int) range.length);
   return( _MulleObjCTaggedPointerChar7StringFromValue( value));
}

@end
