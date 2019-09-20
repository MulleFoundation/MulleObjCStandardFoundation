#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


@implementation A : NSObject

+ (void) notification:(NSNotification *) notification
{
   printf( "A\n");
}

@end


@implementation B : NSObject

+ (void) notification:(NSNotification *) notification
{
   printf( "B\n");
}

@end


@implementation C : NSObject

+ (void) notification:(NSNotification *) notification
{
   printf( "C\n");
}

@end



void   test_abc( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[C class]
                 selector:@selector( notification:)
                     name:@"Any"
                   object:nil];
      [center addObserver:[B class]
                 selector:@selector( notification:)
                     name:@"Any"
                   object:nil];
      [center addObserver:[A class]
                 selector:@selector( notification:)
                     name:@"Any"
                   object:nil];
      [center postNotificationName:@"Any"
                            object:nil];
      [center release];
   }
}


void   test_cba( void)
{
   NSNotificationCenter   *center;

   printf( "%s\n", __FUNCTION__);

   @autoreleasepool
   {
      // simple leak checker
      center = [NSNotificationCenter new];
      [center addObserver:[A class]
                 selector:@selector( notification:)
                     name:@"Any"
                   object:nil];
      [center addObserver:[B class]
                 selector:@selector( notification:)
                     name:@"Any"
                   object:nil];
      [center addObserver:[C class]
                 selector:@selector( notification:)
                     name:@"Any"
                   object:nil];
      [center postNotificationName:@"Any"
                            object:nil];
      [center release];
   }
}



int   main( void)
{
   NSNotificationCenter   *center;

   test_abc();
   test_cba();
   return( 0);
}
