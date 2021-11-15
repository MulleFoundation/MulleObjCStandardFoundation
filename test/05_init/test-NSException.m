#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


static int   test_i_init_with_name_reason_user_info_( void)
{
   NSException *obj;
   NSString * params_1[] =
   {
      [[@"@1848" mutableCopy] autorelease],
      [[@"" mutableCopy] autorelease],
      [[@"VfL Bochum" mutableCopy] autorelease],
      [[@"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." mutableCopy] autorelease] /* > 256 chars */,
      [[[NSString alloc] initWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */ length:20 encoding:NSUTF8StringEncoding] autorelease],
      nil
   };
   unsigned int   i_1;
   unsigned int   n_1 = sizeof( params_1) / sizeof( NSString *);
   NSString * params_2[] =
   {
      [[@"@1848" mutableCopy] autorelease],
      [[@"" mutableCopy] autorelease],
      [[@"VfL Bochum" mutableCopy] autorelease],
      [[@"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." mutableCopy] autorelease] /* > 256 chars */,
      [[[NSString alloc] initWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */ length:20 encoding:NSUTF8StringEncoding] autorelease],
      nil
   };
   unsigned int   i_2;
   unsigned int   n_2 = sizeof( params_2) / sizeof( NSString *);
   NSDictionary * params_3[] =
   {
      [NSDictionary dictionary],
      [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"a", @"2", @"b", @1848, @"c", nil],
      nil
   };
   unsigned int   i_3;
   unsigned int   n_3 = sizeof( params_3) / sizeof( NSDictionary *);

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
         for( i_3 = 0; i_3 < n_3; i_3++)
         {
            @try
            {
               obj = [[[NSException alloc] initWithName:params_1[ i_1]
                            reason:params_2[ i_2]
                            userInfo:params_3[ i_3]] autorelease];
               printf( "%s\n", [obj UTF8String]);
            }
            @catch( NSException *localException)
            {
               printf( "Threw a %s exception\n", [[localException name] UTF8String]);
            }
         }
   return( 0);
}



static int   run_test( int (*f)( void), char *name)
{
   mulle_testallocator_discard();  //  w
   @autoreleasepool                //  i
   {                               //  l  l
      printf( "%s\n", name);       //  l  e  c
      if( (*f)())                  //     a  h
         return( 1);               //     k  e
   }                               //        c
   mulle_testallocator_reset();    //        k
   return( 0);
}


int   main( int argc, char *argv[])
{
   int   errors;

#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      _exit( 1);
#endif
   errors = 0;
   errors += run_test( test_i_init_with_name_reason_user_info_, "-initWithName:reason:userInfo:");

   mulle_testallocator_cancel();
   return( errors ? 1 : 0);
}
