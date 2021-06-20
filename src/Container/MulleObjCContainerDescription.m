//
//  MulleObjectContainer.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2019 Nat! - Mulle kybernetiK.
//  Copyright (c) 2019 Codeon GmbH.
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
//
#import "MulleObjCContainerDescription.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardValueFoundation.h"


// std-c and dependencies



NSString   *MulleObjCObjectContainerDescriptionWithSelector( id self,
                                                             SEL sel,
                                                             struct MulleObjCObjectContainerDescriptionInfo *info)
{
   id                value;
   NSArray           *lines;
   NSMutableString   *s;
   NSString          *line;
   NSString          *valueString;
   NSUInteger        count;
   NSUInteger        i;

   count = [self count];
   if( ! count)
      return( info->empty);

   s = [NSMutableString stringWithString:info->opener];
   for( value in self)
   {
      [s appendString:info->indent]; // 4 spaces for MulleScion tests

      /**/
      valueString = [value performSelector:sel];
      lines       = [valueString componentsSeparatedByString:@"\n"];

      i = 0;
      for( line in lines)
      {
         if( i++)
            [s appendString:info->indent]; // 4 spaces for MulleScion tests
         [s appendString:line];
      }

      [s appendString:--count ? info->separator : info->lastSeparator];
   }

   [s appendString:info->closer];

   return( s);
}


NSString   *
   MulleObjCKeyValueContainerDescriptionWithSelector( id self,
                                                      SEL sel,
                                                      struct MulleObjCObjectContainerDescriptionInfo *info)
{
   id                value;
   NSArray           *keys;
   NSArray           *lines;
   NSMutableString   *s;
   NSString          *key;
   NSString          *line;
   NSString          *keyString;
   NSString          *valueString;
   NSUInteger        count;
   NSUInteger        i;

   count = [self count];
   if( ! count)
      return( info->empty);

   s = [NSMutableString stringWithString:info->opener];

   keys = [[self allKeys] sortedArrayUsingSelector:@selector( mulleCompareDescription:)];
   for( key in keys)
   {
      value = [self objectForKey:key];
      [s appendString:info->indent]; // 4 spaces for MulleScion tests

      /**/
      keyString   = [key performSelector:sel];
      [s appendString:keyString];
      [s appendString:@" = "];

      valueString = [value performSelector:sel];
      lines       = [valueString componentsSeparatedByString:@"\n"];

      i = 0;
      for( line in lines)
      {
         if( i++)
            [s appendString:info->indent]; // 4 spaces for MulleScion tests
         [s appendString:line];
      }
      [s appendString:--count ? info->separator : info->lastSeparator];
   }

   [s appendString:info->closer];

   return( s);
}
