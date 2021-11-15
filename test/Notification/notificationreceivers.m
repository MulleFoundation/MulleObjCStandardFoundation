#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


@implementation Receiver : NSObject

+ (void) receiveNameNotification:(NSNotification *) notification
{
   printf( "-[%s receiveNameNotification:] %s %s\n",
                  [[[self class] description] UTF8String],
                  [[notification name] UTF8String],
                  [[notification object] UTF8String]);
}


+ (void) receiveObjectNotification:(NSNotification *) notification
{
   printf( "-[%s receiveObjectNotification:] %s %s\n",
                  [[[self class] description] UTF8String],
                  [[notification name] UTF8String],
                  [[notification object] UTF8String]);
}


+ (void) receiveNameObjectNotification:(NSNotification *) notification
{
   printf( "-[%s receiveNameObjectNotification:] %s %s\n",
                  [[[self class] description] UTF8String],
                  [[notification name] UTF8String],
                  [[notification object] UTF8String]);
}


+ (void) receiveAnyNotification:(NSNotification *) notification
{
   printf( "-[%s receiveAnyNotification:] %s %s\n",
                  [[[self class] description] UTF8String],
                  [[notification name] UTF8String],
                  [[notification object] UTF8String]);
}


@end


@implementation Receiver1 : Receiver
@end

@implementation Receiver2 : Receiver
@end

@implementation Receiver3 : Receiver
@end

@implementation Receiver4 : Receiver
@end


void   post_notifications( NSNotificationCenter *center, id object, id other)
{
   printf( "%s %s\n", __FUNCTION__, [other UTF8String]);

   [center postNotificationName:@"Blender"
                         object:other
                       userInfo:nil];
   [center postNotificationName:@"Sender"
                         object:other
                       userInfo:nil];
   [center postNotificationName:@"Blender"
                         object:object
                       userInfo:nil];
   [center postNotificationName:@"Sender"
                         object:object
                       userInfo:nil];
}



void   test_multiple( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);
   id   object;

   object = [Receiver class];

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[Receiver1 class]
                 selector:@selector( receiveNameNotification:)
                     name:nil
                   object:object];
      [center addObserver:[Receiver2 class]
                 selector:@selector( receiveNameNotification:)
                     name:@"Sender"
                   object:nil];
      [center addObserver:[Receiver3 class]
                 selector:@selector( receiveNameNotification:)
                     name:@"Blender"
                   object:object];
      [center addObserver:[Receiver4 class]
                 selector:@selector( receiveNameNotification:)
                     name:@"Sender"
                   object:object];

      post_notifications( center, object, @"1");

      [center removeObserver:[Receiver4 class]];
      printf( "removed Receiver4\n");

      post_notifications( center, object, @"2");

      [center removeObserver:[Receiver2 class]];
      printf( "removed Receiver2\n");

      post_notifications( center, object, @"3");

      [center removeObserver:[Receiver1 class]];
      printf( "removed Receiver1\n");

      post_notifications( center, object, @"4");

      [center removeObserver:[Receiver3 class]];
      printf( "removed Receiver3\n");

      [center release];
   }
}


int   main( void)
{
   NSNotificationCenter   *center;

   test_multiple();
   return( 0);
}
