//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#ifdef __MULLE_OBJC__
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


int main(int argc, const char * argv[])
{
   @try
   {
      @try
      {
         [NSException raise:NSGenericException
                     format:@"no reason"];
      }
      @catch( NSException *localException)
      {
         @throw( localException);
      }
   }
   @catch( NSException *localException)
   {
      printf( "passed\n");
   }
   return( 0);
}
