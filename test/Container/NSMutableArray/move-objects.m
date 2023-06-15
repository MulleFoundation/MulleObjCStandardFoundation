#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>

#include <unistd.h>


@interface Foo : NSObject
{
   char   _name[ 32];
}

- (id) initWithLetter:(char) s;
- (char *) UTF8String;

@end


@implementation Foo

- (id) initWithLetter:(char) c;
{
   sprintf( _name, "%c", c);
   return( self);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other isKindOfClass:[Foo class]])
      return( NO);
   return( ! strcmp( self->_name,  ((Foo *) other)->_name));
}


- (NSUInteger) hash
{
   return( mulle_data_hash( mulle_data_make( self->_name, strlen( self->_name))));
}


- (char *) UTF8String
{
   return( _name);
}


@end



static NSMutableArray  *mutable_array_of_foos( NSUInteger n)
{
   NSMutableArray   *array;
   Foo              *foo;
   NSUInteger       i;

   array = [NSMutableArray array];
   for( i = 'A'; i < 'Z' && i < 'A' + n; i++)
   {
      foo = [[[Foo alloc] initWithLetter:i] autorelease]; // 10 % duplicates
      [array addObject:foo];
   }
   return( array);
}


static void   print_array_of_foos( NSArray *array)
{
   NSUInteger   i, n;
   char         *sep;

   n = [array count];
   if( ! n)
   {
      mulle_printf( "()");
      return;
   }
   mulle_printf( "(");
   for( sep=" ", i = 0; i < n; i++, sep = ", ")
      mulle_printf( "%s%s", sep, [[array objectAtIndex:i] UTF8String]);
   mulle_printf( " )");
}


void  test( NSUInteger count, NSRange range, NSUInteger index)
{
   NSMutableArray   *a;

   a = mutable_array_of_foos( count);

   print_array_of_foos( a);
   mulle_printf( " -> [%td,%td] @%td -> ",
                     range.location, range.length, index);
   fflush( stdout);

   @try
   {
      [a mulleMoveObjectsInRange:range
                         toIndex:index];
   }
   @catch( id e)
   {
      printf( "*exception*\n");
      return;
   }
   print_array_of_foos( a);
   mulle_printf( "\n");
}


#define N  5

int   main( int argc, char *argv[])
{
   NSUInteger       i;
   NSRange          range;
   NSUInteger       index;

#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      _exit( 1);
#endif

   for( i = 0; i < N; i++)
      for( range.length = 0; range.length <= N; range.length++)
         for( range.location = 0; range.location <= N; range.location++)
            for( index = 0; index <= i; index++)
               test( i, range, index);

   return( 0);
}
