//
//  NSCharacterSet.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "import.h"


@class NSData;
@class NSString;

typedef mulle_utf32_t  unichar;



@interface NSCharacterSet : NSObject  < NSCopying, MulleObjCClassCluster, MulleObjCValue>

- (instancetype) initWithBitmapRepresentation:(NSData *) data;

- (NSData *) bitmapRepresentation;
- (BOOL) isSupersetOfSet:(NSCharacterSet *) set;
- (BOOL) longCharacterIsMember:(long) c;

+ (instancetype) characterSetWithCharactersInString:(NSString *) s;

+ (instancetype) alphanumericCharacterSet;
+ (instancetype) controlCharacterSet;
+ (instancetype) capitalizedLetterCharacterSet;
+ (instancetype) decimalDigitCharacterSet;
+ (instancetype) letterCharacterSet;
+ (instancetype) lowercaseLetterCharacterSet;
+ (instancetype) punctuationCharacterSet;
+ (instancetype) symbolCharacterSet;
+ (instancetype) uppercaseLetterCharacterSet;
+ (instancetype) whitespaceAndNewlineCharacterSet;
+ (instancetype) whitespaceCharacterSet;

- (void) mulleGetBitmapBytes:(unsigned char *) bytes
                       plane:(NSUInteger) plane;
@end


@interface NSCharacterSet( Subclasses)

- (BOOL) characterIsMember:(unichar) c;
- (BOOL) hasMemberInPlane:(NSUInteger) plane;
- (NSCharacterSet *) invertedSet;

@end



static inline size_t   mulle_unichar_strlen( unichar *s)
{
   return( mulle_utf32_strlen( s));
}


static inline size_t   mulle_unichar_strnlen( unichar *s, size_t len)
{
   return( mulle_utf32_strnlen( s, len));
}


static inline unichar   *mulle_unichar_strncpy( unichar *dst, unichar *src, size_t len)
{
   return( mulle_utf32_strncpy( dst, src, len));
}


static inline unichar   *mulle_unichar_strchr( unichar *s, int c)
{
   return( mulle_utf32_strchr( s, c));
}


static inline int   _mulle_unichar_atoi( unichar **s)
{
   return( _mulle_utf32_atoi( s));
}


static inline unichar   *mulle_unichar_strstr( unichar *s1, unichar *s2)
{
   return( mulle_utf32_strstr( s1, s2));
}


static inline int      mulle_unichar_strncmp( unichar *s1, unichar *s2, size_t len)
{
   return( mulle_utf32_strncmp( s1, s2, len));
}


static inline size_t   mulle_unichar_strspn( unichar *s1, unichar *s2)
{
   return( mulle_utf32_strspn( s1, s2));
}


static inline size_t   mulle_unichar_strcspn( unichar *s1, unichar *s2)
{
   return( mulle_utf32_strcspn( s1, s2));
}


static inline int   mulle_unichar_strcmp( mulle_utf32_t *s1, mulle_utf32_t *s2)
{
   return( mulle_unichar_strncmp( s1, s2, -1));
}


static inline int   mulle_unichar_atoi( unichar *s)
{
   return( _mulle_unichar_atoi( &s));
}


