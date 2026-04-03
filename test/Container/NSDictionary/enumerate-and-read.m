#import "import.h"

int main()
{
   NSMutableDictionary  *dict;
   NSEnumerator         *rover;
   NSString             *key;
   id                   value;
   int                  count;
   
   dict = [NSMutableDictionary dictionary];
   [dict setObject:@"value1" forKey:@"key1"];
   [dict setObject:@"value2" forKey:@"key2"];
   [dict setObject:@"value3" forKey:@"key3"];
   
   count = 0;
   rover = [dict keyEnumerator];
   while( key = [rover nextObject])
   {
      value = [dict objectForKey:key];  // This should NOT trigger mutation error
      mulle_printf("Key: %s, Value: %s\n", [key UTF8String], [value UTF8String]);
      count++;
   }
   
   mulle_printf("Enumerated %d items\n", count);
   
   return 0;
}
