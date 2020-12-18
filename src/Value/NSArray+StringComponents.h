//
// Routines specifically written for componentsSeparatedBy...
//
@interface NSArray( StringComponents)

+ (instancetype) _mulleArrayFromASCIIData:(struct mulle_asciidata) buf
                             pointerQueue:(struct mulle__pointerqueue *) offsets
                                   stride:(NSUInteger) sepLen
                            sharingObject:(id) object;

//
// sepLen==-1 is special as it will consume one utf32 character after each string
// (works for any UTF8). otherwise sepLen is the number of utf8 bytes
//
+ (instancetype) mulleArrayFromUTF8Data:(struct mulle_utf8data) buf
                           pointerQueue:(struct mulle__pointerqueue *) offsets
                                 stride:(NSUInteger) sepLen
                           sharingObject:(id) object;

// sepLen==0 will consume one utf character after each string
// works only if data is utf15 really though!
+ (instancetype) _mulleArrayFromUTF16Data:(struct mulle_utf16data) buf
                             pointerQueue:(struct mulle__pointerqueue *) offsets
                                   stride:(NSUInteger) sepLen
                           sharingObject:(id) object;

// sepLen==0 will consume one utf character after each string
+ (instancetype) mulleArrayFromUTF32Data:(struct mulle_utf32data) buf
                            pointerQueue:(struct mulle__pointerqueue *) offsets
                                  stride:(NSUInteger) sepLen
                           sharingObject:(id) object;

@end

