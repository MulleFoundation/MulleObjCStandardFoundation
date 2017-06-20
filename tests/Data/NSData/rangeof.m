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

//#import "MulleStandaloneObjCFoundation.h"


static void   print_range( NSRange range)
{
   if( range.location == NSNotFound)
      printf( "NSNotFound,%ld\n", (long) range.length);
   else
      printf( "%ld,%ld\n", (long) range.location, (long) range.length);
}


void  test_data( NSData *data, NSData *search, NSUInteger options, NSRange range)
{
   @try
   {
      range = [data rangeOfData:search
                        options:options
                          range:range];
      print_range( range);
   }
   @catch( NSException *localException)
   {
      printf( "exception\n");
   }
}


void  test_4( NSData *data, NSData *search, NSRange range)
{
   test_data( data, search, 0, range);
   test_data( data, search, NSDataSearchBackwards, range);
   test_data( data, search, NSDataSearchAnchored, range);
   test_data( data, search, NSDataSearchAnchored|NSDataSearchBackwards, range);
}


void  test( NSData *data, NSData *search)
{
   printf( "\n%.*s\n", (int) [search length], (char *) [search bytes]);
   test_4( data, search, NSMakeRange( 0, [data length]));
   test_4( data, search, NSMakeRange( 1, [data length] - 1));
   test_4( data, search, NSMakeRange( 0, [data length] - 1));
   test_4( data, search, NSMakeRange( 1, [data length] - 2));
}


int main( int argc, const char * argv[])
{
   static char text[] = "Kybernetik ist nach ihrem Begruender Norbert Wiener die Wissenschaft der Steuerung und Regelung von Maschinen, lebenden Organismen und sozialen Organisationen und wurde auch mit der Formel \"die Kunst des Steuerns\" beschrieben.";
   static char kybernetik[] = "Kybernetik";
   static char die[] = "die";
   static char beschrieben[] = "beschrieben.";
   static char norbert[] = "Norbert";
   NSData    *textData;
   NSData    *kybernetikData;
   NSData    *dieData;
   NSData    *beschriebenData;
   NSData    *norbertData;

   textData       = [NSData dataWithBytes:text
                                   length:sizeof( text) - 1];
   kybernetikData = [NSData dataWithBytes:kybernetik
                                   length:sizeof( kybernetik) - 1];
   dieData        = [NSData dataWithBytes:die
                                   length:sizeof( die) - 1];
   beschriebenData = [NSData dataWithBytes:beschrieben
                                   length:sizeof( beschrieben) - 1];
   norbertData    = [NSData dataWithBytes:norbert
                                   length:sizeof( norbert) - 1];

//   test_data( textData, beschriebenData, NSDataSearchBackwards, NSMakeRange( 0, [textData length]));

   test( textData, kybernetikData);
   test( textData, dieData);
   test( textData, beschriebenData);
   test( textData, norbertData);
   test( textData, [NSData data]);
   test( [NSData data], kybernetikData);

   return( 0);
}
