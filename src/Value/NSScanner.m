//
//  NSScannr.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  Copyright (c) 2020 Codeon GmbH.
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


#import "NSScanner.h"

// other files in this library
#import "NSCharacterSet.h"
#import "NSString+NSCharacterSet.h"

// other libraries of MulleObjCStandardFoundation
#import "NSLocale.h"

// std-c and dependencies
#include <limits.h>


@implementation NSScanner

+ (instancetype) scannerWithString:(NSString *)string {
    return [[[self alloc] initWithString:string] autorelease];
}


- (instancetype) initWithString:(NSString *)string
{
   if( ! string)
   {
      [self release];
      return( nil);
   }

   self = [self init];
   if( self)
   {
      _string                = [string copy];
      _impAtIndex            = [_string methodForSelector:@selector( characterAtIndex:)];
      _length                = [_string length];

      [self setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

      _isCaseSensitive       = YES;
   }

   return self;
}


- (void) dealloc
{
   [_string release];

   [super dealloc];
}


- (NSString *) string
{
   return( _string);
}


- (BOOL) isAtEnd
{
   return( _location >= _length);
}


- (void) setCharactersToBeSkipped:(NSCharacterSet *) set
{
   [_charactersToBeSkipped autorelease];
   _charactersToBeSkipped = [set retain];
   _impIsMember           = [set methodForSelector:@selector( characterIsMember:)];
}


- (void) setScanLocation:(NSUInteger) pos
{
   if( pos > _length)
      MulleObjCThrowInvalidArgumentExceptionUTF8String("out of range");
   _location = pos;
}


MULLE_C_NEVER_INLINE
static NSRange   NSScannerScanRangeOfCharactersInSet( NSScanner *self,
                                                      NSCharacterSet *set,
                                                      IMP impMember,
                                                      BOOL match)
{
   NSRange       range;
   unichar       c;
   NSUInteger    i;

   range.location = self->_location;
   if( ! impMember)
      impMember = [set methodForSelector:@selector( characterIsMember:)];
   assert( impMember);

   for( i = range.location; i < self->_length; i++)
   {
      c = (unichar) (intptr_t) MulleObjCIMPCall( self->_impAtIndex,
                                                 self->_string,
                                                 @selector( characterAtIndex:),
                                                 (id) i);
      if( match != (BOOL) (intptr_t) MulleObjCIMPCall( impMember,
                                                       set,
                                                       @selector( characterIsMember:),
                                                       (id) (intptr_t) c))
         break;
   }
   self->_location = i;
   range.length    = i - range.location;

   return( range);
}


MULLE_C_NEVER_INLINE
static BOOL   NSScannerScanCharactersMatchingSet( NSScanner *self,
                                                  NSCharacterSet *set,
                                                  NSString **stringp,
                                                  BOOL match)
{
   NSRange   range;

   if( self->_charactersToBeSkipped)
      NSScannerScanRangeOfCharactersInSet( self,
                                           self->_charactersToBeSkipped,
                                           self->_impIsMember,
                                           YES);

   range = NSScannerScanRangeOfCharactersInSet( self, set, 0, match);
   if( stringp)
      *stringp = [self->_string substringWithRange:range];
   return( range.length != 0);
}


- (BOOL) scanCharactersFromSet:(NSCharacterSet *) charset
                    intoString:(NSString **) stringp
{
   assert( [charset isKindOfClass:[NSCharacterSet class]]);

   return( NSScannerScanCharactersMatchingSet( self, charset, stringp, YES));
}


- (BOOL) scanUpToCharactersFromSet:(NSCharacterSet *) charset
                        intoString:(NSString **) stringp
{
   assert( [charset isKindOfClass:[NSCharacterSet class]]);

   return( NSScannerScanCharactersMatchingSet( self, charset, stringp, NO));
}


MULLE_C_NEVER_INLINE
static NSRange   NSScannerScanRangeOfString( NSScanner *self,
                                             NSString *s,
                                             IMP impAtIndex)
{
   NSRange      range;
   unichar      c;
   unichar      d;
   NSUInteger   i;
   NSUInteger   j;
   NSUInteger   n;
   NSUInteger   m;

   range.location = self->_location;
   range.length   = 0;

   n = self->_length - range.location;
   m = [s length];
   if( ! m || m > n)
      return( range);

   if( ! impAtIndex)
      impAtIndex = [s methodForSelector:@selector( characterAtIndex:)];

   for( j = 0, i = range.location; j < m; i++, j++)
   {
      c = (unichar) (intptr_t) MulleObjCIMPCall( self->_impAtIndex,
                                                 self->_string,
                                                 @selector( characterAtIndex:),
                                                 (id) i);
      d = (unichar) (intptr_t) MulleObjCIMPCall( impAtIndex,
                                                 s,
                                                 @selector( characterAtIndex:),
                                                 (id) j);
      if( c != d)
         return( range);
   }
   range.length = m;

   self->_location = i;

   return( range);
}


MULLE_C_NEVER_INLINE
static NSRange   NSScannerScanRangeOfNotString( NSScanner *self,
                                                NSString *s,
                                                IMP impAtIndex)
{
   NSRange       range;
   unichar       c;
   unichar       d;
   NSUInteger    i;
   NSUInteger    j;
   NSUInteger    n;
   NSUInteger    m;

   range.location = self->_location;
   range.length   = self->_length - range.location;

   n = range.length;
   m = [s length];
   if( ! m || m > n)
   {
      self->_location = self->_length;
      return( range);
   }

   if( ! impAtIndex)
      impAtIndex = [s methodForSelector:@selector( characterAtIndex:)];

   for( j = 0, i = range.location; i < range.length; i++)
   {
      c = (unichar) (intptr_t) MulleObjCIMPCall( self->_impAtIndex,
                                                 self->_string,
                                                 @selector( characterAtIndex:),
                                                 (id) i);
      d = (unichar) (intptr_t) MulleObjCIMPCall( impAtIndex,
                                                 s,
                                                 @selector( characterAtIndex:),
                                                 (id) j);
      if( c != d)
      {
         j = 0;
         continue;
      }

      if( ++j == m)  // matched whole string
      {
         // reset location to start of string
         self->_location = (i + 1) - m;
         range.length    = self->_location - range.location;
         return( range);
      }
   }

   self->_location = self->_length;
   return( range);
}


- (BOOL) scanString:(NSString *) string
         intoString:(NSString **) stringp
{
   NSRange   range;
   BOOL      flag;

   assert( [string isKindOfClass:[NSString class]]);

   if( self->_charactersToBeSkipped)
      NSScannerScanRangeOfCharactersInSet( self,
                                           self->_charactersToBeSkipped,
                                           self->_impIsMember,
                                           YES);

   range = NSScannerScanRangeOfString( self, string, 0);
   flag  = range.length != 0;

   if( stringp )
      *stringp = flag ? string : @"";
   return( flag);
}


- (BOOL) scanUpToString:(NSString *) string
             intoString:(NSString **) stringp
{
   NSRange   range;

   assert( [string isKindOfClass:[NSString class]]);

   if( self->_charactersToBeSkipped)
      NSScannerScanRangeOfCharactersInSet( self,
                                           self->_charactersToBeSkipped,
                                           self->_impIsMember,
                                           YES);

   range = NSScannerScanRangeOfNotString( self, string, 0);
   if( stringp)
      *stringp = [self->_string substringWithRange:range];

   return( range.length != 0);
}

/*
 * Old Cocotron code
 */
/* Copyright (c) 2006-2007 Christopher J. W. Lloyd
                 2009 Markus Hitter <mah@jump-ing.de>
                 2016 Nat! <nat@mulle-kybernetik.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


-copy {
   NSScanner *copy=[[NSScanner alloc] initWithString:[self string]];

   [copy setCharactersToBeSkipped:[self charactersToBeSkipped]];
   [copy setCaseSensitive:[self caseSensitive]];
   [copy setLocale:[self locale]];
   [copy setScanLocation:[self scanLocation]];

   return copy;
}

-(BOOL)scanInt:(int *)valuep {
   long long scanValue=0;

   // This assumes sizeof(long long) >= sizeof(int).
   if(![self scanLongLong:&scanValue])
    return NO;
   else if(scanValue>INT_MAX)
    *valuep=INT_MAX;
   else if(scanValue<INT_MIN)
    *valuep=INT_MIN;
   else
    *valuep=(int)scanValue;

   return YES;
}

-(BOOL)scanInteger:(NSInteger *)valuep{
   long long scanValue=0;

   // This assumes sizeof(long long) >= sizeof(NSInteger).
   if(![self scanLongLong:&scanValue])
    return NO;
   else if(scanValue>NSIntegerMax)
    *valuep=NSIntegerMax;
   else if(scanValue<NSIntegerMin)
    *valuep=NSIntegerMin;
   else
    *valuep=(NSInteger)scanValue;

   return YES;
}


-(BOOL) scanLongLong:(long long *)valuep
{
   NSUInteger length;
   int sign=1;
   BOOL hasSign=NO;
   long long value=0;
   BOOL hasValue=NO;
   BOOL hasOverflow=NO;

   if( _charactersToBeSkipped)
      NSScannerScanRangeOfCharactersInSet( self, _charactersToBeSkipped, _impIsMember, YES);

   for(length=[_string length];_location<length;_location++){
    unichar unicode=[_string characterAtIndex:_location];

    if(!hasSign && unicode=='-'){
     sign=-1;
     hasSign=YES;
    }
    else if(unicode>='0' && unicode<='9'){
     if(!hasOverflow){
      int c=unicode-'0';

      // Inspired by http://www.math.utoledo.edu/~dbastos/overflow.html
      if ((LLONG_MAX-c)/10<value)
       hasOverflow=YES;
      else
       value=(value*10)+c;
      hasSign=YES;
      hasValue=YES;
     }
    }
    else
     break;
   }

   if(hasOverflow){
    if(sign>0)
     *valuep=LLONG_MAX;
    else
     *valuep=LLONG_MIN;
    return YES;
   }
   else if(hasValue){
    *valuep=sign*value;
    return YES;
   }

   return NO;
}

-(BOOL)scanFloat:(float *)valuep {
    double d;
    BOOL r;

    r = [self scanDouble:&d];
    *valuep = (float)d;
    return r;
}

// "...returns HUGE_VAL or -HUGE_VAL on overflow, 0.0 on underflow." hmm...
-(BOOL)scanDouble:(double *)valuep {
   NSString *seperatorString;
   unichar   decimalSeperator;
/*
   if(_locale)
      seperatorString = [_locale objectForKey:NSLocaleDecimalSeparator];
   else
      seperatorString = [[NSLocale systemLocale] objectForKey:NSLocaleDecimalSeparator];
*/
   seperatorString = @".";

   decimalSeperator = ([seperatorString length] > 0 ) ? [seperatorString characterAtIndex:0] : '.';

   NSInteger     i;
   NSInteger     len = [_string length] - _location;
   char    p[len + 1], *q;
   unichar c;

   for (i = 0; i < len; i++)
   {
      c  = [_string characterAtIndex:i + _location];
      if (c == decimalSeperator) c = '.';
      p[i] = (char)c;
   }
   p[i] = '\0';

   *valuep = strtod(p, &q);
   _location += (q - p);
   return (q > p);

/*
    enum {
        STATE_SPACE,
        STATE_DIGITS_ONLY
    } state=STATE_SPACE;
    int sign=1;
    double value=1.0;
    BOOL hasValue=NO;

    for(;_location<[_string length];_location++){
        unichar unicode=[_string characterAtIndex:_location];

        switch(state){
            case STATE_SPACE:
                if([_charactersToBeSkipped characterIsMember:unicode])
                    state=STATE_SPACE;
                else if(unicode=='-') {
                    sign=-1;
                    state=STATE_DIGITS_ONLY;
                }
                else if(unicode=='+'){
                    sign=1;
                    state=STATE_DIGITS_ONLY;
                }
                else if(unicode>='0' && unicode<='9'){
                    value=(value*10)+unicode-'0';
                    state=STATE_DIGITS_ONLY;
                    hasValue=YES;
                }
                else if(unicode==decimalSeperator) {
                    double multiplier=1;

                    _location++;
                    for(;_location<[_string length];_location++){
                        if(unicode<'0' || unicode>'9')
                            break;

                        multiplier/=10.0;
                        value+=(unicode-'0')*multiplier;
                    }
                }
                else
                    return NO;
                break;

            case STATE_DIGITS_ONLY:
                if(unicode>='0' && unicode<='9'){
                    value=(value*10)+unicode-'0';
                    hasValue=YES;
                }
                else if(!hasValue)
                    return NO;
                else if(unicode==decimalSeperator) {
                    double multiplier=1;

                    _location++;
                    for(;_location<[_string length];_location++){
                        if(unicode<'0' || unicode>'9')
                            break;

                        multiplier/=10.0;
                        value+=(unicode-'0')*multiplier;
                    }
                }
                else {
                    *valuep=sign*value;
                    return YES;
                }
                break;
        }
    }

    if(!hasValue)
        return NO;
    else {
        *valuep=sign*value;
        return YES;
    }
*/
}

/*
-(BOOL)scanDecimal:(NSDecimal *)valuep {
    NSUnimplementedMethod();
    return NO;
}
*/
// The documentation appears to be wrong, it returns -1 on overflow.
-(BOOL)scanHexInt:(unsigned *)valuep {
   enum {
    STATE_SPACE,
    STATE_ZERO,
    STATE_HEX,
   } state=STATE_SPACE;
   unsigned value=0;
   BOOL     hasValue=NO;
   BOOL     overflow=NO;

   for(;_location<[_string length];_location++){
    unichar unicode=[_string characterAtIndex:_location];

    switch(state){

     case STATE_SPACE:
      if([_charactersToBeSkipped characterIsMember:unicode])
       state=STATE_SPACE;
      else if(unicode == '0'){
       state=STATE_ZERO;
       hasValue=YES;
      }
      else if(unicode>='1' && unicode<='9'){
       value=value*16+(unicode-'0');
       state=STATE_HEX;
       hasValue=YES;
      }
      else if(unicode>='a' && unicode<='f'){
       value=value*16+(unicode-'a')+10;
       state=STATE_HEX;
       hasValue=YES;
      }
      else if(unicode>='A' && unicode<='F'){
       value=value*16+(unicode-'A')+10;
       state=STATE_HEX;
       hasValue=YES;
      }
      else
       return NO;
      break;

     case STATE_ZERO:
      state=STATE_HEX;
      if(unicode=='x' || unicode=='X')
       break;
      // fallthrough
     case STATE_HEX:
      if(unicode>='0' && unicode<='9'){
       if(!overflow){
        unsigned check=value*16+(unicode-'0');
        if(check>=value)
         value=check;
        else {
         value=-1;
         overflow=YES;
        }
       }
      }
      else if(unicode>='a' && unicode<='f'){
       if(!overflow){
        unsigned check=value*16+(unicode-'a')+10;
        if(check>=value)
         value=check;
        else {
         value=-1;
         overflow=YES;
        }
       }
      }
      else if(unicode>='A' && unicode<='F'){
       if(!overflow){
        unsigned check=value*16+(unicode-'A')+10;

        if(check>=value)
         value=check;
        else {
         value=-1;
         overflow=YES;
        }
       }
      }
      else {
       if(valuep!=NULL)
        *valuep=value;

       return YES;
      }
      break;
    }
   }

   if(hasValue){
    if(valuep!=NULL)
     *valuep=value;

    return YES;
   }

   return NO;
}


@end
