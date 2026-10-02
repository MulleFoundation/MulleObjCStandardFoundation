#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <string.h>


//
// The NSMutableOrderedSet guards throw NSException. The exception machinery
// lives in MulleObjCStandardFoundation, so the throwing tests have to live
// here (the MulleObjCContainerFoundation test cannot catch them).
//
@interface Foo : NSObject
{
   char   _name[ 32];
}
+ (instancetype) foo:(const char *) s;
- (char *) UTF8String;
@end


@implementation Foo

+ (instancetype) foo:(const char *) s
{
   Foo   *o;

   o = [Foo instance];
   strncpy( o->_name, s, sizeof( o->_name) - 1);
   return( o);
}

- (char *) UTF8String
{
   return( _name);
}

@end


static void   test_object_at_index( NSMutableOrderedSet *set)
{
   @try
   {
      [set objectAtIndex:0];
      mulle_printf( "objectAtIndex 0: no exception\n");
   }
   @catch( NSException *exception)
   {
      mulle_printf( "objectAtIndex 0: %s\n", [[exception name] UTF8String]);
   }
}


static void   test_insert_at_index( NSMutableOrderedSet *set)
{
   @try
   {
      [set insertObject:[Foo foo:"a"]
                atIndex:1];
      mulle_printf( "insertObject@1: no exception\n");
   }
   @catch( NSException *exception)
   {
      mulle_printf( "insertObject@1: %s\n", [[exception name] UTF8String]);
   }
}


static void   test_remove_at_index( NSMutableOrderedSet *set)
{
   @try
   {
      [set removeObjectAtIndex:0];
      mulle_printf( "removeObjectAtIndex 0: no exception\n");
   }
   @catch( NSException *exception)
   {
      mulle_printf( "removeObjectAtIndex 0: %s\n", [[exception name] UTF8String]);
   }
}


static void   test_replace_at_index( NSMutableOrderedSet *set)
{
   @try
   {
      [set replaceObjectAtIndex:0
                  withObject:[Foo foo:"a"]];
      mulle_printf( "replaceObjectAtIndex 0: no exception\n");
   }
   @catch( NSException *exception)
   {
      mulle_printf( "replaceObjectAtIndex 0: %s\n", [[exception name] UTF8String]);
   }
}


static void   test_add_nil( NSMutableOrderedSet *set)
{
   @try
   {
      [set addObject:nil];
      mulle_printf( "addObject:nil: no exception\n");
   }
   @catch( NSException *exception)
   {
      mulle_printf( "addObject:nil: %s\n", [[exception name] UTF8String]);
   }
}


static void   test_get_objects_range( NSMutableOrderedSet *set)
{
   id   buf[ 4];

   @try
   {
      [set getObjects:buf
                range:NSRangeMake( 0, 3)];
      mulle_printf( "getObjects range 0,3 of 2: no exception\n");
   }
   @catch( NSException *exception)
   {
      mulle_printf( "getObjects range 0,3 of 2: %s\n", [[exception name] UTF8String]);
   }
}


int   main( void)
{
   @autoreleasepool
   {
      NSMutableOrderedSet   *set;

      set = [NSMutableOrderedSet orderedSet];
      test_object_at_index( set);
      test_insert_at_index( set);
      test_remove_at_index( set);
      test_replace_at_index( set);
      test_add_nil( set);

      set = [NSMutableOrderedSet orderedSet];
      [set addObject:[Foo foo:"first"]];
      [set addObject:[Foo foo:"second"]];
      test_get_objects_range( set);
   }
   return( 0);
}
