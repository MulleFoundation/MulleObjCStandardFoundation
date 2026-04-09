//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"

@interface NSData (Forward)
- (NSString *) debugDescription;
@end


int main( int argc, const char * argv[])
{
   static char text[] = "Kybernetik ist nach ihrem Begruender Norbert Wiener die Wissenschaft der Steuerung und Regelung von Maschinen, lebenden Organismen und sozialen Organisationen und wurde auch mit der Formel \"die Kunst des Steuerns\" beschrieben.";
   NSData    *data;

   data = [NSData dataWithBytes:text
                         length:sizeof( text)];

   mulle_printf( "%s\n", [[data description] UTF8String]);
   mulle_printf( "---\n");
   mulle_printf( "%s\n", [[data debugDescription] UTF8String]);

   return( 0);
}
