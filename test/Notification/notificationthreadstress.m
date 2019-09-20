#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif

extern void  sleep( int);


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
   NSMutableArray         *objects;
   NSUInteger             i;
   Foo                    *foo;

   objects = [NSMutableArray array];
   for( i = 0; i < N_OBJECTS; i++)
   {
      foo = [Foo instantiate];
      [objects addObject:foo];
   }

   for( i = 0; i < 16; i++)
   {
      [NSThread detachNewThreadSelector:@selector( testWithObjects:)
                               toTarget:[Foo class]
                             withObject:objects];
   }

   while( [NSThread mulleIsMultiThreaded])
      sleep( 1);
   return( 0);
}

