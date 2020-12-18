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


void   test( NSData *data, NSData *sep)
{
   NSArray   *array;

   array = [data mulleComponentsSeparatedByData:sep];
   printf( "%s\n", [[array description] UTF8String]);
}


int   main( int argc, const char * argv[])
{
   static char   text[] = "Kybernetik ist nach ihrem Begruender "
                          "Norbert Wiener "
                          "die Wissenschaft der Steuerung und Regelung "
                          "von Maschinen, lebenden Organismen "
                          "und sozialen Organisationen und wurde auch "
                          "mit der Formel \"die Kunst des Steuerns\" "
                          "beschrieben.";
   static char   text2[] = "die Pest\n"
                           "die Panik\n"
                           "die Politik\n";
   static char   text3[] = "die Pest\n"
                           "die Panik\n"
                           "die Politik";
   static char   lf[] = "\n";
   static char   die[] = "die";
   NSData    *textData;
   NSData    *text2Data;
   NSData    *text3Data;
   NSData    *lfData;
   NSData    *dieData;

   textData = [NSData dataWithBytes:text
                             length:sizeof( text) - 1];
   text2Data = [NSData dataWithBytes:text2
                              length:sizeof( text2) - 1];
   text3Data = [NSData dataWithBytes:text3
                              length:sizeof( text3) - 1];
   lfData   = [NSData dataWithBytes:lf
                             length:sizeof( lf) - 1];
   dieData  = [NSData dataWithBytes:die
                             length:sizeof( die) - 1];

   test( textData, dieData);
   test( textData, lfData);

   test( text2Data, nil);
   test( text2Data, [NSData data]);
   test( [NSData data], text2Data);

   test( text2Data, dieData);
   test( text2Data, lfData);

   test( text3Data, lfData);

   return( 0);
}
