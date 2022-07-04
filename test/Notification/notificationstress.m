#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif

// if we use gmalloc this can run for 30 minutes or so

#define N_OBJECTS    1000
#define N_OBSERVERS  1000

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
      foo = [Foo object];
      [objects addObject:foo];
   }

   @autoreleasepool
   {
      NSNotificationCenter   *center;

      center = [[NSNotificationCenter new] autorelease];
      // create to 10000 entries for observation

//      foo = [objects objectAtIndex:0];
//      fprintf( stderr, "#1: %p\n", foo);
//      [center addObserver:foo
//                 selector:@selector( receiveNameNotification:)
//                     name:@"NotificationName"
//                   object:[objects objectAtIndex:1]];
//      fprintf( stderr, "#2\n");
//      [center dump];
//
//      foo = [objects objectAtIndex:1];
//      fprintf( stderr, "#3: %p\n", foo);
//      [center addObserver:foo
//                 selector:@selector( receiveNameObjectNotification:)
//                     name:@"NotificationName"
//                   object:[objects objectAtIndex:1]];
//      fprintf( stderr, "#4\n");
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
//         fprintf( stderr, "#5.%ld: %p\n", (long) i, foo);
         [center removeObserver:foo];
//         fprintf( stderr, "#6.%ld\n", (long) i);
//         [center dump];
      }
   }


   return( 0);
}
