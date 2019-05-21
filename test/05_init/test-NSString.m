#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>
#include <stdlib.h>
#if defined(__unix__) || defined(__unix) || (defined(__APPLE__) && defined(__MACH__))
# include <unistd.h>
#endif


static int   test_i_init_with_characters_length_( void)
{
   NSString *obj;
   static unichar  _EmptyUnichar[] = { 0 };
   static unichar  _1848Unichar[]  = { '1', '8', '4', '8', 0 };
   static unichar  _VfLUnichar[]   = { 'V', 'f', 'L', ' ', 'B', 'o', 'c', 'h', 'u', 'm', 0 };
   static unichar  _UTF16Unichar[] = { 0xd83d, 0xdc63, 0x0023, 0x20ac, 0xd83c, 0xdfb2, 0 }; /* UTF16 feet, hash, euro, dice */
   static unichar  _UTF32Unichar[] = { 0x0001f463, 0x00000023,0x000020ac, 0x0001f3b2, 0};   /* UTF32 feet, hash, euro, dice */
   unichar * params_1[] =
   {
      NULL,
      _EmptyUnichar,
      _1848Unichar,
      _VfLUnichar,
      _UTF16Unichar,
      _UTF32Unichar
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSString alloc] initWithCharacters:params_1[ i_1]
                                               length:params_1[ i_1] ? mulle_utf16_strlen( params_1[ i_1]) : 0] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}


static int   test_i_init_with_ut_f8_string_( void)
{
   NSString *obj;
   char * params_1[] =
   {
      NULL,
      "",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "1848",
      "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSString alloc] initWithUTF8String:params_1[ i_1]] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}


static int   test_i_init_with_characters_no_copy_length_free_when_done_( void)
{
   NSString *obj;
   static unichar  _EmptyUnichar[] = { 0 };
   static unichar  _1848Unichar[]  = { '1', '8', '4', '8', 0 };
   static unichar  _VfLUnichar[]   = { 'V', 'f', 'L', ' ', 'B', 'o', 'c', 'h', 'u', 'm', 0 };
   static unichar  _UTF16Unichar[] = { 0xd83d, 0xdc63, 0x0023, 0x20ac, 0xd83c, 0xdfb2, 0 }; /* UTF16 feet, hash, euro, dice */
   static unichar  _UTF32Unichar[] = { 0x0001f463, 0x00000023,0x000020ac, 0x0001f3b2, 0};   /* UTF32 feet, hash, euro, dice */
   unichar * params_1[] =
   {
      NULL,
      _EmptyUnichar,
      _1848Unichar,
      _VfLUnichar,
      _UTF16Unichar,
      _UTF32Unichar
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;


   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSString alloc] initWithCharactersNoCopy:params_1[ i_1]
                                                    length:params_1[ i_1] ? mulle_utf16_strlen( params_1[ i_1]) : 0
                                              freeWhenDone:NO] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
      }
   }
   return( 0);
}


static int   test_i_init_with_bytes_no_copy_length_encoding_free_when_done_( void)
{
   NSString *obj;
   void * params_1[] =
   {
      NULL,
      "",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "1848",
      "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;
   NSUInteger params_2[] =
   {
      0,
      1,
      1848,
      LONG_MAX
   };
   unsigned int   i_2;
   unsigned int   n_2 = 4;
   NSStringEncoding params_3[] =
   {
      NSUTF8StringEncoding,
      NSUTF16StringEncoding,
      NSASCIIStringEncoding
   };
   unsigned int   i_3;
   unsigned int   n_3 = 3;
   BOOL params_4[] =
   {
      YES,
      NO
   };
   unsigned int   i_4;
   unsigned int   n_4 = 2;
   char           *s;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
         for( i_3 = 0; i_3 < n_3; i_3++)
            for( i_4 = 0; i_4 < n_4; i_4++)
            {
               @try
               {
                  s = params_1[ i_1];
                  if( params_4[ i_4] && s)
                     s = mulle_allocator_strdup( &mulle_stdlib_allocator, s);
                  obj = [[[NSString alloc] initWithBytesNoCopy:s
                                                        length:s ? strlen( s) : 0
                                                      encoding:params_3[ i_3]
                                                  freeWhenDone:params_4[ i_4]] autorelease];
                  printf( "%s\n", [obj cStringDescription]);
               }
               @catch( NSException *localException)
               {
                  printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
               }
            }
   return( 0);
}


static int   test_i_init_with_data_encoding_( void)
{
   NSString *obj;
   NSData * params_1[] =
   {
      nil,
      [NSData data],
      [NSData dataWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" length:20], // emoji comet, snowman, thumbs-up brown
      [NSData dataWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" length:19] // broken as its truncated
   };
   unsigned int   i_1;
   unsigned int   n_1 = 3;
   NSStringEncoding params_2[] =
   {
      NSUTF8StringEncoding,
      NSUTF16StringEncoding,
      NSASCIIStringEncoding
   };
   unsigned int   i_2;
   unsigned int   n_2 = 3;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSString alloc] initWithData:params_1[ i_1]
                                         encoding:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


static int   test_i_init_with_bytes_length_encoding_( void)
{
   NSString *obj;
   void * params_1[] =
   {
      NULL,
      "",
      "VfL Bochum",
      "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." /* > 256 chars */,
      "1848",
      "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;
   NSStringEncoding params_3[] =
   {
      NSUTF8StringEncoding,
      NSUTF16StringEncoding,
      NSASCIIStringEncoding
   };
   unsigned int   i_3;
   unsigned int   n_3 = 3;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_3 = 0; i_3 < n_3; i_3++)
      {
         @try
         {
            obj = [[[NSString alloc] initWithBytes:params_1[ i_1]
                         length:params_1[ i_1] ? strlen( params_1[ i_1]) : 0
                         encoding:params_3[ i_3]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}


#if 0
static int   test_i_init_with_format_vararg_list_( void)
{
   NSString *obj;
   NSString * params_1[] =
   {
      nil,
      [[@"" mutableCopy] autorelease],
      [[@"VfL Bochum" mutableCopy] autorelease],
      [[@"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." mutableCopy] autorelease] /* > 256 chars */,
      [[@"1848" mutableCopy] autorelease],
      [[[NSString alloc] initWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */ length:20 encoding:NSUTF8StringEncoding] autorelease]
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSString alloc] initWithFormat:params_1[ i_1]
                         arguments:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}
#endif


#if 0
static int   test_i_init_with_format_mulle_vararg_list_( void)
{
   NSString *obj;
   NSString * params_1[] =
   {
      nil,
      [[@"" mutableCopy] autorelease],
      [[@"VfL Bochum" mutableCopy] autorelease],
      [[@"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." mutableCopy] autorelease] /* > 256 chars */,
      [[@"1848" mutableCopy] autorelease],
      [[[NSString alloc] initWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */ length:20 encoding:NSUTF8StringEncoding] autorelease]
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;

   for( i_1 = 0; i_1 < n_1; i_1++)
      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         @try
         {
            obj = [[[NSString alloc] initWithFormat:params_1[ i_1]
                         mulleVarargList:params_2[ i_2]] autorelease];
            printf( "%s\n", [obj cStringDescription]);
         }
         @catch( NSException *localException)
         {
            printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
         }
      }
   return( 0);
}
#endif

static int   test_i_init_with_string_( void)
{
   NSString *obj;
   NSString * params_1[] =
   {
      nil,
      [[@"" mutableCopy] autorelease],
      [[@"VfL Bochum" mutableCopy] autorelease],
      [[@"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur." mutableCopy] autorelease] /* > 256 chars */,
      [[@"1848" mutableCopy] autorelease],
      [[[NSString alloc] initWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */ length:20 encoding:NSUTF8StringEncoding] autorelease]
   };
   unsigned int   i_1;
   unsigned int   n_1 = 6;

   for( i_1 = 0; i_1 < n_1; i_1++)
   {
      @try
      {
         obj = [[[NSString alloc] initWithString:params_1[ i_1]] autorelease];
         printf( "%s\n", [obj cStringDescription]);
      }
      @catch( NSException *localException)
      {
         printf( "Threw a %s exception\n", [[localException name] cStringDescription]);
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
   errors += run_test( test_i_init_with_characters_length_, "-initWithCharacters:length:");
   errors += run_test( test_i_init_with_ut_f8_string_, "-initWithUTF8String:");
   errors += run_test( test_i_init_with_characters_no_copy_length_free_when_done_, "-initWithCharactersNoCopy:length:freeWhenDone:");
   errors += run_test( test_i_init_with_bytes_no_copy_length_encoding_free_when_done_, "-initWithBytesNoCopy:length:encoding:freeWhenDone:");
   errors += run_test( test_i_init_with_data_encoding_, "-initWithData:encoding:");
   errors += run_test( test_i_init_with_bytes_length_encoding_, "-initWithBytes:length:encoding:");
//   errors += run_test( test_i_init_with_format_vararg_list_, "-initWithFormat:arguments:");
//   errors += run_test( test_i_init_with_format_mulle_vararg_list_, "-initWithFormat:mulleVarargList:");
   errors += run_test( test_i_init_with_string_, "-initWithString:");

   mulle_testallocator_cancel();
   return( errors ? 1 : 0);
}
