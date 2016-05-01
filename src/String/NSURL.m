/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSURL.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSURL.h"

// other files in this library
#import "NSString.h"
#import "NSString+Components.h"
#import "NSString+Search.h"
#import "NSMutableString.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationString.h"
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
   return( nil);
}


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


- (id) initWithString:(NSString *) URLString 
        relativeToURL:(NSURL *) baseURL
{
   [self init];
   
   copy( &_scheme, baseURL, @selector( scheme));
   copy( &_user, baseURL, @selector( user));
   copy( &_password, baseURL, @selector( password));
   copy( &_host, baseURL, @selector( host));
   copy( &_fragment, baseURL, @selector( fragment));
   copy( &_query, baseURL, @selector( query));
   copy( &_parameterString, baseURL, @selector( parameterString));
   
   _path = [[[baseURL path] stringByAppendingPathComponent:URLString] retain];
   _port = [[baseURL port] copy];
   
   return( self);
}


- (NSString *) absoluteString
{
   abort();
   return( 0);
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
   components = [self componentsSeparatedByString:NSURLPathComponentSeparator];
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


- (BOOL) isFileURL
{
   return( YES);
}


- (BOOL) isAbsolutePath
{
   return( YES);
}


@end
