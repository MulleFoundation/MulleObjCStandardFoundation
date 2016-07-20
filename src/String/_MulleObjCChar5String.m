//
//  _MulleObjCChar5String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 10.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCChar5String.h"

#import "MulleObjCFoundationData.h"


@implementation _MulleObjCChar5String

+ (void) load
{
   MulleObjCTaggedPointerRegisterClassAtIndex( self, 1);
}


NSString  *MulleObjCChar5StringWithChar5Characters( char *s, NSUInteger length)
{
   uintptr_t   value;
   
   assert( [_MulleObjCChar5String isTaggedPointerEnabled]);
   
   value = mulle_char5_encode_ascii( s, (size_t) length);
   return( _MulleObjCChar5StringFromValue( value));
}


- (NSUInteger) length
{
   uintptr_t    value;
   NSUInteger   length;
   
   value  = _MulleObjCChar5ValueFromString( self);
   length = (NSUInteger) mulle_char5_strlen_uintptr( value);
   return( length);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   uintptr_t    value;
   NSUInteger   length;
   
   value  = _MulleObjCChar5ValueFromString( self);
   length = (NSUInteger) mulle_char5_strlen_uintptr( value);

   if( index >= length)
      MulleObjCThrowInvalidIndexException( index);
   
   return( (unichar) mulle_char5_at_uintptr( value, (unsigned int) index));
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
   
   value = _MulleObjCChar5ValueFromString( self);
   if( range.location)
   {
      mulle_utf8_t   buf[ len];
      
      mulle_char5_decode_ascii( value, (char *) buf, len);
      memcpy( dst, &buf[ range.location], range.length);
      return;
   }

   mulle_char5_decode_ascii( value, (char *) dst, range.length);
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
               [self length],
               buf,
               range);
}


- (void) _getUTF8Characters:(mulle_utf8_t *) buf
                  maxLength:(NSUInteger) maxLength
{
   NSUInteger   length;
   
   length = [self length];
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
   
   len = [self length];
   {
      mulle_utf8_t   buf[ len];

      grab_utf8( self,
                 len,
                 buf,
                 NSMakeRange( 0, len));
   
      range = MulleObjCHashRange( len);
      return( MulleObjCStringHash( &buf[ range.location], range.length));
   }
}


- (mulle_utf8_t *) UTF8String
{
   NSUInteger      len;
   NSMutableData   *data;
   mulle_utf8_t    *s;
   
   len  = [self length];
   data = [NSMutableData dataWithLength:len + 1];
   s    = [data mutableBytes];
   
   grab_utf8( self,
              len,
              s,
              NSMakeRange( 0, len));
   s[ len] = 0;
   return( s);
}


- (NSString *) substringWithRange:(NSRange) range
{
   NSUInteger   length;
   
   length = [self length];
   
   // check both because of overflow range.length == (unsigned) -1 f.e.
   if( range.length + range.location > length || range.length > length)
      MulleObjCThrowInvalidRangeException( range);
   
   {
      mulle_utf8_t   buf[ range.length];
         
      grab_utf8( self,
                 length,
                 buf,
                 range);
      
      return( MulleObjCChar5StringWithChar5Characters( (char *) buf, range.length));
   }
}

@end
