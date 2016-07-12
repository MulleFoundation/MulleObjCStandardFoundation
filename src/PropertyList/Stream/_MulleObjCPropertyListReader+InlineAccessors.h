/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  _MulleObjCPropertyListReader+InlineAccessors.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, __MyCompanyName__ 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCPropertyListReader.h"

#import "_MulleObjCUTF8StreamReader+InlineAccessors.h"


static inline void   _MulleObjCPropertyListReaderBookmark( _MulleObjCPropertyListReader *self)
{
   _MulleObjCUTF8StreamReaderBookmark( (_MulleObjCUTF8StreamReader *) self);
}    


static inline MulleObjCMemoryRegion   _MulleObjCPropertyListReaderBookmarkedRegion( _MulleObjCPropertyListReader *self)
{
   return( _MulleObjCUTF8StreamReaderBookmarkedRegion( (_MulleObjCUTF8StreamReader *) self));
}    


static inline long   _MulleObjCPropertyListReaderCurrentUTF32Character( _MulleObjCPropertyListReader *self)
{
   return( _MulleObjCUTF8StreamReaderCurrentUTF32Character( (_MulleObjCUTF8StreamReader *) self));
}      


static inline long   __NSPropertyListReaderNextUTF32Character( _MulleObjCPropertyListReader *self)
{
   return( __NSUTF8StreamReaderNextUTF32Character( (_MulleObjCUTF8StreamReader *) self));
}     


static inline long   _MulleObjCPropertyListReaderNextUTF32Character( _MulleObjCPropertyListReader *self)
{
   return( _MulleObjCUTF8StreamReaderNextUTF32Character( (_MulleObjCUTF8StreamReader *) self));
}      


static inline void   _MulleObjCPropertyListReaderConsumeCurrentUTF32Character( _MulleObjCPropertyListReader *self)
{
   _MulleObjCUTF8StreamReaderConsumeCurrentUTF32Character( (_MulleObjCUTF8StreamReader *) self);
}


static inline long   _MulleObjCPropertyListReaderSkipWhite( _MulleObjCPropertyListReader *self)
{
   return( _MulleObjCUTF8StreamReaderSkipWhite( (_MulleObjCUTF8StreamReader *) self));
}


static inline long   _MulleObjCPropertyListReaderSkipNonWhite( _MulleObjCPropertyListReader *self)
{
   return( _MulleObjCUTF8StreamReaderSkipNonWhite( (_MulleObjCUTF8StreamReader *) self));
}


static inline long   _MulleObjCPropertyListReaderSkipUntil( _MulleObjCPropertyListReader *self, long c)
{
   return( _MulleObjCUTF8StreamReaderSkipUntil( (_MulleObjCUTF8StreamReader *) self, c));
}


static inline long   _MulleObjCPropertyListReaderSkipUntilUnquoted( _MulleObjCPropertyListReader *self, long c)
{
   return( _MulleObjCUTF8StreamReaderSkipUntilUnquoted( (_MulleObjCUTF8StreamReader *) self, c));
}


static inline long   _MulleObjCPropertyListReaderSkipUntilTrue( _MulleObjCPropertyListReader *self, BOOL (*f)( long))
{
   return( _MulleObjCUTF8StreamReaderSkipUntilTrue( (_MulleObjCUTF8StreamReader *) self, f));
}


static inline void   *_MulleObjCPropertyListReaderFail( _MulleObjCPropertyListReader *self, NSString *format, ...)
{
   va_list   args;
   
   va_start( args, format);
   
   _MulleObjCUTF8StreamReaderFailV( (_MulleObjCUTF8StreamReader *) self, format, args);
    
   va_end( args);

   return( NULL);
}
