//
//  NSString+Components.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2006 Nat! - Mulle kybernetiK.
//  Copyright (c) 2006 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSString+Components.h"

// other files in this library
#import "NSCharacterSet.h"
#import "NSString+Search.h"
#import "NSArray+StringComponents.h"

#import <MulleObjCValueFoundation/_MulleObjCValueTaggedPointer.h>
#import <MulleObjCValueFoundation/_MulleObjCTaggedPointerChar7String.h>
#import <MulleObjCValueFoundation/_MulleObjCTaggedPointerChar5String.h>
#import <MulleObjCValueFoundation/_MulleObjCASCIIString.h>
#import <MulleObjCValueFoundation/_MulleObjCUTF16String.h>
#import <MulleObjCValueFoundation/_MulleObjCUTF32String.h>


// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardContainerFoundation.h"
#import "MulleObjCStandardExceptionFoundation.h"

// std-c and other dependencies
#import "import-private.h"


static unichar   ASCIINextCharacter( void **p)
{
   char      *s;
   unichar   c;

   s  = *p;
   c  = *s++;
   *p = s;
   return( c);
}


static unichar   UTF8NextCharacter( void **p)
{
   return( mulle_utf8_next_utf32character( (char **) p));
}



static unichar   UTF16NextCharacter( void **p)
{
   mulle_utf16_t  *s;
   unichar        c;

   s  = *p;
   c  = *s++;
   *p = s;
   return( c);
}


static unichar   UTF32NextCharacter( void **p)
{
   mulle_utf32_t  *s;
   unichar        c;

   s  = *p;
   c  = *s++;
   *p = s;
   return( c);
}


static void
   _mulleDataSeparateComponentsByCharacter( struct mulle_data  data,
                                            unichar (*nextCharacter)( void **),
                                            unichar sepChar,
                                            struct mulle__pointerqueue *pointers)
{
   unichar   c;
   void      *p;
   void      *sentinel;

   sentinel = &((char *) data.bytes)[ data.length];
   for( p = data.bytes; p < sentinel;)
   {
      c = (*nextCharacter)( &p);
      if( c != sepChar)
         continue;

      _mulle__pointerqueue_push( pointers, p, NULL);
   }
}



static NSUInteger
   _mulleDataSeparateComponentsByUTF32Data( struct mulle_data  data,
                                            unichar (*nextCharacter)( void **),
                                            struct mulle_utf32data sepData,
                                            struct mulle__pointerqueue *pointers)
{
   NSUInteger   remain;
   unichar      *q;
   unichar      c;
   unichar      d;
   void         *memo;
   void         *p;
   void         *sentinel;

   if( ! sepData.length)
      return( 0);

   sentinel = &((char *) data.bytes)[ data.length];
   // Degenerate case @"." -> ( @"", @"")

   remain = sepData.length;
   memo   = data.bytes;      // unused, but compilers...
   q      = sepData.characters;

   for( p = data.bytes; p < sentinel;)
   {
      c = (*nextCharacter)( &p);
      d = *q++;

      // dial back to first char after first char match, if fails
      if( remain == sepData.length)
         memo = p;

      if( c == d)
      {
         if( --remain)
            continue;

         // matched whole string
         // memorize that
         _mulle__pointerqueue_push( pointers, p, NULL);
      }
      else
         p = memo;

      remain = sepData.length;
      q      = sepData.characters;
   }

   return( sepData.length);
}


static NSUInteger
   _mulleDataSeparateComponentsByString( struct mulle_data  data,
                                         unichar (*nextCharacter)( void **),
                                         NSString *separator,
                                         struct mulle__pointerqueue *pointers)
{
   NSUInteger               rval;
   struct mulle_utf32data   sepData;

   sepData.length = [separator length];
   if( ! sepData.length)
      return( 0);

   if( sepData.length == 1)
   {
      _mulleDataSeparateComponentsByCharacter( data,
                                               nextCharacter,
                                               [separator characterAtIndex:0],
                                               pointers);
      rval = 1;
   }
   else
   {
      mulle_alloca_do( characters, unichar, sepData.length)
      {
         sepData.characters = characters;
         [separator getCharacters:sepData.characters
                            range:NSRangeMake( 0, sepData.length)];

         rval =_mulleDataSeparateComponentsByUTF32Data( data,
                                                        nextCharacter,
                                                        sepData,
                                                        pointers);
      }
   }

   // hackish
   if( nextCharacter == UTF8NextCharacter)
      rval = [separator mulleUTF8StringLength];
   return( rval);
}



static void
   _mulleDataSeparateComponentsByCharacterSet( struct mulle_data  data,
                                               unichar (*nextCharacter)( void **),
                                               NSCharacterSet *separators,
                                               struct mulle__pointerqueue *pointers)
{
   IMP       isMember;
   unichar   c;
   void      *p;
   void      *sentinel;

   isMember = [separators methodForSelector:@selector( characterIsMember:)];
   sentinel = &((char *) data.bytes)[ data.length];
   p        = data.bytes;

   do
   {
      c = (*nextCharacter)( &p);
      if( (*isMember)( separators, @selector( characterIsMember:), (id) (uintptr_t) c))
         _mulle__pointerqueue_push( pointers, p, NULL);
   }
   while( p < sentinel);
}


/*
 * we have three major character representations
 * ASCII, UTF16 as UTF15 bit and UTF32 all have in common, that none of them
 * contain composed characters. Effectively every string contains UTF32
 * characters in various bit widths.
 *
 * Since you can substring UTF32 and the representation will not be changed,
 * UTF32 can very well contain only ASCII values though.
 * The separator string is transformed into UTF32 for comparison.
 * no problems there.
 *
 * TPS is converted to ASCII. We then "just" have to write categories for
 * _MulleObjCASCIIString, _MulleObjCUTF16String, _MulleObjCUTF32String.
 * NSMutableString and and other classes use UTF32 by default.
 *
 */

@implementation _MulleObjCTaggedPointerChar7String( Components)

static id
   separateASCIICharacterDataByString( struct mulle_asciidata data,
                                       NSString *separator,
                                       Class arrayClass)
{
   struct mulle__pointerqueue   pointers;
   NSArray                      *array;
   NSUInteger                   sepLen;

   _mulle__pointerqueue_init( &pointers, 0x1000, 0);
   sepLen = _mulleDataSeparateComponentsByString( mulle_data_make( data.characters,
                                                                   data.length),
                                                  ASCIINextCharacter,
                                                  separator,
                                                  &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [arrayClass _mulleArrayFromASCIIData:data
                                      pointerQueue:&pointers
                                            stride:sepLen
                                     sharingObject:nil];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array);
}



static id
   separateASCIICharacterDataByCharacterSet( struct mulle_asciidata data,
                                             NSCharacterSet *separators,
                                             Class arrayClass)
{
   struct mulle__pointerqueue   pointers;
   NSArray                      *array;

   _mulle__pointerqueue_init( &pointers, 0x1000, 0x0);
   _mulleDataSeparateComponentsByCharacterSet( mulle_data_make( data.characters,
                                                                data.length),
                                               ASCIINextCharacter,
                                               separators,
                                               &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [arrayClass _mulleArrayFromASCIIData:data
                                      pointerQueue:&pointers
                                            stride:1
                                     sharingObject:nil];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array);
}



- (id) _mulleComponentsSeparatedByString:(NSString *) separator
                              arrayClass:(Class) arrayClass
{
   char                     tmp[ mulle_char7_maxlength64];  // known ascii max 8
   struct mulle_asciidata   data;

   data.characters = tmp;
   data.length     = [self mulleGetASCIICharacters:data.characters
                                         maxLength:mulle_char7_maxlength64];

   return( separateASCIICharacterDataByString( data, separator, arrayClass));
}


- (id) _mulleComponentsSeparatedByCharacterSet:(NSCharacterSet *) separators
                                    arrayClass:(Class) arrayClass
{
   char                      tmp[ mulle_char7_maxlength64];  // known ascii max 8
   struct mulle_asciidata   data;

   data.characters = tmp;
   data.length     = [self mulleGetASCIICharacters:data.characters
                                         maxLength:mulle_char7_maxlength64];

   return( separateASCIICharacterDataByCharacterSet( data, separators, arrayClass));
}

@end


@implementation _MulleObjCTaggedPointerChar5String( Components)

- (id) _mulleComponentsSeparatedByString:(NSString *) separator
                              arrayClass:(Class) arrayClass
{
   char                     tmp[ mulle_char5_maxlength64];  // known ascii max 8
   struct mulle_asciidata   data;

   data.characters = tmp;
   data.length     = [self mulleGetASCIICharacters:data.characters
                                         maxLength:mulle_char5_maxlength64];
   return( separateASCIICharacterDataByString( data, separator, arrayClass));
}


- (id) _mulleComponentsSeparatedByCharacterSet:(NSCharacterSet *) separators
                                    arrayClass:(Class) arrayClass
{
   char                      tmp[ mulle_char5_maxlength64];  // known ascii max 8
   struct mulle_asciidata   data;

   data.characters = tmp;
   data.length     = [self mulleGetASCIICharacters:data.characters
                                         maxLength:mulle_char5_maxlength64];

   return( separateASCIICharacterDataByCharacterSet( data, separators, arrayClass));
}

@end


//
// TODO: could exploit knowledge of the "constness" of the data in these
//       classes to use "substrings" instead of generating copying string
//       data
//

@implementation _MulleObjCASCIIString( Components)

- (id) _mulleComponentsSeparatedByString:(NSString *) separator
                              arrayClass:(Class) arrayClass
{
   struct mulle_asciidata   data;
   BOOL                      flag;

   flag = [self mulleFastGetASCIIData:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   return( separateASCIICharacterDataByString( data, separator, arrayClass));
}


- (id) _mulleComponentsSeparatedByCharacterSet:(NSCharacterSet *) separators
                                    arrayClass:(Class) arrayClass
{
   struct mulle_asciidata   data;
   BOOL                      flag;

   flag = [self mulleFastGetASCIIData:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   return( separateASCIICharacterDataByCharacterSet( data, separators, arrayClass));
}

@end


@implementation _MulleObjCUTF16String( Components)

- (id) _mulleComponentsSeparatedByString:(NSString *) separator
                              arrayClass:(Class) arrayClass
{
   NSArray                      *array;
   NSUInteger                   sepLen;
   struct mulle__pointerqueue   pointers;
   struct mulle_utf16data       data;
   BOOL                         flag;

   flag = [self mulleFastGetUTF16Data:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   _mulle__pointerqueue_init( &pointers, 0x1000, 0x0);
   sepLen = _mulleDataSeparateComponentsByString( mulle_data_make( data.characters,
                                                                   data.length * sizeof( mulle_utf16_t)),
                                                  UTF16NextCharacter,
                                                  separator,
                                                  &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [arrayClass _mulleArrayFromUTF16Data:data
                                      pointerQueue:&pointers
                                            stride:sepLen
                                     sharingObject:self];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array);
}


- (id) _mulleComponentsSeparatedByCharacterSet:(NSCharacterSet *) separators
                                    arrayClass:(Class) arrayClass
{
   NSArray                      *array;
   struct mulle__pointerqueue   pointers;
   struct mulle_utf16data       data;
   BOOL                         flag;

   flag = [self mulleFastGetUTF16Data:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   _mulle__pointerqueue_init( &pointers, 0x1000, 0x0);
   _mulleDataSeparateComponentsByCharacterSet( mulle_data_make( data.characters,
                                                                data.length * sizeof( mulle_utf16_t)),
                                               UTF16NextCharacter,
                                               separators,
                                               &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [arrayClass _mulleArrayFromUTF16Data:data
                                      pointerQueue:&pointers
                                            stride:1
                                     sharingObject:self];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array);
}

@end


@implementation _MulleObjCUTF32String( Components)

- (id) _mulleComponentsSeparatedByString:(NSString *) separator
                              arrayClass:(Class) arrayClass
{
   NSArray                      *array;
   NSUInteger                   sepLen;
   struct mulle__pointerqueue   pointers;
   struct mulle_utf32data       data;
   BOOL                         flag;

   flag = [self mulleFastGetUTF32Data:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   _mulle__pointerqueue_init( &pointers, 0x1000, 0x0);
   sepLen = _mulleDataSeparateComponentsByString( mulle_data_make( data.characters,
                                                                   data.length * sizeof( mulle_utf32_t)),
                                                  UTF32NextCharacter,
                                                  separator,
                                                  &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [arrayClass mulleArrayFromUTF32Data:data
                                     pointerQueue:&pointers
                                           stride:sepLen
                                    sharingObject:self];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array);
}


- (id) _mulleComponentsSeparatedByCharacterSet:(NSCharacterSet *) separators
                                    arrayClass:(Class) arrayClass
{
   NSArray                      *array;
   struct mulle__pointerqueue   pointers;
   struct mulle_utf32data       data;
   BOOL                         flag;

   flag = [self mulleFastGetUTF32Data:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   _mulle__pointerqueue_init( &pointers, 0x1000, 0x0);
   _mulleDataSeparateComponentsByCharacterSet( mulle_data_make( data.characters,
                                                                data.length * sizeof( mulle_utf32_t)),
                                               UTF32NextCharacter,
                                               separators,
                                               &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [arrayClass mulleArrayFromUTF32Data:data
                                     pointerQueue:&pointers
                                           stride:1
                                    sharingObject:self];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array);
}

@end



@implementation NSString ( Components)

//
// fall back implementation uses "mixed" UTF8 for separator and contents
// Though really only used for NSMutableString
//
- (id) _mulleComponentsSeparatedByString:(NSString *) separator
                              arrayClass:(Class) arrayClass
{
   NSArray                      *array;
   NSUInteger                   sepLen;
   struct mulle__pointerqueue   pointers;
   struct mulle_utf8data        data;
   char                         tmp[ 64];

   data = MulleStringUTF8Data( self,
                                  mulle_utf8data_make( tmp, sizeof( tmp)));

   _mulle__pointerqueue_init( &pointers, 0x1000, 0x0);
   sepLen = _mulleDataSeparateComponentsByString( mulle_data_make( data.characters,
                                                                   data.length),
                                                  UTF8NextCharacter,
                                                  separator,
                                                  &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [arrayClass mulleArrayFromUTF8Data:data
                                    pointerQueue:&pointers
                                          stride:sepLen
                                   sharingObject:nil];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array);
}


/*
 * NSString separator
 */

NSArray  *MulleObjCComponentsSeparatedByString( NSString *self,
                                                NSString *separator)
{
   return( [self _mulleComponentsSeparatedByString:separator
                                        arrayClass:[NSArray class]]);
}


NSMutableArray  *MulleObjCMutableComponentsSeparatedByString( NSString *self,
                                                              NSString *separator)
{
   return( [self _mulleComponentsSeparatedByString:separator
                                        arrayClass:[NSMutableArray class]]);
}


- (NSArray *) _componentsSeparatedByString:(NSString *) separator
{
   return( [self _mulleComponentsSeparatedByString:separator
                                        arrayClass:[NSArray class]]);
}


- (NSArray *) componentsSeparatedByString:(NSString *) separator
{
   NSArray   *components;

   if( ! separator)
      MulleObjCThrowInvalidArgumentException( @"separator can't be nil");

   components = MulleObjCComponentsSeparatedByString( self, separator);
   if( ! components)
      components = [NSArray arrayWithObject:self];
   return( components);
}


- (NSMutableArray *) mulleMutableComponentsSeparatedByString:(NSString *) separator
{
   NSMutableArray   *components;

   if( ! separator)
      MulleObjCThrowInvalidArgumentException( @"separator can't be nil");

   components = MulleObjCMutableComponentsSeparatedByString( self, separator);
   if( ! components)
      components = [NSMutableArray arrayWithObject:self];
   return( components);
}


/*
 * NSCharacterSet separator
 */
//
// fall back implementation uses "mixed" UTF8 for separator and contents
//

- (id) _mulleComponentsSeparatedByCharacterSet:(NSCharacterSet *)separators
                                    arrayClass:(Class) arrayClass
{
   struct mulle_utf8data        data;
   NSArray                      *array;
   struct mulle__pointerqueue   pointers;
   char                         tmp[ 64];

   data = MulleStringUTF8Data( self, mulle_utf8data_make( tmp,
                                                              sizeof( tmp)));
   _mulle__pointerqueue_init( &pointers, 0x1000, 0x0);
   _mulleDataSeparateComponentsByCharacterSet( mulle_data_make( data.characters,
                                                                data.length),
                                               UTF8NextCharacter,
                                               separators,
                                               &pointers);
   array = nil;
   if( _mulle__pointerqueue_get_count( &pointers))
      array = [arrayClass mulleArrayFromUTF8Data:data
                                    pointerQueue:&pointers
                                          stride:(NSUInteger) -1
                                    sharingObject:nil];
   _mulle__pointerqueue_done( &pointers, NULL);

   return( array);
}


NSArray  *MulleObjCComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators)
{
   return( [self _mulleComponentsSeparatedByCharacterSet:separators
                                              arrayClass:[NSArray class]]);
}


NSMutableArray  *MulleObjCMutableComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators)
{
   return( [self _mulleComponentsSeparatedByCharacterSet:separators
                                              arrayClass:[NSMutableArray class]]);
}


// will return nil, if not separated! (to be compatible)
- (NSArray *) _componentsSeparatedByCharacterSet:(NSCharacterSet *) separators
{
   return( MulleObjCComponentsSeparatedByCharacterSet( self, separators));
}


- (NSArray *) componentsSeparatedByCharactersInSet:(NSCharacterSet *) separators
{
   NSArray   *array;

   array = MulleObjCComponentsSeparatedByCharacterSet( self, separators);
   if( ! array)
      array = [NSArray arrayWithObject:self];
   return( array);
}

- (NSMutableArray *) mulleMutableComponentsSeparatedByCharactersInSet:(NSCharacterSet *) separators
{
   NSMutableArray   *array;

   array = MulleObjCMutableComponentsSeparatedByCharacterSet( self, separators);
   if( ! array)
      array = [NSMutableArray arrayWithObject:self];
   return( array);
}


//static NSMutableArray  *arrayWithComponents( NSArray *components, NSRange range, BOOL includeFirst)
//{
//   NSMutableArray   *array;
//
//   array = [NSMutableArray array];
//   if( includeFirst && range.location != 0)
//      [array addObject:[components objectAtIndex:0]];
//   [array addObjectsFromArray:[components subarrayWithRange:range]];
//   return( array);
//}


- (NSString *) mulleStringBySimplifyingComponentsSeparatedByString:(NSString *) separator
                                                      simplifyDots:(BOOL) simplifyDots
{
   enum pathtype
   {
      isString,
      isSeparator,
      isDot,
      isDotDot
   };
   NSArray           *components;
   NSUInteger        i, j, n;
   NSUInteger        len;
   SEL               selAppend;
   IMP               impAppend;
   NSMutableString   *buffer;
   NSString          *s;
   NSString          *sep;

   components = [self _componentsSeparatedByString:separator];
   n          = [components count];
   if( n <= 1)
      return( self);

   buffer = nil; // can't happen
   mulle_alloca_do( tmpComponents, id, n)
   {
      mulle_alloca_do( tmpTypes, char, n)
      {
         j = 0;
         i = -1;
         for( s in components)
         {
            ++i;
            len = [s length];

            // get rid of "/" except on start and end
            if( ! len)
            {
               // skip unless first or last and prev not also "/"
               if( ! j || (i == n - 1 && tmpTypes[ j - 1] != isSeparator))
               {
                  tmpComponents[ j] = s;
                  tmpTypes[ j]      = isSeparator;
                  ++j;
               }
               continue;
            }

            if( simplifyDots)
            {
               // get rid of "." except on start
               if( len == 1 && [@"." isEqualToString:s])
               {
                  if( ! j)
                  {
                     tmpComponents[ j] = s;
                     tmpTypes[ j]      = isDot;
                     ++j;
                  }
                  continue;
               }

               // get rid of ".." and preceeding if possible
               if( len == 2 && [@".." isEqualToString:s])
               {
                  // simplify a/../b to a/b, also /../a to /a
                  //
                  if( j)
                  {
                     --j;
                     switch( tmpTypes[ j])
                     {
                       case isSeparator :
                        assert( j == 0);
                        ++j;  // dial back
                        continue;

                     case isString:
                        // simplify a/.. to .
                        if( j == 0)
                        {
                           tmpComponents[ j] = @".";
                           tmpTypes[ j]      = isDot;
                           ++j;
                           continue;
                        }
                        continue;

                     case isDotDot:
                        ++j;
                        break;

                     case isDot:
                        break;
                     }
                  }

                  tmpComponents[ j] = s;
                  tmpTypes[ j]      = isDotDot;
                  ++j;
                  continue;
               }
            }

            tmpComponents[ j] = s;
            tmpTypes[ j]      = isString;
            ++j;
         }

         if( j == n)
            return( self);

         assert( j);
         if( j == 1)
         {
            if( tmpTypes[ 0] == isSeparator)
               return( separator);
            return( tmpComponents[ 0]);
         }
      }

      buffer    = [NSMutableString string];
      selAppend = @selector( appendString:);
      impAppend = [buffer methodForSelector:selAppend];

      sep = nil;
      for( i = 0; i < j; i++)
      {
         (*impAppend)( buffer, selAppend, sep);
         (*impAppend)( buffer, selAppend, tmpComponents[ i]);
         sep = separator;
      }
   }
   return( buffer);
}



- (NSString *) mulleStringByAppendingComponent:(NSString *) other
                             separatedByString:(NSString *) separator
{
   BOOL        hasSuffix;
   BOOL        otherHasPrefix;
   BOOL        otherHasSuffix;
   NSUInteger  len;
   NSUInteger  other_len;

   len = [self length];
   if( ! len)  // "" + "b" -> "b"
      return( other);

   other_len      = [other length];
   otherHasSuffix = [other hasSuffix:separator];
   if( otherHasSuffix)
   {
      --other_len;
      other = [other substringWithRange:NSRangeMake( 0, other_len)];
   }

   hasSuffix = [self hasSuffix:separator];
   if( ! hasSuffix && ! other_len)
      return( self);

   otherHasPrefix = [other hasPrefix:separator];


   //    S  P
   //  ---+----
   //    0  0     add '/'
   //    0  1     just concat
   //    1  0     just concat
   //    1  1     remove '/'

   if( ! (otherHasPrefix ^ hasSuffix))
   {
      if( hasSuffix) // case 1 1
      {
         if( other_len == 1)
            return( [self substringWithRange:NSRangeMake( 0, len - 1)]);
         other = [other substringFromIndex:1];
      }
      else          // case 0 0
         other = [separator stringByAppendingString:other];
   }

   return( [self stringByAppendingString:other]);
}

@end
