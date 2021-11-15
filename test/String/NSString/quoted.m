#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


static void   test( char *s)
{
   NSString   *value;
   NSString   *quoted;

   value = [[[NSString alloc] initWithBytes:s
                                     length:-1
                                   encoding:NSUTF8StringEncoding] autorelease];

   quoted = [value mulleQuotedString];
   mulle_printf( "%s -> %@\n", s, quoted);
}


int   main( void)
{
   test( "a\xc2\xad");  // octal 0302 0255
   test( "\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe");  // emojis
   test( "");
   test( "a");
   test( "a\" \t \"b");
   return( 0);
}
