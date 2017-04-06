//
//  NSURL.m
//  MulleObjCFoundation
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
#import "NSURL.h"

// other files in this library
#import "NSString.h"
#import "NSString+Components.h"
#import "NSString+Escaping.h"
#import "NSString+Search.h"
#import "NSMutableString.h"
#import "NSScanner.h"
#import "NSCharacterSet.h"
#include "http_parser.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationValue.h"

// std-c and dependencies


static NSString  *NSURLPathComponentSeparator = @"/";
static NSString  *NSURLPathExtensionSeparator = @".";


@implementation NSURL


+ (instancetype) URLWithString:(NSString *) s
{
   return( [[[self alloc] initWithString:s] autorelease]);
}


- (id) initWithScheme:(NSString *) scheme
                 host:(NSString *) host
                 path:(NSString *) path
{
   [self init];

   _scheme = [scheme copy];
   _host   = [host copy];
   _path   = [path copy];

   return( self);
}


- (id) initWithString:(NSString *) s
{
   char                     *c_string;
   char                     *c_substring;
   struct http_parser_url   url;
   size_t                   c_string_len;
   NSString                 *result;
   unsigned int             i;

   c_string_len = [s _UTF8StringLength];
   if( ! c_string_len)
   {
      [self release];
      return( nil);

   }
   c_string = (char *) [s UTF8String];

   http_parser_url_init( &url);
   if( http_parser_parse_url( c_string, c_string_len, 0, &url))
   {
      // not so fast, assume it's a file url
      _scheme = @"file";
      _path   = [s copy];
      return( self);
   }

   assert( ! _scheme && ! _host && ! _path && ! _query && ! _fragment && !_parameterString);

   for( i = UF_SCHEMA; i < UF_MAX; i++)
   {
      if( ! (url.field_set & (1 << i)))
         continue;
      if( i == UF_PORT)
      {
         _port = [NSNumber numberWithUnsignedShort:url.port];
         continue;
      }
      c_substring = &c_string[ url.field_data[ i].off];
      result      = [[NSString alloc] _initWithUTF8Characters:(mulle_utf8_t*) c_substring
                                                       length:url.field_data[ i].len];
      switch( i)
      {
      case UF_SCHEMA   : _scheme          = result; break;
      case UF_HOST     : _host            = result; break;
      case UF_PATH     : _path            = result; break;
      case UF_QUERY    : _query           = result; break;
      case UF_FRAGMENT : _fragment        = result; break;
      case UF_USERINFO : _parameterString = result; break;
      }
   }

   return( self);
}

//- (id) initWithString:(NSString *) s
//{
//   NSUInteger       length;
//   NSRange          found;
//   NSScanner        *scanner;
//   NSUInteger       memo;
//   NSString         *tmp;
//
//   scanner = [NSScanner scannerWithString:s];
//
//   // scan optional scheme:/[/]
//   memo = [scanner scanLocation];
//   if( [scanner scanCharactersFromSet:[NSCharacterSet URLSchemeAllowedCharacterSet]
//                          intoString:&_scheme])
//   {
//      if( [scanner scanString:@":/"
//                  intoString:NULL])
//      {
//         // slurp in optional '/'
//         [scanner scanString:@"/"
//                  intoString:NULL];
//      }
//      else
//      {
//         // wind back to top
//         [scanner setScanLocation:memo];
//         _scheme = nil;
//      }
//      [_scheme retain];
//   }
//
//   // scan optional user:password@
//   memo = [scanner scanLocation];
//   if( [scanner scanCharactersFromSet:[NSCharacterSet URLUserAllowedCharacterSet]
//                       intoString:&_user])
//   {
//      if( [scanner scanString:@":"
//                   intoString:NULL])
//      {
//         if( ! [scanner scanCharactersFromSet:[NSCharacterSet URLPasswordAllowedCharacterSet]
//                                 intoString:&_password])
//            goto fail;
//      }
//
//      if( ! [scanner scanString:@"@"
//                     intoString:NULL])
//      {
//fail:
//         // wind back to top
//         [scanner setScanLocation:memo];
//         _user     = nil;
//         _password = nil;
//      }
//      [_user  retain];
//      [_password  retain];
//   }
//
//   // scan optional host:port /
//   memo = [scanner scanLocation];
//   if( [scanner scanCharactersFromSet:[NSCharacterSet URLHostAllowedCharacterSet]
//                           intoString:&_host])
//   {
//      if( [scanner scanString:@":"
//                   intoString:NULL])
//      {
//         if( ! [scanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet]
//                                   intoString:&tmp])
//            goto fail2;
//
//         _port = [NSNumber numberWithInt:[tmp intValue]];
//      }
//
//      if( ! [scanner scanString:@"/"
//                     intoString:NULL])
//      {
//fail2:
//         // wind back to top
//         [scanner setScanLocation:memo];
//         _host = nil;
//         _port = nil;
//      }
//      [_host  retain];
//      [_port  retain];
//   }
//
//   found  = [s _rangeOfCharactersFromSet:[NSCharacterSet URLSchemeAllowedCharacterSet]
//                                 options:NSLiteralSearch|NSAnchoredSearch
//                                   range:NSMakeRange( 0, [s length])];
//   if( found.length)
//   {
//      if( [s rangeOfString:@":/"
//                   options:NSLiteralSearch|NSAnchoredSearch
//                  range:NSMakeRange( 0, [s length]
//   }
//
//   [self release];  // TODO
//   return( nil);
//}
//

static void  copy( NSString **dst, NSURL *src, SEL sel)
{
   NSString  *s;

   s    = [src performSelector:sel];
   *dst = [s copy];
}


- (id) copy
{
   NSURL  *p;

   p = [[self class] new];

   copy( &p->_scheme, self, @selector( scheme));
   copy( &p->_user, self, @selector( user));
   copy( &p->_password, self, @selector( password));
   copy( &p->_host, self, @selector( host));
   copy( &p->_fragment, self, @selector( fragment));
   copy( &p->_query, self, @selector( query));
   copy( &p->_path, self, @selector( path));
   copy( &p->_parameterString, self, @selector( parameterString));

   p->_port = [self->_port copy];

   return( p);
}


- (id) initWithString:(NSString *) string
        relativeToURL:(NSURL *) baseURL
{
   NSString   *s;

   [self init];

   copy( &_scheme, baseURL, @selector( scheme));
   copy( &_user, baseURL, @selector( user));
   copy( &_password, baseURL, @selector( password));
   copy( &_host, baseURL, @selector( host));
   copy( &_fragment, baseURL, @selector( fragment));
   copy( &_query, baseURL, @selector( query));
   copy( &_parameterString, baseURL, @selector( parameterString));

   s = [baseURL path];
   if( ! [string hasPrefix:@"/"] && ! [s hasSuffix:@"/"])
      s = [s stringByAppendingString:@"/"];
   s = [s stringByAppendingString:string];

   _path = [s copy];
   _port = [[baseURL port] copy];

   return( self);
}


- (NSString *) absoluteString
{
   NSMutableString   *s;

   s = [NSMutableString string];
   if( _scheme)
   {
      [s appendString:_scheme];
      [s appendString:@":/"];
   }

   if( _host)
   {
      [s appendString:@""];
      if( _user)
      {
         [s appendString:_user];
         if( _password)
         {
            [s appendString:@":"];
            [s appendString:_password];
         }
         [s appendString:@"@"];
      }
      [s appendString:_host];
      if( _port)
      {
         [s appendString:@":"];
         [s appendString:[_port description]];
      }
   }

   if( _path)
   {
      [s appendString:@"/"];
      [s appendString:_path];

      if( _query)
      {
         [s appendString:@"?"];
         [s appendString:_query];
         if( _parameterString)
         {
            [s appendString:@"&"]; // ???
            [s appendString:_parameterString];
         }
      }

      if( _fragment)
      {
         [s appendString:@"#"];
         [s appendString:_fragment];
      }
   }
   return( s);
}



static BOOL  append( NSMutableString *s, NSString *value)
{
   if( value)
   {
      [s appendString:value];
      return( YES);
   }
   return( NO);
}


static void   _appendResourceSpecifierToMutableString( NSURL *self, NSMutableString *s)
{
   if( self->_host)
   {
      append( s, @"/");
      if( self->_user)
      {
         append( s, self->_user);
         if( self->_password)
         {
            append( s, @":");
            append( s, self->_password);
         }
         append( s, @"@");
      }
      append( s, self->_host);
      if( self->_port)
      {
         append( s, @":");
         append( s, [self->_port description]);
      }
   }
   if( self->_path)
   {
      append( s, @"/");
      append( s, self->_path);
   }
   if( self->_query)
   {
      append( s, @"?");
      append( s, self->_query);
   }
   if( self->_fragment)
   {
      append( s, @"#");
      append( s, self->_fragment);
   }
}


- (NSString *) resourceSpecifier
{
   NSMutableString  *s;

   s = [NSMutableString string];
   _appendResourceSpecifierToMutableString( self, s);
   return( s);
}


//
// can't reuse NSString code, because it might have different separator
// characters
//
static NSRange  getLastPathComponentRange( NSString *self)
{
   return( [self rangeOfString:NSURLPathComponentSeparator
                       options:NSBackwardsSearch]);
}


static NSRange  getPathExtensionRange( NSString *self)
{
   NSRange   range1;
   NSRange   range2;

   range1 = getLastPathComponentRange( self);
   if( range1.length == 0)
      return( range1);

   range2 = [self rangeOfString:NSURLPathExtensionSeparator
                        options:NSBackwardsSearch];
   if( range2.length && range1.location < range2.location)
      return( NSMakeRange( NSNotFound, 0));

   return( range1);
}


- (NSArray *) pathComponents
{
   return( [_path componentsSeparatedByString:NSURLPathComponentSeparator]);
}


- (NSString *) lastPathComponent
{
   NSRange   range;

   range = getLastPathComponentRange( _path);
   if( ! range.length)
      return( _path);

   return( [_path substringFromIndex:range.location + 1]);
}


- (NSString *) pathExtension
{
   NSRange   range;

   range = getPathExtensionRange( _path);
   if( ! range.length)
      return( nil);
   return( [_path substringFromIndex:range.location + 1]);
}


- (NSURL *) absoluteURL
{
   if( [_path hasPrefix:NSURLPathComponentSeparator])
      return( self);
   abort();
   return( nil);
}


- (NSURL *) baseURL
{
   abort();
   return( nil);
}


// non-optimal ...

- (NSURL *) standardizedURL
{
   NSArray          *components;
   NSMutableArray   *result;
   NSString         *s;
   NSURL            *clone;
   BOOL             flag;
   NSEnumerator     *rover;

   result     = [NSMutableArray array];
   flag       = NO;
   components = [[self path] componentsSeparatedByString:NSURLPathComponentSeparator];
   rover      = [components objectEnumerator];

   while( s = [rover nextObject])
   {
      if( [s isEqualToString:@"."])
      {
         flag = YES;
         continue;
      }
      if( [s isEqualToString:@".."])
      {
         flag = YES;
         [result removeLastObject];
         continue;
      }
      [result addObject:s];
   }

   if( ! flag)
      return( self);

   clone = [[self copy] autorelease];
   [clone->_path release];

   clone->_path = [[result componentsJoinedByString:NSURLPathComponentSeparator] retain];
   return( clone);
}

#pragma mark -
#pragma mark unescaping accessors

//
// This property contains the path, unescaped using the
// stringByReplacingPercentEscapesUsingEncoding: method. If the receiver does
// not conform to RFC 1808, this property contains nil.
//
- (NSString *) path
{
   return( [_path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}


- (NSString *) host
{
   return( [_host stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *) user
{
   return( [_user stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}



#pragma mark -
#pragma mark queries

- (BOOL) isFileURL
{
   return( [_scheme isEqualToString:@"file"]);
}


- (BOOL) isAbsolutePath
{
   return( [_path hasPrefix:NSURLPathComponentSeparator]);
}

- (NSString *) description
{
   return( [self absoluteString]);
}

@end
