//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


static void  enumerate( NSDictionary *dict, NSMutableArray *array)
{
   id   key;

   for( key in dict)
   {
      if( ! array)
         printf( "%ld\n", (long) [key integerValue]);
      else
         [array addObject:key];
   }
}


static void   print_key( id key, void *egal)
{
   printf( "%ld\n", (long) [key integerValue]);
}


int main(int argc, const char * argv[])
{
   NSDictionary     *dict;
   NSNumber         *key;
   NSInteger        i;
   NSMutableArray   *array;

   dict = [NSDictionary dictionary];
   enumerate( dict, nil);

   key  = [NSNumber numberWithInt:1848];
   dict = [NSDictionary dictionaryWithObject:@"VfL Bochum"
                                      forKey:key];
   enumerate( dict, nil);

   array = [NSMutableArray array];
   dict  = [NSMutableDictionary dictionary];
   for( i = 0; i < 1000; i++)
   {
      key = [NSNumber numberWithInteger:i];
      [dict setObject:@"VfL Bochum"
               forKey:key];
   }
   enumerate( dict, array);

   // output sorted, because the order is somewhat random (dependent on
   // hash algorithm used)
   [array sortUsingSelector:@selector( compare:)];
   [array mulleForEachObjectCallFunction:(BOOL (*)( id, void *)) print_key
                                argument:NULL
                                 preempt:MullePreemptNever];
   return( 0);
}
