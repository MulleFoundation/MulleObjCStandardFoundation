/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  mulle_sprintfObjectFunctions.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#include <mulle_sprintf/mulle_sprintf.h>


int   mulle_string_sprintf_object_conversion( struct mulle_buffer *buffer,
                                              struct mulle_sprintf_formatconversioninfo *info,
                                              struct mulle_sprintf_argumentarray *arguments,
                                              int argc);
                                    
mulle_sprintf_argumenttype_t  mulle_string_sprintf_get_object_argumenttype( struct mulle_sprintf_formatconversioninfo *info);

extern struct mulle_sprintf_conversion     mulle_string_sprintf_object_functions;

void  _mulle_sprintf_register_object_functions( struct mulle_sprintf_conversion *tables);

