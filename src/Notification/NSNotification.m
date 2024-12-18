//
//  NSNotification.m
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
#import "NSNotification.h"

#import "NSException.h"

#import "MulleObjCStandardValueFoundation.h"


@implementation NSNotification

static void   init( NSNotification *self,
                    NSString *name,
                    id obj,
                    id userInfo)
{
   self->_name     = [name copy];
   self->_object   = [obj retain];
   self->_userInfo = [userInfo copy];
}

// It used to be that you don't need dealloc, because they are all properties
// but now that read only properties aren't cleared, we have to do this.
// NOTE: need to clarify the stance on readonly properties somewhere

- (void) dealloc
{
   [_name release];
   [_object release];
   [_userInfo release];

   [super dealloc];
}


+ (instancetype) notificationWithName:(NSString *) name
                               object:(id) obj;
{
   NSNotification   *notification;

   if( ! name)
      MulleObjCThrowInvalidArgumentException( @"name is nil");

   notification = [NSAllocateObject( self, 0, NULL) autorelease];
   init( notification, name, obj, NULL);
   return( notification);
}


+ (instancetype) notificationWithName:(NSString *) name
                               object:(id) obj
                             userInfo:(id <NSCopying, MulleObjCRuntimeObject>) userInfo
{
   NSNotification   *notification;

   if( ! name)
      MulleObjCThrowInvalidArgumentException( @"name is nil");

   notification = [NSAllocateObject( self, 0, NULL) autorelease];
   init( notification, name, obj, userInfo);

   return( notification);
}


- (NSString *) mulleDebugContentsDescription      MULLE_OBJC_THREADSAFE_METHOD
{
   return( [NSString stringWithFormat:@"name=%@ object=%@ userInfo=%@", _name, _object, _userInfo]);
}


@end
