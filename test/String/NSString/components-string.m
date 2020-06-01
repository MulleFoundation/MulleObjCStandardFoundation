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
   NSArray    *array;
   NSString   *component;

   array = [s componentsSeparatedByString:separator];
   printf( "%s\"%s\" separated by \"%s\":",
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
   static unichar  _comma[] = { ',', 0 }; /* UTF16 feet, hash, euro, dice */
   static unichar  _commacomma[] = { ',', ',', 0 };
   static unichar  _UTF32Unichar[] = { 0x0001f463, 0x00000023,0x000020ac, 0x0001f3b2, 0};   /* UTF32 feet, hash, euro, dice */
   unichar * params_1[] =
   {
      _comma,
      _commacomma,
      _UTF32Unichar
   };
   NSString  *separator;
   NSString  *string;
   unichar   *s;
   size_t    length;
   size_t    i;

//   {
//      static unichar  x[] = { 0x0001f463, 0x0001f462, '0', 0 };   /* UTF32 feet */
//
//      string    = [[[NSString alloc] initWithCharacters:&x[ 0]
//                                                 length:3] autorelease];
//      separator = [[[NSString alloc] initWithCharacters:&x[0]
//                                                 length:2] autorelease];
//
//      test( string, separator);
//      return( 0);
//   }

//  test( @"0,1,,2,,,,3,,,,4", @",,");
//  test( @"1,2", @",");

   test( @"", @"");

NS_DURING
   test( @"0,1,2,3", nil);
NS_HANDLER
   printf( "%s\n", [[localException name] UTF8String]);
NS_ENDHANDLER

   test( @"0,1,2,3", @",");
   test( @"0,1,2,3", @",,");
   test( @"0,1,,2,,,,3,,,,4", @",");
   test( @"0,1,,2,,,,3,,,,4", @",,");

   for( i = 0; i < sizeof( params_1) / sizeof(unichar *); i++)
   {
      s      = params_1[ i];
      length = s ? mulle_unichar_strlen( s) : 0;

      separator = [[[NSString alloc] initWithCharacters:s
                                                 length:length] autorelease];


      test( @"", separator);
      test( separator, separator);

      test( @"0", separator);

      string = [NSString stringWithFormat:@"%@%@", separator, @"0"];
      test( string, separator);

      string = [NSString stringWithFormat:@"%@%@", @"0", separator];
      test( string, separator);

      string = [NSString stringWithFormat:@"%@%@", separator, separator];
      test( string, separator);


      string = [NSString stringWithFormat:@"%@%@%@", separator, separator, separator];
      test( string, separator);

      string = [NSString stringWithFormat:@"%@%@%@", separator, separator, @"0"];
      test( string, separator);

      string = [NSString stringWithFormat:@"%@%@%@", separator, @"0", separator];
      test( string, separator);

      string = [NSString stringWithFormat:@"%@%@%@", @"0", separator, separator];
      test( string, separator);


      // "01" is boring and avoided
      string = [NSString stringWithFormat:@"%@%@%@%@", separator, separator, separator, separator];
      test( string, separator);
      string = [NSString stringWithFormat:@"%@%@%@%@", separator, separator, separator, @"0"];
      test( string, separator);
      string = [NSString stringWithFormat:@"%@%@%@%@", separator, separator, @"0", separator];
      test( string, separator);
      string = [NSString stringWithFormat:@"%@%@%@%@", separator, @"0", separator, @"1"];
      test( string, separator);
      string = [NSString stringWithFormat:@"%@%@%@%@", @"0", separator, @"1", separator];
      test( string, separator);
      string = [NSString stringWithFormat:@"%@%@%@%@", @"0", separator, separator, @"1"];
      test( string, separator);
   }

   return( 0);
}
