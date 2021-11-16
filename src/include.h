#ifndef mulle_objc_standard_foundation_include_h__
#define mulle_objc_standard_foundation_include_h__

/* This is a central include file to keep dependencies out of the library
   C files. It is usally included by .h files only.

   The advantage is that now .c and .h files become motile. They can
   be moved to other projects and don't need to be edited. Also less typing...

   Therefore it is important that this file is called "include.h" and
   not "MulleObjCStandardFoundation-include.h" to keep the #include statements in the
   library code uniform.

   The C-compiler will pick up the nearest one.
*/

/* Include the header file automatically generated by c-sourcetree-update.
   Here the prefix is harmless and serves disambiguation. If you have no
   sourcetree, then you don't need it.
 */

#include "_MulleObjCStandardFoundation-include.h"

#ifndef MULLE_OBJC_STANDARD_FOUNDATION_EXTERN_GLOBAL
# define MULLE_OBJC_STANDARD_FOUNDATION_EXTERN_GLOBAL MULLE_C_EXTERN_GLOBAL
#endif


/* You can add some more include statements here */

/* add some C headers from MulleObjC, for the benefit of C code
   But avoid that, when compiling ObjC (it would be too early)
 */

#ifndef __MULLE_OBJC__

//
// minimal makes no sense here, all our .c files are linked to
// the runtime via exceptions
//
# include <MulleObjC/mulle-objc.h>
#endif

#include <mulle-container/mulle-container.h>

#endif
