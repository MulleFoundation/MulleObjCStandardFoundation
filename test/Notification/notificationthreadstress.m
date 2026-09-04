#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void  sleep( int);


static int   is_slow_environment( void)
{
   if( getenv( "MULLE_TEST_VALGRIND"))
      return( 1);
#ifdef __linux__
   {
      FILE   *f;
      char   line[ 256];

      f = fopen( "/proc/self/maps", "r");
      if( f)
      {
         while( fgets( line, sizeof( line), f))
            if( strstr( line, "vgpreload"))
            {
               fclose( f);
               return( 1);
            }
         fclose( f);
      }
   }
#endif
   return( 0);
}

//#define N_OBJECTS    1
//#define N_OBSERVERS  1
//#define N_THREADS    16

// #define N_OBJECTS    100
// #define N_OBSERVERS  10
// #define N_THREADS    256

// Under valgrind we only exercise the code paths, not stress test. A
// cooperative scheduler makes many threads + large counts brutally slow.
#ifdef __APPLE__
#define N_THREADS      ((NSUInteger) (is_slow_environment() ? 2 : 4))
#define N_OBJECTS      ((NSUInteger) (is_slow_environment() ? 50 : 100))
#define N_OBSERVERS    ((NSUInteger) (is_slow_environment() ? 50 : 100))
#else
#define N_THREADS      ((NSUInteger) (is_slow_environment() ? 2 : 16))
#define N_OBJECTS      ((NSUInteger) (is_slow_environment() ? 50 : 1000))
#define N_OBSERVERS    ((NSUInteger) (is_slow_environment() ? 50 : 1000))
#endif


@interface Foo : NSObject <MulleObjCThreadSafe>
@end


@implementation Foo

- (void) receiveNameNotification:(NSNotification *) notification
{
}


- (void) receiveObjectNotification:(NSNotification *) notification
{
}


- (void) receiveNameObjectNotification:(NSNotification *) notification
{
}


- (void) receiveAnyNotification:(NSNotification *) notification
{
}


static void   add_observer( NSNotificationCenter *center, id observer, int type, id object)
{
   switch( type & 0x3)
   {
   case 0 :
      [center addObserver:observer
                 selector:@selector( receiveNameNotification:)
                     name:@"NotificationName"
                   object:nil];
   case 1 :
      [center addObserver:observer
                 selector:@selector( receiveObjectNotification:)
                     name:nil
                   object:object];
   case 2 :
      [center addObserver:observer
                 selector:@selector( receiveNameObjectNotification:)
                     name:@"NotificationName"
                   object:object];
   case 3 :
      [center addObserver:observer
                 selector:@selector( receiveAnyNotification:)
                     name:nil
                   object:nil];
   }
}


+ (void) testWithObjects:(NSArray *) objects
{
   NSNotificationCenter   *center;
   NSUInteger             i;
   Foo                    *foo;

   center = [NSNotificationCenter defaultCenter];

   for( i = 0; i < N_OBSERVERS; i++)
   {
     add_observer( center,
                   [objects objectAtIndex:rand() % N_OBJECTS],
                   rand() & 0x3,
                   [objects objectAtIndex:rand() % N_OBJECTS]);
   }

   for( i = 0; i < N_OBJECTS; i++)
   {
      foo = [objects objectAtIndex:i];
      [center removeObserver:foo];
   }
}

@end


int  main( int argc, char  *argv[])
{
   NSMutableArray   *objects;
   NSUInteger       i;
   NSUInteger       n_threads;
   Foo              *foo;

   n_threads = (argc == 2) ? atoi( argv[ 1]) : N_THREADS;

   objects = [NSMutableArray array];
   for( i = 0; i < N_OBJECTS; i++)
   {
      foo = [Foo instance];
      [objects addObject:foo];
   }

   for( i = 0; i < n_threads; i++)
   {
      [NSThread detachNewThreadSelector:@selector( testWithObjects:)
                               toTarget:[Foo class]
                             withObject:[NSArray arrayWithArray:objects]];
   }

   mulle_fprintf( stderr, "WAITING\n");
   while( [NSThread mulleIsMultiThreaded])
      sleep( 1);

   mulle_fprintf( stderr, "DONE\n");
   return( 0);
}

