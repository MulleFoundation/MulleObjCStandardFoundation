//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#import <MulleObjC/NSDebug.h>


static void    clone_array( int n)
{
   NSData         *data;
   id             copy;
   id             obj;
   id             objects[ n];
   unsigned int   i;

   for( i = 0; i < n; ++i)
      objects[ i] = [NSNumber numberWithInt:i];

   obj = [NSArray arrayWithObjects:objects
                            count:n];

   data = [NSArchiver archivedDataWithRootObject:obj];
   copy = [NSUnarchiver unarchiveObjectWithData:data];
   if( [obj isEqual:copy])
      printf( "passed\n");
   else
      printf( "failed: %s != %s\n",
          [[obj description] UTF8String],
          [[copy description] UTF8String]);
}



int main(int argc, const char * argv[])
{
#ifdef __MULLE_OBJC__
   struct _mulle_objc_universe    *universe;

   universe = mulle_objc_global_get_universe( __MULLE_OBJC_UNIVERSEID__);
   if( __mulle_objc_universe_check( universe, MULLE_OBJC_RUNTIME_VERSION) != mulle_objc_universe_is_ok)
   {
      MulleObjCDotdumpUniverseToTmp();
      return( 1);
   }
#endif
   clone_array( 0);
   clone_array( 1);
   clone_array( 2);

   return( 0);
}
