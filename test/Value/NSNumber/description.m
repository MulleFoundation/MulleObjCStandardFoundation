#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
# import <MulleObjCValueFoundation/_MulleObjCTaggedPointerIntegerNumber.h>
# import <MulleObjCValueFoundation/private/NSString+Substring-Private.h>
#endif


//#define VALGRIND_COMPLAINT

extern
struct mulle_asciidata
   _MulleObjCTaggedPointerIntegerNumberConvertToASCIICharacters( _MulleObjCTaggedPointerIntegerNumber *self,
                                                                 struct mulle_asciidata data);



@interface _MulleObjCTaggedPointerIntegerNumber( NSString)

- (void) _mulleConvertToASCIICharacters:(struct mulle_asciidata *) data;
- (NSString *) stringValue;

@end



@implementation  _MulleObjCTaggedPointerIntegerNumber( XXX)

- (struct mulle_asciidata) xxx:(struct mulle_asciidata) data
{
   return( _MulleObjCTaggedPointerIntegerNumberConvertToASCIICharacters( self, data));
}


- (NSString *) xStringValue
{
   char                                tmp[ 32];
   struct mulle_asciidata             data;
   static struct _MulleStringContext   empty;

#ifdef DEBUG
   memset( tmp, 'X', sizeof( tmp));
   memset( &string, 'X', sizeof( string));
#endif
   data   = mulle_asciidata_make( tmp, sizeof( tmp));
   [self _mulleConvertToASCIICharacters:&data];

//   string = _MulleObjCTaggedPointerIntegerNumberConvertToASCIICharacters( self,
//                                                                          mulle_asciidata_make( tmp, sizeof( tmp)));
   return( [_mulleNewASCIIStringWithStringContext( data.characters,
                                                   &data.characters[ data.length],
                                                   &empty) autorelease]);
}

@end


int  main( void)
{
   NSNumber   *value;

#ifndef VALGRIND_COMPLAINT
   printf( "bool\n");
   value = [NSNumber numberWithBool:YES];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nchar\n");
   value = [NSNumber numberWithChar:1];
   printf( "%s\n", [[value description] UTF8String]);
#endif

   printf( "\nshort\n");
   value = [NSNumber numberWithShort:1848];
   if( 0)
   {
      char                      tmp[ 32];
      struct mulle_asciidata   string;

#if 0
      string = [value xxx: mulle_asciidata_make( tmp, sizeof( tmp))];
#else
      string = _MulleObjCTaggedPointerIntegerNumberConvertToASCIICharacters( (id) value,
                                                                             mulle_asciidata_make( tmp, sizeof( tmp)));
#endif
      printf( "%.*s\n", (int) string.length, string.characters);
   }
   else
      if( 1)
         printf( "%s\n", [[value xStringValue] UTF8String]);
      else
         printf( "%s\n", [[value description] UTF8String]);

#ifndef VALGRIND_COMPLAINT
   printf( "\nint\n");
   value = [NSNumber numberWithInt:1848];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nlong\n");
   value = [NSNumber numberWithLong:1848];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nlong long\n");
   value = [NSNumber numberWithLongLong:1848];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nNSInteger\n");
   value = [NSNumber numberWithInteger:1848];
   printf( "%s\n", [[value description] UTF8String]);


   printf( "\nfloat\n");
   value = [NSNumber numberWithFloat:18.48];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\ndouble\n");
   value = [NSNumber numberWithDouble:18.48];
   printf( "%s\n", [[value description] UTF8String]);

   printf( "\nlong double\n");
   value = [NSNumber numberWithLongDouble:18.48];
   printf( "%s\n", [[value description] UTF8String]);
#endif

   return( 0);
}
