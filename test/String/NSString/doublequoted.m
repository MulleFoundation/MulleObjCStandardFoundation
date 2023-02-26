#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


@implementation NSString( SingleQuoted)

- (NSString *) mulleSingleQuoteEscapedString
{
   NSString  *s;

   s = [self stringByReplacingOccurrencesOfString:@"'"
                                       withString:@"'''"];
   return( s);
}

@end



static void   test( NSString *cmdline)
{
   NSArray       *array;
   NSString      *s;
   unsigned int  i;

   array = [cmdline mulleComponentsSeparatedByWhitespaceWithDoubleQuoting];

   mulle_printf( "'%@':\n", [cmdline mulleSingleQuoteEscapedString]);

   i = 0;
   for( s in array)
      mulle_printf( "   #%d: '%@'\n", i++, [s mulleSingleQuoteEscapedString]);

   mulle_printf( "\n");
}


int  main( int argc, char *argv[])
{
   test( @"\"VfL\"\" Bochum\"\" 1848\""); // one string

   test( @"VfL Bochum 1848");
   test( @"\"\\\"");
   test( @"\\");  // broken stuff

   test( @"\"a\\\"\\x\\\\b\"");
   test( @"\"a\\\"b\"");
   test( @"\"a\\\"\"");

   test( @"\" a \" \" b \"");

   test( @"  \"a\"  \"b\"  ");
   test( @"\"a\"  \"b\"  ");
   test( @"  \"a\"  \"b\"");
   test( @"\"a\"  \"b\"");
   test( @"\"a\" \"b\"  ");
   test( @"  \"a\" \"b\"");

   test( @" \"a\" \"b\" ");
   test( @"\"a\" \"b\" ");
   test( @" \"a\" \"b\"");

   test( @"\"a\" \"b\"");
   test( @"\"a\"");
   test( @"");
   test( @"\"\"");

   test( @"  a  b  ");
   test( @"a  b  ");
   test( @"  a  b");
   test( @"a  b");
   test( @"a b  ");
   test( @"  a b");

   test( @" a b ");
   test( @"a b ");
   test( @" a b");

   test( @"a b");
   test( @"a");
   test( @"");

   return( 0);
}
