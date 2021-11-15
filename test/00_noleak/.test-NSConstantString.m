#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>


//
// noleak checks for alloc/dealloc/finalize
// and also load/unload initialize/deinitialize
// if the test environment sets MULLE_OBJC_PEDANTIC_EXIT
//
static void   test_noleak()
{
   NSConstantString  *obj;

   @autoreleasepool
   {
      @try
      {
         obj = [[NSConstantString new] autorelease];
         if( ! obj)
         {
            printf( "failed to allocate\n");
         }
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] UTF8String]);
      }
   }
}



int   main( int argc, char *argv[])
{
#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      return( 1);
#endif

   test_noleak();

   return( 0);
}
