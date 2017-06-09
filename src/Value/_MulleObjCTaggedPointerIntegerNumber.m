//
//  _MulleObjCTaggedPointerIntegerNumber.m
//  MulleObjCFoundation
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

#import "_MulleObjCTaggedPointerIntegerNumber.h"


#ifndef MULLE_OBJC_NO_TAGGED_POINTERS

@implementation _MulleObjCTaggedPointerIntegerNumber

+ (void) load
{
   if( MulleObjCTaggedPointerRegisterClassAtIndex( self, 0x2))
   {
      perror( "Need tag pointer aware runtime for _MulleObjCTaggedPointerIntegerNumber with empty slot #2\n");
      abort();
   }
}

- (int32_t) _int32Value     { return( (int32_t) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (int64_t) _int64Value     { return( (int64_t) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }

- (BOOL) boolValue          { return( _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self) ? YES : NO); }
- (char) charValue          { return( (char) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (short) shortValue        { return( (short) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (int) intValue            { return( (int) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (long) longValue          { return( (long) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (NSInteger) integerValue  { return( (NSInteger) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (long long) longLongValue { return( (long long) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }

- (double) doubleValue            { return( (double) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (long double) longDoubleValue   { return( (long double) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }


- (void) getValue:(void *) value
{
   *(NSInteger *) value = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
}


- (_ns_superquad) _superquadValue
{
   _ns_superquad  value;
   NSInteger             v;

   v        = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
   value.lo = v;
   value.hi = (v < 0) ? -1 : 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( NSInteger));
}


@end

#endif
