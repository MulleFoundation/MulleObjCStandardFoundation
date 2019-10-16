//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"
#import <MulleObjCStandardFoundation/private/_MulleObjCTaggedPointerChar5String.h>
#import <MulleObjCStandardFoundation/private/_MulleObjCTaggedPointerChar7String.h>
#import <MulleObjCStandardFoundation/private/_MulleObjCASCIIString.h>
#import <MulleObjCStandardFoundation/private/_MulleObjCUTF16String.h>
#import <MulleObjCStandardFoundation/private/_MulleObjCUTF32String.h>


int main( int argc, const char * argv[])
{
   // create strings with internal classes and check that the hash is
   // compatible
   // also check equality
   NSString        *strings[ 32];
   NSUInteger      i;
   NSUInteger      j;
   NSUInteger      n;
   mulle_utf16_t   pst16[] = { 'P', 'S', 'T' };
   mulle_utf32_t   pst32[] = { 'P', 'S', 'T' };

   i = 0;
   strings[ i++] = MulleObjCTaggedPointerChar5StringWithASCIICharacters( "PST", 3);
   strings[ i++] = MulleObjCTaggedPointerChar7StringWithASCIICharacters( "PST", 3);
#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES
   strings[ i++] = [[_MulleObjC03LengthASCIIString newWithASCIICharacters:"PST"
                                                                   length:3] autorelease];
   strings[ i++] = [[_MulleObjC07LengthASCIIString newWithASCIICharacters:"PST"
                                                                   length:3] autorelease];
   strings[ i++] = [[_MulleObjC11LengthASCIIString newWithASCIICharacters:"PST"
                                                                   length:3] autorelease];
   strings[ i++] = [[_MulleObjC15LengthASCIIString newWithASCIICharacters:"PST"
                                                                   length:3] autorelease];
#endif
   strings[ i++] = [[_MulleObjCTinyASCIIString newWithASCIICharacters:"PST"
                                                                   length:3] autorelease];
   strings[ i++] = [[_MulleObjCGenericASCIIString newWithASCIICharacters:"PST"
                                                                   length:3] autorelease];
   strings[ i++] = [[_MulleObjCAllocatorASCIIString newWithASCIICharactersNoCopy:"PST"
                                                                   length:3
                                                                allocator:NULL] autorelease];
   strings[ i++] = [[_MulleObjCSharedASCIIString newWithASCIICharactersNoCopy:"PST"
                                                                       length:3
                                                                sharingObject:nil] autorelease];
   strings[ i++] = [[_MulleObjCAllocatorZeroTerminatedASCIIString newWithZeroTerminatedASCIICharactersNoCopy:"PST"
                                                                                     length:3
                                                                                  allocator:NULL] autorelease];
   strings[ i++] = [[_MulleObjCGenericUTF16String newWithUTF16Characters:pst16
                                                                  length:3] autorelease];
   strings[ i++] = [[_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:pst16
                                                                   length:3
                                                                allocator:NULL] autorelease];
   strings[ i++] = [[_MulleObjCSharedUTF16String newWithUTF16CharactersNoCopy:pst16
                                                                       length:3
                                                                sharingObject:nil] autorelease];

   strings[ i++] = [[_MulleObjCGenericUTF32String newWithUTF32Characters:pst32
                                                                   length:3] autorelease];
   strings[ i++] = [[_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:pst32
                                                                   length:3
                                                                allocator:NULL] autorelease];

   strings[ i++] = [[_MulleObjCSharedUTF32String newWithUTF32CharactersNoCopy:pst32
                                                                       length:3
                                                                sharingObject:nil] autorelease];

   n = i;
   for( i = 0; i < n; i++)
      printf( "%s len=%ld \"%s\"\n",
                  [NSStringFromClass( [strings[ i] class]) UTF8String],
                  (unsigned long) [strings[ i] length],
                  [strings[ i] UTF8String]);

   // check hash equality
   for( i = 0; i < n; i++)
      for( j = i + 1; j < n; j++)
         if( [strings[ i] hash] != [strings[ j] hash])
            abort();

   // check string equality
   for( i = 0; i < n; i++)
      for( j = i + 1; j < n; j++)
         if( ! [strings[ i] isEqual:strings[ j]])
            abort();
   return( 0);
}
