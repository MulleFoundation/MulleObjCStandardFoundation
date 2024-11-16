#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
#include <mulle-testallocator/mulle-testallocator.h>
#include <stdio.h>


//
// noleak checks for alloc/dealloc/finalize
// and also load/unload initialize/deinitialize
// if the test environment sets MULLE_OBJC_PEDANTIC_EXIT
//
static void   test_noleak()
{
   NSArray  *obj;

   @autoreleasepool
   {
      @try
      {
         obj = [[NSArray new] autorelease];
         if( ! obj)
         {
            printf( "failed to allocate\n");
         }
      }
      @catch( NSException *exception)
      {
         printf( "Threw a %s exception\n", [[exception name] UTF8String]);
      }
   }
}


static void   test_i_class_for_coder()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray   *obj;
      Class     value;

      @try
      {
         obj = [[NSArray alloc] init];
         value = [obj classForCoder];
         printf( "%s\n", [NSStringFromClass( value) UTF8String]);
         [obj release];
      }
      @catch( NSException *exception)
      {
         printf( "Threw a %s exception\n", [[exception name] UTF8String]);
      }
   }
}


static void   test_i_sorted_array_using_descriptors_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray *value;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
      };
      unsigned int   i_1;
      unsigned int   n_1 = 2;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         @try
         {
            value = [obj sortedArrayUsingDescriptors:params_1[ i_1]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
         @catch( NSException *exception)
         {
            printf( "Threw a %s exception\n", [[exception name] UTF8String]);
         }
      }
      [obj release];
   }
}


static void   test_i_description()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSString *value;

      @try
      {
         obj = [[NSArray alloc] initWithObjects:@1, @2, @3, nil];
         value = [obj description];
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
         [obj release];
      }
      @catch( NSException *exception)
      {
         printf( "Threw a %s exception\n", [[exception name] UTF8String]);
      }
   }
}


static void   test_i_components_joined_by_string_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSString *value;
      NSString * params_1[] =
      {
         nil,
         @"",
         @"VfL Bochum",
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;

      obj = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", nil];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         @try
         {
            value = [obj componentsJoinedByString:params_1[ i_1]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
         @catch( NSException *exception)
         {
            printf( "Threw a %s exception\n", [[exception name] UTF8String]);
         }
      }
      [obj release];
   }
}


static void   test_c_array_with_retained_objects_count_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      id value;
      id params_1[] = { @"a", @"b", @"c" };

      @try
      {
         value = [NSArray mulleArrayWithRetainedObjects:params_1
                                                  count:3];
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      }
      @catch( NSException *exception)
      {
         printf( "Threw a %s exception\n", [[exception name] UTF8String]);
      }
   }
}


static void   test_c_array_with_objects_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      id value;

      value = [NSArray arrayWithObjects: @"whatever", @1, @{ @"a": @1 }, @[ @"a"], nil];
      printf( "%s\n", value ? [value UTF8String] : "*nil*");
   }
}


static void   test_c_array_with_object_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      id value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;

      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [NSArray arrayWithObject:params_1[ i_1]];
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      }
   }
}


static void   test_c_array()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      id value;

      value = [NSArray array];
      printf( "%s\n", value ? [value UTF8String] : "*nil*");
   }
}


static void   test_c_array_with_objects_count_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      id value;
      id params_1[] = { @"a", @"b", @"c" };
      unsigned long long params_2[] =
      {
         0,
         1,
         2,
         3
      };
      unsigned int   i_2;
      unsigned int   n_2 = 4;

      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         value = [NSArray arrayWithObjects:params_1
                                     count:params_2[ i_2]];
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      }
   }
}


static void   test_c_array_with_array_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      id value;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;

      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [NSArray arrayWithArray:params_1[ i_1]];
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      }
   }
}


static void   test_c_array_with_array_range_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      id value;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;
      NSRange params_2[] =
      {
         NSRangeMake( 0, 0),
         NSRangeMake( -1, 1),
         NSRangeMake( 0, -1),
         NSRangeMake( INT_MAX, INT_MAX)
      };
      unsigned int   i_2;
      unsigned int   n_2 = 4;

      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            @try
            {
               value = [NSArray mulleArrayWithArray:params_1[ i_1]
                                              range:params_2[ i_2]];
            }
            @catch( NSException *localException)
            {
               value = localException;
            }
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
   }
}


static void   test_i_init_with_objects_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray   *obj;

      obj = [[NSArray alloc] initWithObjects:@"whatever", @1, @{ @"a": @1 }, @[ @"a"], nil];
      printf( "%s\n", obj ? [obj UTF8String] : "*nil*");
      [obj release];
   }
}


static void   test_i_contains_object_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      BOOL value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [obj containsObject:params_1[ i_1]];
         // no plugin printer found for BOOL
         printf( "value is%s0\n", ! value ? " " : "not ");
      }
      [obj release];
   }
}


static void   test_i_init_with_array_and_array_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;
      NSArray * params_2[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_2;
      unsigned int   n_2 = 3;

      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            obj = [[NSArray alloc] mulleInitWithArray:params_1[ i_1]
                                             andArray:params_2[ i_2]];
            printf( "%s\n", obj ? [obj UTF8String] : "*nil*");
            [obj release];
         }
   }
}


static void   test_i_contains_object_in_range_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      BOOL value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;
      NSRange params_2[] =
      {
         NSRangeMake( 0, 0),
         NSRangeMake( -1, 1),
         NSRangeMake( 0, -1),
         NSRangeMake( INT_MAX, INT_MAX)
      };
      unsigned int   i_2;
      unsigned int   n_2 = 4;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            @try
            {
               value = [obj containsObject:params_1[ i_1]
                            inRange:params_2[ i_2]];
               printf( "value is %s\n", ! value ? "YES" : "NO");
            }
            @catch( NSException *localException)
            {
               printf( "%s\n", [[localException name] UTF8String]);
            }
            // no plugin printer found for BOOL
         }
      [obj release];
   }
}


static void   test_i_get_objects_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id * params_1[] =
      {
         0
      };
      unsigned int   i_1;
      unsigned int   n_1 = 1;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         [obj getObjects:params_1[ i_1]];
      }
      [obj release];
   }
}


static void   test_i_first_object_common_with_array_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [obj firstObjectCommonWithArray:params_1[ i_1]];
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      }
      [obj release];
   }
}


/*
static void   test_i_init_with_object_vararg_list_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;
      va_list params_2[] =
      {
         0
      };
      unsigned int   i_2;
      unsigned int   n_2 = 1;

      obj = [NSArray alloc];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            value = [obj initWithObject:params_1[ i_1]
                         arguments:params_2[ i_2]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
      [obj release];
   }
}
*/

static void   test_i_init()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;

      obj = [[NSArray alloc] init];
      printf( "%s\n", obj ? [obj UTF8String] : "*nil*");
      [obj release];
   }
}


static void   test_i_array_by_adding_objects_from_array_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray *value;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [obj arrayByAddingObjectsFromArray:params_1[ i_1]];
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      }
      [obj release];
   }
}


static void   test_i_make_objects_perform_selector_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      SEL params_1[] =
      {
         @selector( self),
         @selector( class)
      };
      unsigned int   i_1;
      unsigned int   n_1 = 2;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         [obj makeObjectsPerformSelector:params_1[ i_1]];
      }
      [obj release];
   }
}


static void   test_i_array_by_adding_object_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id  value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         @try
         {
            value = [obj arrayByAddingObject:params_1[ i_1]];
         }
         @catch( NSException *localException)
         {
            value = [localException name];
         }
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      }
      [obj release];
   }
}


static void   test_i_init_with_objects_count_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;
      id _params1[] = { @"whatever", @1, @{ @"a": @1 }, @[ @"a"] };
      unsigned long long params_2[] =
      {
         0,
         1,
         4
      };
      unsigned int   i_2;
      unsigned int   n_2 = 3;

      for( i_2 = 0; i_2 < n_2; i_2++)
      {
         obj = [[NSArray alloc] initWithObjects:_params1
                                          count:params_2[ i_2]];
         printf( "%s\n", obj ? [obj UTF8String] : "*nil*");
         [obj release];
      }
   }
}


static void   test_i_init_with_array_and_object_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;
      id params_2[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_2;
      unsigned int   n_2 = 5;

      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            @try
            {
               obj = [[NSArray alloc] mulleInitWithArray:params_1[ i_1]
                                               andObject:params_2[ i_2]];
               printf( "%s\n", obj ? [obj UTF8String] : "*nil*");
               [obj release];
            }
            @catch( NSException *localException)
            {
               printf( "%s\n", [[localException name] UTF8String]);
            }
         }
   }
}


static void   test_i_init_with_array_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;

      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         obj = [[NSArray alloc] initWithArray:params_1[ i_1]];
         printf( "%s\n", obj ? [obj UTF8String] : "*nil*");
         [obj release];
      }
   }
}


static void   test_i_last_object()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;

      obj = [[NSArray alloc] init];
      value = [obj lastObject];
      printf( "%s\n", value ? [value UTF8String] : "*nil*");
      [obj release];
   }
}


static void   test_i_init_with_array_copy_items_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;
      BOOL params_2[] =
      {
         YES,
         NO
      };
      unsigned int   i_2;
      unsigned int   n_2 = 2;

      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            obj = [[NSArray alloc] initWithArray:params_1[ i_1]
                                       copyItems:params_2[ i_2]];
            printf( "%s\n", obj ? [obj UTF8String] : "*nil*");
            [obj release];
         }
   }
}


static void   test_i_index_of_object_identical_to_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      unsigned long long value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [obj indexOfObjectIdenticalTo:params_1[ i_1]];
         if( value == NSNotFound)
            printf( "NSNotFound\n");
         else
            printf( "%llu\n", value);
      }
      [obj release];
   }
}


static void   test_i_init_with_array_range_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;
      NSRange params_2[] =
      {
         NSRangeMake( 0, 0),
         NSRangeMake( -1, 1),
         NSRangeMake( 0, -1),
         NSRangeMake( INT_MAX, INT_MAX)
      };
      unsigned int   i_2;
      unsigned int   n_2 = 4;

      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            @try
            {
               obj = [[NSArray alloc] mulleInitWithArray:params_1[ i_1]
                                                   range:params_2[ i_2]];
               printf( "%s\n", obj ? [obj UTF8String] : "*nil*");
               [obj release];
            }
            @catch( NSException *localException)
            {
               printf( "%s\n", [[localException name] UTF8String]);
            }
         }
   }
}


static void   test_i_index_of_object_identical_to_in_range_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      unsigned long long value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;
      NSRange params_2[] =
      {
         NSRangeMake( 0, 0),
         NSRangeMake( -1, 1),
         NSRangeMake( 0, -1),
         NSRangeMake( INT_MAX, INT_MAX)
      };
      unsigned int   i_2;
      unsigned int   n_2 = 4;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            @try
            {
               value = [obj indexOfObjectIdenticalTo:params_1[ i_1]
                            inRange:params_2[ i_2]];
               if( value == NSNotFound)
                  printf( "NSNotFound\n");
               else
                  printf( "%llu\n", value);
            }
            @catch( NSException *localException)
            {
               printf( "%s\n", [[localException name] UTF8String]);
            }
         }
      [obj release];
   }
}


/*
static void   test_i_mulle_for_each_object_call_function_argument_preempt_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;
      undefined * params_1[] =
      {
         0
      };
      unsigned int   i_1;
      unsigned int   n_1 = 1;
      void * params_2[] =
      {
         0
      };
      unsigned int   i_2;
      unsigned int   n_2 = 1;
      int params_3[] =
      {
         0,
         1,
         -1,
         1848,
         -1848,
         INT_MAX,
         INT_MIN
      };
      unsigned int   i_3;
      unsigned int   n_3 = 7;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
            for( i_3 = 0; i_3 < n_3; i_3++)
            {
               value = [obj mulleForEachObjectCallFunction:params_1[ i_1]
                            argument:params_2[ i_2]
                            preempt:params_3[ i_3]];
               printf( "%s\n", value ? [value UTF8String] : "*nil*");
            }
      [obj release];
   }
}
*/

static void   test_i_make_objects_perform_selector_with_object_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      SEL params_1[] =
      {
         @selector( self),
         @selector( class)
      };
      unsigned int   i_1;
      unsigned int   n_1 = 2;
      id params_2[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_2;
      unsigned int   n_2 = 5;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            [obj makeObjectsPerformSelector:params_1[ i_1]
                                 withObject:params_2[ i_2]];
         }
      [obj release];
   }
}


static void   test_i_subarray_with_range_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray *value;
      NSRange params_1[] =
      {
         NSRangeMake( 0, 0),
         NSRangeMake( -1, 1),
         NSRangeMake( 0, -1),
         NSRangeMake( INT_MAX, INT_MAX)
      };
      unsigned int   i_1;
      unsigned int   n_1 = 4;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         @try
         {
            value = [obj subarrayWithRange:params_1[ i_1]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
         @catch( NSException *localException)
         {
            printf( "%s\n", [[localException name] UTF8String]);
         }
      }
      [obj release];
   }
}


static void   test_i_is_equal_to_array_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      BOOL value;
      NSArray * params_1[] =
      {
         nil,
         [NSArray array],
         [NSArray arrayWithObjects:@"1", @"2", @1848, nil]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 3;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [obj isEqualToArray:params_1[ i_1]];
         // no plugin printer found for BOOL
         printf( "value is%s0\n", ! value ? " " : "not ");
      }
      [obj release];
   }
}


static void   test_i_index_of_object_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      unsigned long long value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [obj indexOfObject:params_1[ i_1]];
         if( value == NSNotFound)
            printf( "NSNotFound\n");
         else
            printf( "%llu\n", value);
      }
      [obj release];
   }
}


static void   test_i_is_equal_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      BOOL value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         value = [obj isEqual:params_1[ i_1]];
         // no plugin printer found for BOOL
         printf( "value is%s0\n", ! value ? " " : "not ");
      }
      [obj release];
   }
}

/*
static void   test_i_init_with_object_mulle_vararg_list_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;
      mulle_vararg_list params_2[] =
      {
         0
      };
      unsigned int   i_2;
      unsigned int   n_2 = 1;

      obj = [NSArray alloc];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            value = [obj initWithObject:params_1[ i_1]
                         mulleVarargList:params_2[ i_2]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
      [obj release];
   }
}
*/

static void   test_i_object_enumerator()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray        *obj;
      NSEnumerator   *rover;
      id             value;

      obj   = [[NSArray alloc] initWithArray:@[ @1, @2, @3]];
      rover = [obj objectEnumerator];
      while( value = [rover nextObject])
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      [obj release];
   }
}

static void   test_i_reverse_object_enumerator()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray        *obj;
      NSEnumerator   *rover;
      id             value;

      obj   = [[NSArray alloc] initWithArray:@[ @1, @2, @3]];
      rover = [obj reverseObjectEnumerator];
      while( value = [rover nextObject])
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      [obj release];
   }
}

/*
static void   test_i_sorted_array_using_function_context_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray *value;
      undefined * params_1[] =
      {
         0
      };
      unsigned int   i_1;
      unsigned int   n_1 = 1;
      void * params_2[] =
      {
         0
      };
      unsigned int   i_2;
      unsigned int   n_2 = 1;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            value = [obj sortedArrayUsingFunction:params_1[ i_1]
                            context:params_2[ i_2]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
      [obj release];
   }
}
*/

static void   test_i_mulle_make_objects_perform_selector_with_object_with_object_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      SEL params_1[] =
      {
         @selector( self),
         @selector( class)
      };
      unsigned int   i_1;
      unsigned int   n_1 = 2;
      id params_2[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_2;
      unsigned int   n_2 = 5;
      id params_3[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_3;
      unsigned int   n_3 = 5;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
            for( i_3 = 0; i_3 < n_3; i_3++)
            {
               [obj mulleMakeObjectsPerformSelector:params_1[ i_1]
                            withObject:params_2[ i_2]
                            withObject:params_3[ i_3]];
            }
      [obj release];
   }
}


static void   test_i_hash()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      unsigned long long value;

      obj   = [[NSArray alloc] initWithArray:@[ @1, @2, @3]];
      value = [obj hash];
      // printf( "%llu\n", value); // cpu dependent!
      [obj release];
   }
}


static void   test_i__()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;
      unsigned long long params_1[] =
      {
         0,
         1,
         1848,
         LONG_MAX
      };
      unsigned int   i_1;
      unsigned int   n_1 = 4;

      obj   = [[NSArray alloc] initWithArray:@[ @1, @2, @3]];
      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         @try
         {
            value = [obj :params_1[ i_1]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
         @catch( NSException *localException)
         {
            printf( "%s\n", [[localException name] UTF8String]);
         }
      }
      [obj release];
   }
}


static void   test_i_index_of_object_in_range_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray *other;
      unsigned long long value;
      id params_1[] =
      {
         nil,
         @"whatever",
         @1,
         @{ @"a": @1 },
         @[ @"a" ]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 5;
      NSRange params_2[] =
      {
         NSRangeMake( 0, 0),
         NSRangeMake( 1, 1),
         NSRangeMake( -1, 1),
         NSRangeMake( 0, -1),
         NSRangeMake( INT_MAX, INT_MAX)
      };
      unsigned int   i_2;
      unsigned int   n_2 = 4;

      obj   = [[NSArray alloc] initWithArray:@[ @1, @2, @3]];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            @try
            {
               other = params_1[ i_1];
               printf( "%s\n", other ? [other UTF8String] : "*nil*");
               value = [obj indexOfObject:other
                                  inRange:params_2[ i_2]];
               if( value == NSNotFound)
                  printf( "NSNotFound\n");
               else
                  printf( "%llu\n", value);
            }
            @catch( NSException *localException)
            {
               printf( "%s\n", [[localException name] UTF8String]);
            }
         }
      [obj release];
   }
}


static void   test_i_sorted_array_using_selector_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSArray *value;
      SEL params_1[] =
      {
         @selector( compare:),
         0
      };
      unsigned int   i_1;
      unsigned int   n_1 = 2;

      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         @try
         {
            obj   = [[[NSArray alloc] initWithArray:@[ @2, @3, @1]] autorelease];
            value = [obj sortedArrayUsingSelector:params_1[ i_1]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
         @catch( NSException *exception)
         {
            printf( "Threw a %s exception\n", [[exception name] UTF8String]);
         }
      }
   }
}


static void   test_i_mutable_copy()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id value;

      @try
      {
         obj   = [[[NSArray alloc] initWithArray:@[ @2, @3, @1]] autorelease];
         value = [[obj mutableCopy] autorelease];
         printf( "%s\n", value ? [value UTF8String] : "*nil*");
      }
      @catch( NSException *exception)
      {
         printf( "Threw a %s exception\n", [[exception name] UTF8String]);
      }
   }
}


static void   test_i_description_with_locale_indent_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSString *value;
      NSLocale * params_1[] =
      {
         nil,
         [[NSLocale init] autorelease]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 2;
      unsigned long long params_2[] =
      {
         0,
         1,
      };
      unsigned int   i_2;
      unsigned int   n_2 = 4;

      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            @try
            {
               obj   = [[[NSArray alloc] initWithArray:@[ @2, @3, @1]] autorelease];
               value = [obj descriptionWithLocale:params_1[ i_1]
                                           indent:params_2[ i_2]];
               printf( "%s\n", value ? [value UTF8String] : "*nil*");
            }
            @catch( NSException *exception)
            {
               printf( "Threw a %s exception\n", [[exception name] UTF8String]);
            }
         }
   }
}


static void   test_i_description_with_locale_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      NSString *value;
      NSLocale * params_1[] =
      {
         nil,
         [[NSLocale init] autorelease]
      };
      unsigned int   i_1;
      unsigned int   n_1 = 2;

      for( i_1 = 0; i_1 < n_1; i_1++)
      {
         @try
         {
            obj   = [[[NSArray alloc] initWithArray:@[ @2, @3, @1]] autorelease];
            value = [obj descriptionWithLocale:params_1[ i_1]];
            printf( "%s\n", value ? [value UTF8String] : "*nil*");
         }
         @catch( NSException *exception)
         {
            printf( "Threw a %s exception\n", [[exception name] UTF8String]);
         }
      }
   }
}

/*
static void   test_i_property_list_utf8data_to_stream_indent_()
{
   printf( "%s\n", __PRETTY_FUNCTION__);

   @autoreleasepool
   {
      NSArray *obj;
      id <MulleObjCOutputStream> params_1[] =
      {
         0
      };
      unsigned int   i_1;
      unsigned int   n_1 = 1;
      unsigned int params_2[] =
      {
         0,
         1,
         1848,
         INT_MAX
      };
      unsigned int   i_2;
      unsigned int   n_2 = 4;

      obj = [[NSArray alloc] init];
      for( i_1 = 0; i_1 < n_1; i_1++)
         for( i_2 = 0; i_2 < n_2; i_2++)
         {
            [obj mullePrintPropertyList:params_1[ i_1]
                         indent:params_2[ i_2]];
         }
      [obj release];
   }
}
*/


static void  run_test( void (*f)( void))
{
   mulle_testallocator_discard(); // will
   (*f)();                        // leak
   mulle_testallocator_reset();   // check
}


int   main( int argc, char *argv[])
{
#ifdef __MULLE_OBJC__
   // check that no classes are "stuck"
   if( mulle_objc_global_check_universe( __MULLE_OBJC_UNIVERSENAME__) !=
         mulle_objc_universe_is_ok)
      return( 1);
#endif
   run_test( test_noleak);
   run_test( test_i_class_for_coder);
   run_test( test_i_sorted_array_using_descriptors_);
   run_test( test_i_description);
   run_test( test_i_components_joined_by_string_);
   run_test( test_c_array_with_retained_objects_count_);
   run_test( test_c_array_with_objects_);
   run_test( test_c_array_with_object_);
   run_test( test_c_array);
   run_test( test_c_array_with_objects_count_);
   run_test( test_c_array_with_array_);
   run_test( test_c_array_with_array_range_);
   run_test( test_i_init_with_objects_);
   run_test( test_i_contains_object_);
   run_test( test_i_init_with_array_and_array_);
   run_test( test_i_contains_object_in_range_);
   run_test( test_i_get_objects_);
   run_test( test_i_first_object_common_with_array_);
//   run_test( test_i_init_with_object_vararg_list_);
   run_test( test_i_init);
   run_test( test_i_array_by_adding_objects_from_array_);
   run_test( test_i_make_objects_perform_selector_);
   run_test( test_i_array_by_adding_object_);
   run_test( test_i_init_with_objects_count_);
   run_test( test_i_init_with_array_and_object_);
   run_test( test_i_init_with_array_);
   run_test( test_i_last_object);
   run_test( test_i_init_with_array_copy_items_);
   run_test( test_i_index_of_object_identical_to_);
   run_test( test_i_init_with_array_range_);
   run_test( test_i_index_of_object_identical_to_in_range_);
//   run_test( test_i_mulle_for_each_object_call_function_argument_preempt_);
   run_test( test_i_make_objects_perform_selector_with_object_);
   run_test( test_i_subarray_with_range_);
   run_test( test_i_object_enumerator);
   run_test( test_i_is_equal_to_array_);
   run_test( test_i_index_of_object_);
   run_test( test_i_is_equal_);
//   run_test( test_i_init_with_object_mulle_vararg_list_);
   run_test( test_i_reverse_object_enumerator);
//   run_test( test_i_sorted_array_using_function_context_);
   run_test( test_i_mulle_make_objects_perform_selector_with_object_with_object_);
   run_test( test_i_hash);
   run_test( test_i__);
   run_test( test_i_index_of_object_in_range_);
   run_test( test_i_sorted_array_using_selector_);
   run_test( test_i_mutable_copy);
   run_test( test_i_description_with_locale_indent_);
   run_test( test_i_description_with_locale_);
//   run_test( test_i_property_list_utf8data_to_stream_indent_);
   // universe should not leak check now
   mulle_testallocator_cancel();  // will

   return( 0);
}
