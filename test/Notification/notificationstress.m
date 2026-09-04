#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// if we use gmalloc this can run for 30 minutes or so

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

// Under valgrind we only exercise the code paths, we do not stress test.
#define N_OBJECTS      ((NSUInteger) (is_slow_environment() ? 50 : 1000))
#define N_OBSERVERS    ((NSUInteger) (is_slow_environment() ? 50 : 1000))

@interface Foo : NSObject
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

@end




void  add_observer( NSNotificationCenter *center, id observer, int type, id object)
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



int   main( void)
{
   NSNotificationCenter   *center;
   NSMutableArray         *objects;
   NSUInteger             i;
   Foo                    *foo;

   objects = [NSMutableArray array];
   for( i = 0; i < N_OBJECTS; i++)
   {
      foo = [Foo instance];
      [objects addObject:foo];
   }

   @autoreleasepool
   {
      NSNotificationCenter   *center;

      center = [[NSNotificationCenter new] autorelease];
      // create to 10000 entries for observation

//      foo = [objects objectAtIndex:0];
//      mulle_fprintf( stderr, "#1: %p\n", foo);
//      [center addObserver:foo
//                 selector:@selector( receiveNameNotification:)
//                     name:@"NotificationName"
//                   object:[objects objectAtIndex:1]];
//      mulle_fprintf( stderr, "#2\n");
//      [center dump];
//
//      foo = [objects objectAtIndex:1];
//      mulle_fprintf( stderr, "#3: %p\n", foo);
//      [center addObserver:foo
//                 selector:@selector( receiveNameObjectNotification:)
//                     name:@"NotificationName"
//                   object:[objects objectAtIndex:1]];
//      mulle_fprintf( stderr, "#4\n");
//      [center dump];


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
//         mulle_fprintf( stderr, "#5.%ld: %p\n", (long) i, foo);
         [center removeObserver:foo];
//         mulle_fprintf( stderr, "#6.%ld\n", (long) i);
//         [center dump];
      }
   }


   return( 0);
}
