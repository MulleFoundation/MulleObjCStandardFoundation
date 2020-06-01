//
//  NSPropertyListSerialization.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "NSPropertyListSerialization.h"

// other files in this library
#import "_MulleObjCPropertyListReader.h"
#import "NSObject+PropertyListParsing.h"
#import "NSData+PropertyListParsing.h"

// other libraries of MulleObjCStandardFoundation
#import "NSError.h"


// std-c and dependencies
#include <ctype.h>
#include <string.h>


@interface NSObject( Future)

- (BOOL) _propertyListIsValidForFormat:(NSPropertyListFormat) format;

@end


@implementation NSPropertyListSerialization


// as these are installed during initialize, we don't need to
// lock
#define S_DETECTOR   4
#define S_PARSOR     8
#define S_PRINTOR    6

struct
{
   SEL            _detector[ S_DETECTOR];
   unsigned int   _n_detector;

   struct
   {
      NSUInteger   format;
      Class        cls;
      SEL          method;
   }              _parsor[ S_PARSOR];
   unsigned int   _n_parsor;

   struct
   {
      NSUInteger   format;
      SEL          method;
   }              _printor[ S_PRINTOR];
   unsigned int   _n_printor;
} Self;



+ (void) mulleAddFormatDetector:(SEL) detector
{
   if( Self._n_detector >= S_DETECTOR)
      abort();

   Self._detector[ Self._n_detector] = detector;
   Self._n_detector++;
}


+ (void) mulleAddParserClass:(Class) parserClass
                      method:(SEL) method
       forPropertyListFormat:(NSPropertyListFormat) format
{
   if( Self._n_parsor >= S_PARSOR)
      abort();

   Self._parsor[ Self._n_parsor].format = format;
   Self._parsor[ Self._n_parsor].cls    = parserClass;
   Self._parsor[ Self._n_parsor].method = method;
   Self._n_parsor++;
}


+ (void) mulleAddPrintMethod:(SEL) method
       forPropertyListFormat:(NSPropertyListFormat) format
{
   if( Self._n_printor >= S_PRINTOR)
      abort();

   Self._printor[ Self._n_printor].format = format;
   Self._printor[ Self._n_printor].method = method;
   Self._n_printor++;
}


+ (void) initialize
{
   if( Self._n_detector)
      return;

   [self mulleAddFormatDetector:@selector( mulleDetectPropertyListFormat:)];

   [self mulleAddParserClass:self
                      method:@selector( mulleLooselyParsePropertyListData:)
       forPropertyListFormat:MullePropertyListLooseOpenStepFormat];
   [self mulleAddParserClass:self
                      method:@selector( mulleParsePropertyListData:)
       forPropertyListFormat:NSPropertyListOpenStepFormat];

   [self mulleAddPrintMethod:@selector( propertyListUTF8DataToStream:)
         forPropertyListFormat:MullePropertyListLooseOpenStepFormat];
   [self mulleAddPrintMethod:@selector( propertyListUTF8DataToStream:)
         forPropertyListFormat:NSPropertyListOpenStepFormat];

   [self mulleAddPrintMethod:@selector( jsonUTF8DataToStream:)
         forPropertyListFormat:MullePropertyListJSONFormat];
}


#ifdef DEBUG
+ (void) deinitialize
{
   memset( &Self, 0xEE, sizeof( Self));
}
#endif


/*
 * PRINTING
 */
+ (NSData *) dataFromPropertyList:(id) plist
                           format:(NSPropertyListFormat) format
                 errorDescription:(NSString **) errorDescription
{
   NSMutableData   *data;
   int             i;

   i = Self._n_printor;
   while( --i >= 0)
   {
      if( format == Self._printor[ i].format)
      {
         data = [NSMutableData dataWithCapacity:4192];
         MulleObjCObjectPerformSelector( plist, Self._printor[ i].method, data);
         if( ! data && errorDescription)
            *errorDescription = @"failed";   // TODO: grab current NSError or so
         return( data);
      }
   }

   if( errorDescription)
      *errorDescription = @"unknown format";   // TODO: grab current NSError or so
   return( nil);
}


+ (NSData *) dataWithPropertyList:(id) plist
                           format:(NSPropertyListFormat) format
                          options:(NSPropertyListWriteOptions) options
                            error:(NSError **) p_error
{
   NSString   *errorDescription;
   NSData     *data;

   data = [self dataFromPropertyList:plist
                              format:format
                    errorDescription:&errorDescription];
   if( data || ! p_error)
      return( data);

   *p_error = [NSError mulleGenericErrorWithDomain:@"PlistDomain"
                              localizedDescription:errorDescription];
   return( data);
}


/*
 * PARSING
 */
+ (NSPropertyListFormat) mulleDetectPropertListFormatWithData:(NSData *) data
{
   int                    i;
   NSPropertyListFormat   format;

   i = Self._n_detector;
   while( --i >= 0)
   {
      format = (NSPropertyListFormat)
                  MulleObjCObjectPerformSelector( self, Self._detector[ i], data);
      if( format)
         return( format);
   }
   // always fallback to plist
   return( NSPropertyListOpenStepFormat);
}


+ (id) parsePropertyListData:(NSData *) data
            mutabilityOption:(NSPropertyListMutabilityOptions) opt
                      format:(NSPropertyListFormat) format
{
   int                    i;
   NSPropertyListFormat   format;
   id                     plist;
   id                     parser;

   plist = nil;

   i = Self._n_parsor;
   while( --i >= 0)
   {
      // fprintf( stderr, "%ld vs %ld\n", Self._parsor[ i].format, format);

      if( Self._parsor[ i].format == format)
      {
         // default doesn't create a separate parse instance so we
         // use the +method, but for subclasses we create an instance
         // so it can keep state
         parser = self;
         if( Self._parsor[ i].cls != parser)
            parser = [[Self._parsor[ i].cls new] autorelease];

         plist  = MulleObjCObjectPerformSelector( parser, Self._parsor[ i].method, data);
         if( plist)
            break;
      }
   }
   return( plist);
}


NSString   *MulleStringFromPropertListFormatString( NSPropertyListFormat format)
{
   switch( format)
   {
   case NSPropertyListOpenStepFormat         : return( @"OpenStep");
   case MullePropertyListLooseOpenStepFormat : return( @"Loose OpenStep");
//    MullePropertyListGNUstepFormat        = 4, // future
//    MullePropertyListFormat               = 5, // future
   case MullePropertyListJSONFormat          : return( @"JSON");
   case NSPropertyListXMLFormat_v1_0         : return( @"XML");
   case NSPropertyListBinaryFormat_v1_0      : return( @"binary");
   }
   return( @"???");
}


+ (instancetype) propertyListFromData:(NSData *) data
                     mutabilityOption:(NSPropertyListMutabilityOptions) opt
                               format:(NSPropertyListFormat *) format
                     errorDescription:(NSString **) errorString
{
   _MulleObjCByteOrderMark             bom;
   _MulleObjCPropertyListReader        *reader;
   MulleObjCBufferedInputStream   *stream;
   id                                  plist;
   NSPropertyListSerialization         *parser;
   NSPropertyListFormat                preferred;
   struct {
      NSString                         *string;
      NSPropertyListFormat             format;
   } dummy;

   preferred = NSPropertyListOpenStepFormat;

   if( ! errorString)
      errorString = &dummy.string;
   if( ! format)
      format = &dummy.format;
   else
      preferred = *format;

   bom = [data _byteOrderMark];
   switch( bom)
   {
   case _MulleObjCNoByteOrderMark   :
   case _MulleObjCUTF8ByteOrderMark :
      break;

   case _MulleObjCUTF16LittleEndianByteOrderMark :
      if( NSHostByteOrder() != NS_LittleEndian)
         data = [data mulleSwappedUTF16CharacterData];
      data = [data mulleConvertedUTF16ToUTF8Data];
      // convert to UTF8
      break;

   case _MulleObjCUTF16BigEndianByteOrderMark :
      if( NSHostByteOrder() != NS_BigEndian)
         data = [data mulleSwappedUTF16CharacterData];
      data = [data mulleConvertedUTF16ToUTF8Data];
      break;
   }

   if( ! [data length])
      return( nil);

   plist = nil;
   // TODO: make this more plug and play via lookup table

   // default error
   *format = [self mulleDetectPropertListFormatWithData:data];
   if( ! *format)
   {
      *errorString = @"Can not parse this kind of data as a plist";
      return( nil);
   }
   if( *format == NSPropertyListOpenStepFormat &&
        preferred == MullePropertyListLooseOpenStepFormat)
   {
      *format = MullePropertyListLooseOpenStepFormat;
   }

   *errorString = nil;
NS_DURING
   plist = [self parsePropertyListData:data
                      mutabilityOption:opt
                                format:*format];
NS_HANDLER
   *errorString = [localException reason];
NS_ENDHANDLER
   if( ! plist && ! *errorString)
      *errorString = [NSString stringWithFormat:@"Can not parse this %@ plist",
                        MulleStringFromPropertListFormatString( *format)];

   return( plist);
}


+ (id) propertyListWithData:(NSData *) data
                    options:(NSPropertyListMutabilityOptions) opt
                     format:(NSPropertyListFormat *) p_format
                      error:(NSError **) p_error
{
   NSString   *errorDescription;
   id         plist;

   plist = [self propertyListFromData:data
                     mutabilityOption:opt
                               format:p_format
                     errorDescription:&errorDescription];
   if( plist || ! p_error)
      return( plist);

   // TODO: fix error handling of plist parser globally
   *p_error = [NSError mulleGenericErrorWithDomain:@"PlistDomain"
                              localizedDescription:errorDescription];
   return( plist);
}


//
// what will eventually be called (yes it's not an instance method)
//
+ (id) mulleLooselyParsePropertyListData:(NSData *) data
{
   _MulleObjCPropertyListReader        *reader;
   MulleObjCBufferedInputStream   *stream;
   id                                  plist;
   NSPropertyListSerialization         *parser;
   NSString                            *dummy;

   stream = [[[MulleObjCBufferedInputStream alloc] initWithData:data] autorelease];
   reader = [[[_MulleObjCPropertyListReader alloc] initWithBufferedInputStream:stream] autorelease];

   [reader setDecodesComments:YES];
   [reader setDecodesPBX:YES];
   [reader setDecodesNumber:YES];

   plist = [_MulleObjCNewFromPropertyListWithStreamReader( reader) autorelease];
   return( plist);
}

//
// what will eventually be called (yes it's not an instance method)
//
+ (id) mulleParsePropertyListData:(NSData *) data
{
   _MulleObjCPropertyListReader        *reader;
   MulleObjCBufferedInputStream   *stream;
   id                                  plist;
   NSPropertyListSerialization         *parser;
   NSString                            *dummy;

   stream = [[[MulleObjCBufferedInputStream alloc] initWithData:data] autorelease];
   reader = [[[_MulleObjCPropertyListReader alloc] initWithBufferedInputStream:stream] autorelease];

   [reader setDecodesComments:NO];
   [reader setDecodesPBX:NO];
   [reader setDecodesNumber:NO];

   plist = [_MulleObjCNewFromPropertyListWithStreamReader( reader) autorelease];
   return( plist);
}


+ (BOOL) propertyList:(id) plist
     isValidForFormat:(NSPropertyListFormat) format
{
   if( ! [plist respondsToSelector:@selector( _propertyListIsValidForFormat:)])
      return( NO);

   return( [plist _propertyListIsValidForFormat:format]);
}



// a heuristic
+ (NSPropertyListFormat) mulleDetectPropertyListFormat:(NSData *) data
{
   char         *s;
   char         *sentinel;
   int          c;
   NSUInteger   len;
   int          guess;
   BOOL         instring;

   s   = [data bytes];
   len = [data length];

   if( len >= 6 && ! memcmp( s, "bplist", 6))
      return( NSPropertyListBinaryFormat_v1_0);

   instring = NO;
   //
   // we look at 1 K of data, if we can't figure it out till then
   // we will have to guess
   //
   sentinel = &s[ len < 1024 ? len : 1024];
   guess    = 0;
   for(;s < sentinel;s++)
   {
      c = *s;
      if( isspace( c))
         continue;

      if( c == '<')
      {
         // could be also NSData Plist
         for( ++s; s < sentinel; s++)
         {
            c = *s;
            if( isspace( c))
               continue;

            // looks like a NSData ?
            switch( toupper( c))
            {
            case 'A' :
            case 'B' :
            case 'C' :
            case 'D' :
            case 'E' :
            case 'F' :
            case '0' :
            case '1' :
            case '2' :
            case '3' :
            case '4' :
            case '5' :
            case '6' :
            case '7' :
            case '8' :
            case '9' :
               continue;

            case '>' : return( NSPropertyListOpenStepFormat);
            }
            // anything elss we assume is xml
            return( NSPropertyListXMLFormat_v1_0);
         }
         return( NSPropertyListOpenStepFormat);
      }

      if( c == '[')
         return( MullePropertyListJSONFormat);
      if( c == '(')
         return( NSPropertyListOpenStepFormat);
      if( c == '{')
         guess = NSPropertyListOpenStepFormat;
      break;
   }

   if( ! guess)
      return( 0);

   //
   // so its either JSON or Plist... we look for tell tales '(', '[' ':' or '='
   //
   for( ;s < sentinel;s++)
   {
      c = *s;
      if( isspace( c))
         continue;

      if( instring)
      {
         switch( c)
         {
         case '"' :
            instring = NO;
            break;

         case '\\' :
            ++s;  // skip escaped
            break;
         }
         continue;
      }

      switch( c)
      {
      case ':' :
      case '[' : return( MullePropertyListJSONFormat);

      case '<' :
      case '>' :
      case '=' :
      case ';' :
      case '(' : return( NSPropertyListOpenStepFormat);

      case '"' :
         instring = YES;
         break;
      }
   }

   // assume plist as default, we did see a '{' after all
   return( guess);
}

@end
