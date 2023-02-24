#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


static NSStringEncoding   encodings[] =
{
   NSASCIIStringEncoding,
   NSUTF8StringEncoding,
   NSISOLatin1StringEncoding,
   NSUTF16BigEndianStringEncoding,
   NSUTF16LittleEndianStringEncoding,
   NSUTF32BigEndianStringEncoding,
   NSUTF32LittleEndianStringEncoding
};


static void   _test( NSString *string, NSStringEncoding encoding, BOOL withBOM, BOOL withZero)
{
   id   data;

   @try
   {
      data = [string mulleDataUsingEncoding:encoding
                              prefixWithBOM:withBOM
                          terminateWithZero:withZero];
   }
   @catch( id e)
   {
      data = @"conversion not possible";
   }

   mulle_printf( "%s%s%s \"%@\" : %@\n",
                    MulleStringEncodingUTF8String( encoding),
                    withBOM ? " BOM" : "",
                    withZero ? " \\0" : "",
                    string,
                    data);
}


static void   test( NSString *string)
{
   int   i;

   for( i = 0; i < sizeof( encodings) / sizeof( encodings[ 0]); i++)
   {
      _test( string, encodings[ i], NO, NO);
      _test( string, encodings[ i], NO, YES);
      _test( string, encodings[ i], YES, NO);
      _test( string, encodings[ i], YES, YES);
      printf( "\n");
   }
   printf( "\n");
}


static void   testUTF8( char *s)
{
   test( @( s));
}


static void   testUTF32( mulle_utf32_t *s)
{
   NSString  *string;

   string = [[[NSString alloc] initWithCharactersNoCopy:s
                                                 length:-1
                                           freeWhenDone:NO] autorelease];
   test( string);
}


int   main( void)
{
   mulle_utf32_t   killer[] = { 65279, 47177, 29938, 18497, 0 };
   mulle_utf32_t   utf15[]  = { 23589, 21787, 15173, 15909, 0 };
   mulle_utf32_t   big[]    = { 0x0000c67c, 0x000e49d5, 0x000c3154, 0x000d303d, 0 };
   mulle_utf32_t   zero[]   = { 0, 87, 21, 51, 0 };

   testUTF8( "VfL Bochum 1848");
   testUTF32( killer);
   testUTF32( zero);
   testUTF32( utf15);
   testUTF32( big);

   return( 0);
}
