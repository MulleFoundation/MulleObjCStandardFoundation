#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


int   main( int argc, char *argv[])
{
   NSDictionary   *dict;
   NSString       *s;
   NSError        *error;

#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      _exit( 1);
#endif

   [NSError mulleClear];

   // check fallback to errno
   [NSError mulleSetErrorDomain:@"Whatever"];
   errno = ENOENT;

   error = [NSError mulleExtract];
   if( ! error)
      return( 1);

   error = [NSError mulleExtract];
   if( error)
      return( 2);

   // other way around should work too
   errno = ENOENT;
   [NSError mulleSetErrorDomain:@"Whatever"];


   error = [NSError mulleExtract];
   if( ! error)
      return( 3);

   error = [NSError mulleExtract];
   if( error)
      return( 4);

   return( 0);
}
