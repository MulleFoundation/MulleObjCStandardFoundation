#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
// just checking what happens if a NSThread is started but never joined
// valgrind will flag a lost stack from pthread_create which is not our
// problem.
///
@interface Foo : NSObject
@end


@implementation Foo


+ (id) method:(id) arg
{
   mulle_printf( "%s\n", __FUNCTION__);
   return( nil);
}

@end


int main( void)
{
   NSThread   *thread;

   [NSThread mulleSetMainThreadWaitsAtExit:YES];

   @autoreleasepool
   {
      @try
      {
         thread = [[NSThread instantiate] initWithTarget:[Foo class]
                                                selector:@selector( wrongMethod:)
                                                  object:nil];
         [thread mulleStart];
      }
      @catch( id exception)
      {
         // ignore
         mulle_fprintf( stderr, "Exception caught: %@", exception);
      }
   }

   return( 0);
}
