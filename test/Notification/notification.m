#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


// more or less just a leak check
int   main( void)
{
   NSNotification   *notification;
   id               object;
   NSString         *name;
   NSDictionary     *userInfo;

   // avoid TPS objects since they don't leak
   name     = [[@"ThisIsMyNotification" mutableCopy] autorelease];
   object   = [[@"ThisIsMyObject" mutableCopy] autorelease];
   userInfo = [NSMutableDictionary dictionary];

   notification = [NSNotification notificationWithName:name
                                                object:object
                                              userInfo:userInfo];

   if( ! [[notification name] isEqualToString:name])
      return( 1);
   if( [notification object] != object)
      return( 1);
   if( ! [[notification userInfo] isEqual:userInfo])
      return( 1);
   return( 0);
}
