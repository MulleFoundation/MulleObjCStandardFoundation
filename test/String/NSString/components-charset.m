//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif



static void  _test( char *title, NSString *s, NSString *separator)
{
   NSArray          *array;
   NSString         *component;
   NSCharacterSet   *set;

   set = [NSCharacterSet characterSetWithCharactersInString:separator];
   array = [s componentsSeparatedByCharactersInSet:set];
   printf( "%s \"%s\" separated by characterset \"%s\":",
            title,
            [s UTF8String],
            [separator UTF8String]);

   for( component in array)
      printf( " \"%s\"", [component UTF8String]);
   printf( "\n");
}


static void  test( NSString *s, NSString *separator)
{
   _test( "", s, separator);
   _test( "mutable ", [[s mutableCopy] autorelease], separator);
}


int main( int argc, const char * argv[])
{
   static unichar  _comma[]        = { ',', 0 };
   static unichar  _commadot[]     = { ',', '.', 0 };
   static unichar  _UTF32Unichar[] = { 0x0001f463, 0 };   /* UTF32 feet */
   unichar * params_1[] =
   {
      _comma,
      _commadot,
      _UTF32Unichar,
   };
   NSString   *setChars;
   NSString   *string;
   unichar    *s;
   size_t     length;
   size_t     i;
   size_t     index[ 4];
   NSString   *strings[ 4];

//   {
//      static unichar  x[] = { 0x0001f463, 0x0001f462, '0', 0 };   /* UTF32 feet */
//
//      string   = [[[NSString alloc] initWithCharacters:&x[ 0]
//                                                length:3] autorelease];
//      setChars = [[[NSString alloc] initWithCharacters:&x[0]
//                                                length:2] autorelease];
//
//      test( string, setChars);
//      return( 0);
//   }

   for( i = 0; i < sizeof( params_1) / sizeof( unichar *); i++)
   {
      s        = params_1[ i];
      length   = s ? mulle_unichar_strlen( s) : 0;

      setChars = [[[NSString alloc] initWithCharacters:s
                                                length:length] autorelease];

      strings[ 0] = @"0";
      strings[ 1] = @"1";
      if( length > 1)
         strings[ 2] = [[[NSString alloc] initWithCharacters:&s[ 1]
                                                      length:1] autorelease];
      else
         strings[ 2] = @"2";
      strings[ 3] = [[[NSString alloc] initWithCharacters:&s[ 0]
                                                   length:1] autorelease];

      for( index[ 3] = 0; index[ 3] < 4; index[ 3]++)
         for( index[ 2] = 0; index[ 2] < 4; index[ 2]++)
            for( index[ 1] = 0; index[ 1] < 4; index[ 1]++)
               for( index[ 0] = 0; index[ 0] < 4; index[ 0]++)
               {
                  string = [NSString stringWithFormat:@"%@%@%@%@", strings[ index[ 0]],
                                                                   strings[ index[ 1]],
                                                                   strings[ index[ 2]],
                                                                   strings[ index[ 3]]];
                  test( string, setChars);
               }
   }

   return( 0);
}
