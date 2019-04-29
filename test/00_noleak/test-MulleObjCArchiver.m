#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>


//
// noleak checks for alloc/dealloc/finalize
// and also load/unload initialize/deinitialize
// if the test environment sets MULLE_OBJC_PEDANTIC_EXIT
//
static int   test_noleak()
{
   MulleObjCArchiver  *obj;

   @autoreleasepool
   {
      @try
      {
         obj = [[MulleObjCArchiver new] autorelease];
         if( ! obj)
         {
            printf( "failed to allocate\n");
            return( 1);
         }
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         return( 1);
      }
   }
   return( 0);
}



int   main( int argc, char *argv[])
{
#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      return( 1);
#endif

   return( test_noleak());
}
