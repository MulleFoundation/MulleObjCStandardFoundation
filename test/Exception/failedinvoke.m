#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
# pragma message "this test does not work with Apple Foundation"
#else
# import <MulleObjC/MulleObjC.h>
#endif


//
// just checking what happens if a NSThread is started but never joined.
// valgrind will flag a lost stack from pthread_create which is not our
// problem.
//
@interface Foo : NSObject
@end


@implementation Foo

- (id) function:(id) arg
{
   printf( "%s\n", __PRETTY_FUNCTION__);
   return( nil);
}

@end

//
@interface Bar : NSObject
@end


@implementation Bar
@end


int main( void)
{
   Foo        *foo;
   Bar        *bar;
   NSThread   *thread;

   [NSThread mulleSetMainThreadWaitsAtExit:YES];

   @autoreleasepool
   {
      foo = [Foo object];
      bar = [Bar object];

      @try
      {
         thread = [[[NSThread alloc] initWithTarget:foo
                                           selector:@selector( wrongFunction:)
                                             object:bar] autorelease];
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
