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
   [NSError mulleClearCurrentError];
   error = [NSError mulleCurrentError];
   if( error != nil)
      return( 1);

   s    = @"a";
   dict =  @{ @"foo": @"bar"};
   MulleObjCErrorSetCurrentError( s, 1848, dict);
   error = [NSError mulleCurrentError];
   if( error == nil)
      return( 1);

   [NSError mulleClearCurrentError];
   error = [NSError mulleCurrentError];
   if( error != nil)
      return( 1);

   // should be reclaimed
   s    = @"b";
   dict =  @{ @"Foo": @"bie"};
   MulleObjCErrorSetCurrentError( s, 1849, dict);

   return( 0);
}
