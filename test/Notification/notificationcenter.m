#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


@implementation Receiver : NSObject

+ (void) receiveNameNotification:(NSNotification *) notification
{
   printf( "nameNotification: %s %s\n",
                  [[notification name] UTF8String],
                  [notification object] == nil ? "nil" : "self");
}


+ (void) receiveObjectNotification:(NSNotification *) notification
{
   printf( "objectNotification: %s %s\n",
                  [[notification name] UTF8String],
                  [notification object] == nil ? "nil" : "self");
}


+ (void) receiveNameObjectNotification:(NSNotification *) notification
{
   printf( "nameObjectNotification: %s %s\n",
                  [[notification name] UTF8String],
                  [notification object] == nil ? "nil" : "self");
}


+ (void) receiveAnyNotification:(NSNotification *) notification
{
   printf( "anyNotification: %s %s\n",
                  [[notification name] UTF8String],
                  [notification object] == nil ? "nil" : "self");
}


@end


void   test_leak( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   // simple leak checker
   @autoreleasepool
   {
      center = [NSNotificationCenter new];
      [center release];
   }
}


void   test_leak2( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center postNotificationName:@"Sender"
                            object:nil
                          userInfo:nil];
      [center release];
   }
}



void   post_notifications( NSNotificationCenter *center, id object)
{
   [center postNotificationName:@"Blender"
                         object:nil
                       userInfo:nil];
   [center postNotificationName:@"Sender"
                         object:nil
                       userInfo:nil];
   [center postNotificationName:@"Blender"
                         object:object
                       userInfo:nil];
   [center postNotificationName:@"Sender"
                         object:object
                       userInfo:nil];
}



void   test_name( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveNameNotification:)
                     name:@"Sender"
                   object:nil];
      post_notifications( center, [Receiver class]);
      [center removeObserver:[Receiver class]
                        name:@"Sender"
                      object:nil];
      post_notifications( center, [Receiver class]);

      [center release];
   }
}

void   test_name2( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveNameNotification:)
                     name:@"Sender"
                   object:nil];
      post_notifications( center, [Receiver class]);
      [center removeObserver:[Receiver class]];
      post_notifications( center, [Receiver class]);

      [center release];
   }
}



void   test_object( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveObjectNotification:)
                     name:nil
                   object:[Receiver class]];
      post_notifications( center, [Receiver class]);
      [center removeObserver:[Receiver class]
                        name:nil
                      object:[Receiver class]];
      post_notifications( center, [Receiver class]);

      [center release];
   }
}


void   test_object_name( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveNameObjectNotification:)
                     name:@"Sender"
                   object:[Receiver class]];
      post_notifications( center, [Receiver class]);
      [center removeObserver:[Receiver class]
                        name:@"Sender"
                      object:[Receiver class]];
      post_notifications( center, [Receiver class]);

      [center release];
   }
}


void   test_any( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveAnyNotification:)
                     name:nil
                   object:nil];
      post_notifications( center, [Receiver class]);
      [center removeObserver:[Receiver class]
                        name:nil
                      object:nil];
      post_notifications( center, [Receiver class]);

      [center release];
   }
}



void   test_multiple( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveNameNotification:)
                     name:@"Sender"
                   object:nil];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveObjectNotification:)
                     name:nil
                   object:[Receiver class]];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveNameObjectNotification:)
                     name:@"Sender"
                   object:[Receiver class]];
      [center addObserver:[Receiver class]
                 selector:@selector( receiveAnyNotification:)
                     name:nil
                   object:nil];
      post_notifications( center, [Receiver class]);
      [center removeObserver:[Receiver class]];
      post_notifications( center, [Receiver class]);

      [center release];
   }
}




int   main( void)
{
   NSNotificationCenter   *center;


   test_leak();
   test_leak2();
   test_name();
   test_name2();
   test_object();
   test_object_name();
   test_any();
   test_multiple();
   return( 0);
}
