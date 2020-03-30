#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


@interface SimpleStream : NSObject <MulleObjCOutputStream>
@end


@implementation SimpleStream

- (void) mulleWriteBytes:(void *) bytes
                  length:(NSUInteger) length
{
   printf( "%.*s\n", (int) length, bytes);
}

@end


int   main( void)
{
   MulleObjCBufferedOutputStream   *stream;
   SimpleStream                    *simple;
   int                             i;

   simple = [SimpleStream object];
   stream = [[[MulleObjCBufferedOutputStream alloc] initWithOutputStream:simple
                                                             flushLength:32] autorelease];
   for( i = 0; i < 16; i++)
      [stream mulleWriteBytes:"VfL Bochum 1848"
                       length:-1];
   [stream flush];

   return( 0);
}
