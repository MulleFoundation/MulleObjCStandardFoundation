//
//  test-NSLocale-availableLocaleIdentifiers.m
//  MulleObjCStandardFoundation
//
//  Regression test: +availableLocaleIdentifiers is declared on NSLocale, but
//  is only implemented by the platform categories (NSLocale( Posix),
//  NSLocale( Windows) ...). A build without such a backend therefore used to
//  abort with an "unknown method" universe error. NSLocale must answer a
//  usable list no matter which backend is linked in, so a platform agnostic
//  default is asserted here.
//
#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


int   main( int argc, char *argv[])
{
   NSArray      *identifiers;
   NSString     *identifier;
   NSUInteger   i;
   NSUInteger   n;
   int          ok;

#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      _exit( 1);
#endif

   @autoreleasepool
   {
      identifiers = [NSLocale availableLocaleIdentifiers];

      ok = identifiers && [identifiers count];
      if( ok)
      {
         n = [identifiers count];
         for( i = 0; i < n; i++)
         {
            identifier = [identifiers objectAtIndex:i];
            if( ! [identifier isKindOfClass:[NSString class]] || ! [identifier length])
            {
               ok = 0;
               break;
            }
         }
      }

      mulle_printf( "available-locale-identifiers=%s\n", ok ? "YES" : "NO");
   }

   return( ok ? 0 : 1);
}
