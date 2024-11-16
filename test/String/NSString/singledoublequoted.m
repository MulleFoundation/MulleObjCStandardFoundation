#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


static void   test( NSString *cmdline)
{
   NSArray       *array;
   NSString      *s;
   unsigned int  i;

   array = [cmdline mulleComponentsSeparatedByWhitespaceWithSingleAndDoubleQuoting];

   mulle_printf( "\"%@\":\n", [cmdline mulleDoubleQuoteEscapedString]);

   i = 0;
   for( s in array)
      mulle_printf( "   #%d: \"%@\"\n", i++, [s mulleDoubleQuoteEscapedString]);

   mulle_printf( "\n");
}


int  main( int argc, char *argv[])
{
   test( @"mulle-sourcetree walk --in-order --dedupe-mode url-filename --eval-node --no-bequeath --marks dependency,share-shirk 'printf \"%s;%s;%s\\n\" \"${NODE_ADDRESS}\" \"${NODE_EVALED_BRANCH}\" \"${NODE_EVALED_URL}\"'");
   test( @"'VfL \"Bochum\" 1848'");
   test( @"\"VfL 'Bochum' 1848\"");

   return( 0);
}
