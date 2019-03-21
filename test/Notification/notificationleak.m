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

@end



void   post_notifications( NSNotificationCenter *center, id object)
{
   [center postNotificationName:@"Sender"
                         object:object
                       userInfo:nil];
}



void   test_name( void)
{
   NSNotificationCenter   *center;
   Class                  receiver;

   printf( "%s\n", __FUNCTION__);

   receiver = [Receiver class];
   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:receiver
                 selector:@selector( receiveNameNotification:)
                     name:@"Sender"
                   object:nil];
      post_notifications( center, [Receiver class]);
      [center removeObserver:receiver
                        name:@"Blender"
                      object:nil];
      post_notifications( center, [Receiver class]);
      [center removeObserver:receiver
                        name:@"Sender"
                      object:nil];
      post_notifications( center, [Receiver class]);

      [center release];
   }
}


int   main( void)
{
   NSNotificationCenter   *center;

   test_name();
   return( 0);
}
