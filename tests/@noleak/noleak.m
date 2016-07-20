#ifdef __MULLE_OBJC__
# import <MulleObjCFoundation/MulleObjCFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif



@implementation Foo
@end


@implementation Foo ( Category)
@end


// just don't leak anything
main()
{
   return( 0);
}
