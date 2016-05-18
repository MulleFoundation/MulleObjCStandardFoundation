//
//  NSValue+NSString.m
//  MulleObjCFoundation
//
//  Created by Nat! on 16.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSValue.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c dependencies


@implementation NSValue (NSString)

- (NSString *) _debugContentsDescription
{
   struct mulle_buffer   buffer;
   char                  tmp[ 512];
   NSUInteger            size;
   void                  *value;
   NSString              *s;
   char                  *type;
   
   type = [self objCType];
   NSGetSizeAndAlignment( type, &size, NULL);
   if( size >= 256)
   {
      s = [NSString stringWithFormat:@"\"%s\" %ld bytes", type, size];
      return( s);
   }
   value = alloca( size);
   [self getValue:value];
   
   mulle_buffer_init_with_static_bytes( &buffer, tmp, sizeof( tmp), NULL);
   mulle_buffer_dump_hex( &buffer, value, size, 0, 0x5); // no counter. no ASCII
   mulle_buffer_add_byte( &buffer, 0);
   s = [NSString stringWithFormat:@"\"%s\" %s", type, mulle_buffer_get_bytes( &buffer)];
   mulle_buffer_done( &buffer);
   return( s);
}

@end

