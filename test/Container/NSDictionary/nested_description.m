#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


int main(int argc, const char * argv[])
{

   @autoreleasepool
   {
      printf( "%s\n", [[@{} description] UTF8String]);
   }
   @autoreleasepool
   {
      printf( "%s\n", [[@{ @"a": @"1" } description] UTF8String]);
   }
   @autoreleasepool
   {
      printf( "%s\n", [[@{ @"a": @"1", @"b": @"2" } description] UTF8String]);
   }
   @autoreleasepool
   {
      printf( "%s\n", [[@{ @"a": @"1", @"b": @{ @"c": @"3", @"d": @"4" } } description] UTF8String]);
   }

   @autoreleasepool
   {
      printf( "%s\n", [[@[] description] UTF8String]);
   }
   @autoreleasepool
   {
      printf( "%s\n", [[@[ @"a" ] description] UTF8String]);
   }
   @autoreleasepool
   {
      printf( "%s\n", [[@[ @"a", @"b" ]  description] UTF8String]);
   }
   @autoreleasepool
   {
      printf( "%s\n", [[@[ @"a", @"b", @[ @"c", @"d" ]] description] UTF8String]);
   }

   @autoreleasepool
   {
      printf( "%s\n", [[@[ @"a", @"b", @{ @"c": @"3", @"d": @"4" } ] description] UTF8String]);
   }
   @autoreleasepool
   {
      printf( "%s\n", [[@{ @"a": @"1", @"b": @[ @"c", @"d" ] } description] UTF8String]);
   }


   @autoreleasepool
   {
      printf( "%s\n", [[@{ @"a": @{ @"b": @{ @"c": @[ @"1", @" 2", @3 ] }}} description] UTF8String]);
   }

   return( 0);
}
