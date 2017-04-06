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

#import "NSEnumerator.h"


static NSString  *NSURLPathComponentSeparator = @"/";
static NSString  *NSURLPathExtensionSeparator = @".";


@implementation NSURL


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


- (id) initWithString:(NSString *) URLString
{
   abort();
   return( nil);
}


static void  copy( NSString **dst, NSURL *src, SEL sel)
{
   NSString  *s;

   s    = [src performSelector:sel];
   *dst = [s copy];
}


- (id) copyWithZone:(NSZone *) zone
{
   NSURL  *p;

   p = [NSURL new];

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


- (id) initWithString:(NSString *) URLString
        relativeToURL:(NSURL *) baseURL
{
   NSArray   *components;

   [self init];

   copy( &_scheme, baseURL, @selector( scheme));
   copy( &_user, baseURL, @selector( user));
   copy( &_password, baseURL, @selector( password));
   copy( &_host, baseURL, @selector( host));
   copy( &_fragment, baseURL, @selector( fragment));
   copy( &_query, baseURL, @selector( query));
   copy( &_parameterString, baseURL, @selector( parameterString));

   components = [baseURL pathComponents];
   components = [components arrayByAddingObject:URLString];

   _path = [[components componentsJoinedByString:NSURLPathComponentSeparator] retain];
   _port = [[baseURL port] copy];

   return( self);
}


- (NSNumber *) port
{
   return( _port);
}



- (NSString *) absoluteString
{
   abort();
   return( 0);
}


- (NSString *) fragment
{
   return( _fragment);
}


- (NSString *) host
{
   return( _host);
}


- (NSString *) parameterString
{
   return( _parameterString);
}


- (NSString *) password
{
   return( _password);
}


- (NSString *) path
{
   return( _path);
}


- (NSString *) query
{
   return( _query);
}


- (NSString *) relativePath
{
   return( _path);
}


- (NSString *) relativeString
{
   return( _query);
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
   append( s, @"//");
   if( append( s, self->_user))
   {
      append( s, @":");
      append( s, self->_password);
      append( s, @"@");
   }
   if( append( s, self->_host))
   {
      append( s, @":");
      append( s, [self->_port description]);
   }
   if( self->_path)
   {
      append( s, @"/");
      append( s, self->_path);
   }
}


- (NSString *) resourceSpecifier
{
   NSMutableString  *s;

   s = [NSMutableString string];
   _appendResourceSpecifierToMutableString( self, s);
   return( s);
}


- (NSString *) scheme
{
   return( _scheme);
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
   NSEnumerator     *rover;
   NSMutableArray   *result;
   NSString         *s;
   NSURL            *clone;
   BOOL             flag;

   result     = [NSMutableArray array];
   flag       = NO;
   components = [self pathComponents];
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

   clone = [self copy];
   [clone->_path release];
   clone->_path = [[result componentsJoinedByString:NSURLPathComponentSeparator] retain];
   return( clone);
}

@end
