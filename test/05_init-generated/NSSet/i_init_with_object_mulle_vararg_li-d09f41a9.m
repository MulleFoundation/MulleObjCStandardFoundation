#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


//
// ObjC-function is mulle_vararg_list
//
@interface Foo : NSObject

+ (void) callWithObject:(id) obj, ...;

@end


@implementation Foo

+ (void) callWithObject:(id) first, ...
{
   mulle_vararg_list   args;
   NSSet  *obj;

   @try
   {
      mulle_vararg_start( args, first);
      obj = [[[NSSet alloc] initWithObject:first
                                  mulleVarargList:args] autorelease];
      printf( "%s\n", [obj cStringDescription]);
      mulle_vararg_end( args);
   }
   @catch( NSException *localException)
   {
      printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
   }
}

@end


static int   test_i_init_with_object_mulle_vararg_list_( void)
{
   [Foo callWithObject:@"nix", nil];
   [Foo callWithObject:@"%@", @1, nil];
   [Foo callWithObject:@"%@ %@ %@ %@ %@", @1, @2, @3, @4, @5, nil];
   return( 0);
}


int   main( int argc, char *argv[])
{
   int   rval;

   rval = test_i_init_with_object_mulle_vararg_list_();
   return( rval);
}

