/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  mulle_sprintf_ObjectFunctions.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "mulle_sprintf_object.h"

// other files in this library
#import "NSString.h"
#import "NSString+ClassCluster.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


#if MULLE_SPRINTF_VERSION < ((0 << 20) | (6 << 8) | 0)
# error "mulle_sprintf is too old"
#endif


@interface NSString( CString)

- (char *) cString;

@end


static int  _sprintf_object_conversion( struct mulle_buffer *buffer,
                                        struct mulle_sprintf_formatconversioninfo *info,
                                        struct mulle_sprintf_argumentarray *arguments,
                                        int argc)
{
   union mulle_sprintf_argumentvalue  v;
   char                               *s;

   assert( buffer);
   assert( info);
   assert( arguments);
   
   v = arguments->values[ argc];
   s = v.obj ? (char *) [[(id) v.obj description] UTF8String] : "(nil)";
   
   return( _mulle_sprintf_charstring_conversion( buffer, info, s));
}                   



static mulle_sprintf_argumenttype_t  sprintf_get_object_argumenttype( struct mulle_sprintf_formatconversioninfo *info)
{
   return( mulle_sprintf_object_argumenttype);
}


static struct mulle_sprintf_function   sprintf_object_function =
{
   sprintf_get_object_argumenttype,
   _sprintf_object_conversion
};


void   mulle_sprintf_register_object_functions( struct mulle_sprintf_conversion *tables)
{
   mulle_sprintf_register_functions( tables, &sprintf_object_function, _C_ID);
}


__attribute__((constructor))
static void  mulle_sprintf_register_default_object_functions()
{
   mulle_sprintf_register_object_functions( mulle_sprintf_get_defaultconversion());
}
   
