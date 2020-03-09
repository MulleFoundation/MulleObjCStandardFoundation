//
//  NSObject+PropertyListPrinting.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2009 Nat! - Mulle kybernetiK.
//  Copyright (c) 2009 Codeon GmbH.
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
#import "MulleObjCPropertyListPrinting.h"

// other files in this library
#import "_MulleObjCDataStream.h"

// std-c and dependencies



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
#pragma clang diagnostic ignored "-Wobjc-root-class"


PROTOCOLCLASS_IMPLEMENTATION( MulleObjCPropertyListPrinting)

// these globals are supposed to set up by the Foundation and never
// to be changed hence after

unsigned int   _MulleObjCPropertyListUTF8DataIndentationPerLevel  = 1;
char           _MulleObjCPropertyListUTF8DataIndentationCharacter = '\t';
NSDictionary  *_MulleObjCPropertyListCanonicalPrintingLocale;

unsigned int   _MulleObjCJSONUTF8DataIndentationPerLevel  = 1;
char           _MulleObjCJSONUTF8DataIndentationCharacter = '\t';
NSDictionary  *_MulleObjCJSONCanonicalPrintingLocale;


- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
{
   [self propertyListUTF8DataToStream:handle
                               indent:0];
}


- (void) jsonUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
{
   [self jsonUTF8DataToStream:handle
                           indent:0];
}


//
// default calls propertyListUTF8DataWithIndent and write that out
// subclasses overide this
//
- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                               indent:(NSUInteger) indent
{
   NSData   *data;

   data = [self propertyListUTF8DataWithIndent:indent];
   [handle writeData:data];
}


- (void) jsonUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                       indent:(NSUInteger) indent
{
   NSData   *data;

   data = [self jsonUTF8DataWithIndent:indent];
   [handle writeData:data];
}


//
// Classes may be happy with just description (can't think of one :))
//
- (NSData *) propertyListUTF8DataWithIndent:(NSUInteger) indent
{
   return( [[(NSObject *) self description] dataUsingEncoding:NSUTF8StringEncoding]);
}


- (NSData *) jsonUTF8DataWithIndent:(NSUInteger) indent
{
   return( [[(NSObject *) self description] dataUsingEncoding:NSUTF8StringEncoding]);
}



- (NSString *) mullePropertyListDescription
{
   NSMutableData  *data;
   NSString       *s;

   data = [NSMutableData data];
   [self propertyListUTF8DataToStream:data
                               indent:0];

   s = [[[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding] autorelease];
   return( s);
}


- (NSString *) mulleJSONDescription
{
   NSMutableData  *data;
   NSString       *s;

   data = [NSMutableData data];
   [self jsonUTF8DataToStream:data
                       indent:0];

   s = [[[NSString alloc] initWithData:data
                              encoding:NSUTF8StringEncoding] autorelease];
   return( s);
}


/*
 *
 */
static char   tabs[]   = "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t";
static char   spaces[] = "                                                ";


char   *MulleObjCPropertyListUTF8DataIndentation( NSUInteger level)
{
   unsigned int    n;
   size_t          size;
   char            *s;

   if( ! level)
      return( "");

   switch( _MulleObjCPropertyListUTF8DataIndentationCharacter)
   {
   case '\t' : s = tabs;   size = sizeof( tabs) - 1;   break;
   case ' '  : s = spaces; size = sizeof( spaces) - 1; break;
   default   : s = NULL;   size = 0;                   break;
   }

   n = level * _MulleObjCPropertyListUTF8DataIndentationPerLevel;
   // size is strlen
   if( n <= size)
      return( &s[ size - n]);

   s = MulleObjCCallocAutoreleased( n + 1, sizeof( char));
   memset( s,
           _MulleObjCPropertyListUTF8DataIndentationCharacter,
           n);
   return( s);
}


char   *MulleObjCJSONUTF8DataIndentation( NSUInteger level)
{
   unsigned int    n;
   size_t          size;
   char            *s;

   if( ! level)
      return( "");

   switch( _MulleObjCJSONUTF8DataIndentationCharacter)
   {
   case '\t' : s = tabs;   size = sizeof( tabs) - 1;   break;
   case ' '  : s = spaces; size = sizeof( spaces) - 1; break;
   default   : s = NULL;   size = 0;                   break;
   }

   n = level * _MulleObjCJSONUTF8DataIndentationPerLevel;
   // size is strlen
   if( n <= size)
      return( &s[ size - n]);

   s = MulleObjCCallocAutoreleased( n + 1, sizeof( char));
   memset( s,
           _MulleObjCJSONUTF8DataIndentationCharacter,
           n);
   return( s);
}

PROTOCOLCLASS_END()

#pragma clang diagnostic pop
