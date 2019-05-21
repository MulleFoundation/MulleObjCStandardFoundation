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
#import "NSData+Unicode.h"
#import "MulleObjCPropertyList.h"

// other libraries of MulleObjCStandardFoundation
#import "NSError.h"


// std-c and dependencies
#include <ctype.h>
#include <string.h>


@interface NSObject( Future)

- (BOOL) _propertyListIsValidForFormat:(NSPropertyListFormat) format;

@end



@implementation NSPropertyListSerialization

+ (NSData *) dataFromPropertyList:(id) plist
                           format:(NSPropertyListFormat) format
                 errorDescription:(NSString **) errorDescription
{
   NSData   *data;

   if( format == NSPropertyListOpenStepFormat)
   {
      data = [plist propertyListUTF8DataWithIndent:0];
      if( ! data && errorDescription)
         *errorDescription = @"failed";   // TODO: grab current NSError or so
      return( data);
   }

   abort();
   return( 0);
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

   // TODO:
   *p_error = [NSError errorWithDomain:@"PlistDomain"
                                  code:-1
                              userInfo:nil];
   return( data);
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

   s   = [data bytes];
   len = [data length];

   if( len >= 6 && ! memcmp( s, "bplist", 6))
      return( NSPropertyListBinaryFormat_v1_0);

   sentinel = &s[ len];
   while( s < sentinel)
   {
      c = *s++;
      if( isspace( c))
         continue;
      if( c != '<')
         return( NSPropertyListOpenStepFormat);
      break;
   }

   while( s < sentinel)
   {
      c = *s++;
      if( isspace( c))
         continue;

      switch( toupper( c))
      {
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
      case 'A' :
      case 'B' :
      case 'C' :
      case 'D' :
      case 'E' :
      case 'F' :
      case '/' : // comment
      case '>' : return( NSPropertyListOpenStepFormat);
      }
      break;
   }

   if( s == sentinel)
      return( NSPropertyListOpenStepFormat);
   return( NSPropertyListXMLFormat_v1_0);
}


+ (instancetype) propertyListFromData:(NSData *) data
                     mutabilityOption:(NSPropertyListMutabilityOptions) opt
                               format:(NSPropertyListFormat *) format
                     errorDescription:(NSString **) errorString
{
   _MulleObjCByteOrderMark             bom;
   _MulleObjCPropertyListReader        *reader;
   _MulleObjCBufferedDataInputStream   *stream;
   id                           plist;
   NSPropertyListSerialization  *parser;

   if( ! [data length])
      return( nil);

   bom = [data _byteOrderMark];
   switch( bom)
   {
   case _MulleObjCNoByteOrderMark   :
   case _MulleObjCUTF8ByteOrderMark :
      break;

   default                   :
      abort();
   }

   // TODO: make this more plug and play via lookup table
   switch( [self mulleDetectPropertyListFormat:data])
   {
   case NSPropertyListOpenStepFormat :
      stream = [[[_MulleObjCBufferedDataInputStream alloc] initWithData:data] autorelease];
      reader = [[[_MulleObjCPropertyListReader alloc] initWithBufferedInputStream:stream] autorelease];

      [reader setMutableContainers:opt != NSPropertyListImmutable];
      [reader setMutableLeaves:opt == NSPropertyListMutableContainersAndLeaves];
      [reader setDecodesComments:YES];
      [reader setDecodesPBX:YES];

      plist = [_MulleObjCNewFromPropertyListWithStreamReader( reader) autorelease];
      break;

   case NSPropertyListXMLFormat_v1_0 :
      parser  = [[NSPropertyListSerialization new] autorelease];
      if( ! [parser respondsToSelector:@selector( _parseXMLData:)])
         MulleObjCThrowInternalInconsistencyException( @"XML parser is not installed");

      plist = [parser _parseXMLData:data];
      break;

   default :
      // really throw here ?
      MulleObjCThrowInvalidArgumentException( @"Can not parse this kind of plist");
   }

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
   *p_error = [NSError errorWithDomain:@"XMLDomain"
                                  code:-1
                              userInfo:nil];
   return( plist);
}


@end
