#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif


int   main( void)
{
   NSMutableDictionary  *mutableDict;
   NSDictionary         *dict;
   NSString             *key;
   id                   value;
   unsigned int         i;

   // Test 1: NSMutableDictionary - objectForKey during enumeration
   mutableDict = [NSMutableDictionary dictionary];
   [mutableDict setObject:@"value1" forKey:@"KEY1"];
   [mutableDict setObject:@"value2" forKey:@"KEY2"];
   [mutableDict setObject:@"value3" forKey:@"KEY3"];

   i = 0;
   for( key in mutableDict)
   {
      // This objectForKey: during enumeration might trigger mutation detection
      value = [mutableDict objectForKey:key];
      if( ! value)
      {
         mulle_fprintf( stderr, "FAIL: mutableDict key %s value missing\n", [key UTF8String]);
         return( 1);
      }
      ++i;
   }

   if( i != 3)
   {
      mulle_fprintf( stderr, "FAIL: mutableDict enumerated %u items, expected 3\n", i);
      return( 1);
   }

   // Test 2: NSDictionary - objectForKey during enumeration
   dict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"value1", @"KEY1",
            @"value2", @"KEY2",
            @"value3", @"KEY3",
            nil];

   i = 0;
   for( key in dict)
   {
      // This objectForKey: during enumeration might trigger mutation detection
      value = [dict objectForKey:key];
      if( ! value)
      {
         mulle_fprintf( stderr, "FAIL: dict key %s value missing\n", [key UTF8String]);
         return( 1);
      }
      ++i;
   }

   if( i != 3)
   {
      mulle_fprintf( stderr, "FAIL: dict enumerated %u items, expected 3\n", i);
      return( 1);
   }

   mulle_fprintf( stdout, "PASS\n");
   return( 0);
}
