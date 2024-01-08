#ifdef __MULLE_OBJC__
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
# import <MulleObjC/MulleObjCDebug.h>
#else
# import <Foundation/Foundation.h>
#endif



@implementation Foo
@end


@implementation Foo ( Category)
@end


// just don't leak anything
int   main( void)
{
#ifdef __MULLE_OBJC__
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
   {
      MulleObjCHTMLDumpUniverseToTmp();
      MulleObjCDotdumpUniverseToTmp();
      return( 1);
   }
#endif

   return( 0);
}
