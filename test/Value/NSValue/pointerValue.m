#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#endif



static void print_bool( BOOL flag)
{
   printf( "%s\n", flag ? "YES" : "NO");
}



main()
{
   NSValue   *value;

   value = [NSValue valueWithPointer:(void *) INTPTR_MAX];
   print_bool( [value pointerValue] == (void *) INTPTR_MAX);

   value = [NSValue valueWithPointer:(void *) INTPTR_MIN];
   print_bool( [value pointerValue] == (void *) INTPTR_MIN);

   value = [NSValue valueWithPointer:(void *) 0];
   print_bool( [value pointerValue] == (void *) 0);

   value = [NSValue valueWithPointer:(void *) 1848];
   print_bool( [value pointerValue] == (void *) 1848);

   value = [NSValue valueWithPointer:(void *) -1848];
   print_bool( [value pointerValue] == (void *) -1848);
}
