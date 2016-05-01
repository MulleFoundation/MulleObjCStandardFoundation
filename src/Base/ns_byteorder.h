/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *    NSByteOrder.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef ns_byteorder_h__
#define ns_byteorder_h__

//
// do this once here, other code should just use __LITTLE_ENDIAN__ or
// __BIG_ENDIAN__ from now on
//
#if ! defined(__LITTLE_ENDIAN__) && ! defined(__BIG_ENDIAN__)
# if defined( __BYTE_ORDER__) && defined( __ORDER_LITTLE_ENDIAN__) && defined( __ORDER_LITTLE_ENDIAN__)
#  if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
#   define __LITTLE_ENDIAN__  1
#   define __BIG_ENDIAN__     0
#  else
#   define __LITTLE_ENDIAN__  0
#   define __BIG_ENDIAN__     1
#  endif
# else
#  if defined( __LITTE_ENDIAN__) && defined( __BIG_ENDIAN__)
#   error Both __LITTLE_ENDIAN__ and __BIG_ENDIAN__ defined
#  else
#   error Neither __LITTLE_ENDIAN__ nor __BIG_ENDIAN__ defined
#  endif
# endif
#endif


enum MulleObjCByteOrder 
{
   NS_UnknownByteOrder,
   NS_LittleEndian,
   NS_BigEndian
};


static inline long   NSHostByteOrder(void) 
{
#if __BIG_ENDIAN__
   return( NS_BigEndian);
#else
   return( NS_LittleEndian);
#endif   
}


static inline uint16_t   MulleObjCSwapUInt16( uint16_t value)
{
   return( (uint16_t) (value >> 8) | (uint16_t) (value << 8));
}


static inline uint32_t   MulleObjCSwapUInt32( uint32_t value)
{
   return( MulleObjCSwapUInt16( (uint16_t) (value >> 16)) |
          ((uint32_t) MulleObjCSwapUInt16( (uint16_t) value) << 16));
}


static inline unsigned short   NSSwapShort( unsigned short value)
{
   return(  (unsigned short) (value >> 8) | (unsigned short) (value << 8));
}


static inline unsigned int   NSSwapInt( unsigned int value) 
{
   // check that this compiles to single i386 instruction
   return( NSSwapShort( (unsigned short) (value >> 16)) | 
                        ((unsigned int) NSSwapShort( (unsigned short) value) << 16));
}


static inline unsigned long long   NSSwapLongLong( unsigned long long value) 
{
   return( NSSwapInt( (unsigned int) (value >> 32)) | ((unsigned long long) NSSwapInt( (unsigned int) value) << 32));
}


static inline unsigned long   NSSwapLong( unsigned long value) 
{
#if __LP64__
    return NSSwapLongLong( value);
#else
    return NSSwapInt( value);
#endif
}


static inline void   NSSwap10Bytes( unsigned char  bytes[ 10])
{
   unsigned char   c;
   
   c = bytes[ 0]; bytes[ 0] = bytes[ 9]; bytes[ 9] = c;
   c = bytes[ 1]; bytes[ 1] = bytes[ 8]; bytes[ 8] = c;
   c = bytes[ 2]; bytes[ 2] = bytes[ 7]; bytes[ 7] = c;
   c = bytes[ 3]; bytes[ 3] = bytes[ 6]; bytes[ 6] = c;
   c = bytes[ 4]; bytes[ 4] = bytes[ 5]; bytes[ 5] = c;
}



static inline unsigned short   NSSwapBigShortToHost( unsigned short value) 
{
#if __BIG_ENDIAN__
   return( value);
#else
   return( NSSwapShort( value));
#endif   
}


static inline unsigned int   NSSwapBigIntToHost( unsigned int value) 
{
#if __BIG_ENDIAN__
   return( value);
#else
   return( NSSwapInt( value));
#endif   
}


static inline unsigned long   NSSwapBigLongToHost( unsigned long value) 
{
#if __BIG_ENDIAN__
   return( value);
#else
   return( NSSwapLong( value));
#endif   
}


static inline unsigned long long   NSSwapBigLongLongToHost( unsigned long long value) 
{
#if __BIG_ENDIAN__
   return( value);
#else
   return( NSSwapLongLong( value));
#endif   
}


static inline unsigned short   NSSwapHostShortToBig( unsigned short value) 
{
#if __BIG_ENDIAN__
   return( value);
#else
   return( NSSwapShort( value));
#endif   
}


static inline unsigned int   NSSwapHostIntToBig( unsigned int value) 
{
#if __BIG_ENDIAN__
   return( value);
#else
   return( NSSwapInt( value));
#endif   
}


static inline unsigned long   NSSwapHostLongToBig( unsigned long value) 
{
#if __BIG_ENDIAN__
   return( value);
#else
   return( NSSwapLong( value));
#endif   
}


static inline unsigned long long   NSSwapHostLongLongToBig( unsigned long long value) 
{
#if __BIG_ENDIAN__
   return( value);
#else
   return( NSSwapLongLong( value));
#endif   
}


// same for LITTLE


static inline unsigned short   NSSwapLittleShortToHost( unsigned short value) 
{
#if __LITTLE_ENDIAN__
   return( value);
#else
   return( NSSwapShort( value));
#endif   
}


static inline unsigned int   NSSwapLittleIntToHost( unsigned int value) 
{
#if __LITTLE_ENDIAN__
   return( value);
#else
   return( NSSwapInt( value));
#endif   
}


static inline unsigned long   NSSwapLittleLongToHost( unsigned long value) 
{
#if __LITTLE_ENDIAN__
   return( value);
#else
   return( NSSwapLong( value));
#endif   
}


static inline unsigned long long   NSSwapLittleLongLongToHost( unsigned long long value) 
{
#if __LITTLE_ENDIAN__
   return( value);
#else
   return( NSSwapLongLong( value));
#endif   
}


static inline unsigned short   NSSwapHostShortToLittle( unsigned short value) 
{
#if __LITTLE_ENDIAN__
   return( value);
#else
   return( NSSwapShort( value));
#endif   
}


static inline unsigned int   NSSwapHostIntToLittle( unsigned int value) 
{
#if __LITTLE_ENDIAN__
   return( value);
#else
   return( NSSwapInt( value));
#endif   
}


static inline unsigned long   NSSwapHostLongToLittle( unsigned long value) 
{
#if __LITTLE_ENDIAN__
   return( value);
#else
   return( NSSwapLong( value));
#endif   
}


static inline unsigned long long   NSSwapHostLongLongToLittle( unsigned long long value) 
{
#if __LITTLE_ENDIAN__
   return( value);
#else
   return( NSSwapLongLong( value));
#endif   
}

#pragma mark -
#pragma mark pedantic access

typedef struct 
{ 
   uint32_t   v;
} NSSwappedFloat;


typedef struct 
{  
   uint64_t   v;
} NSSwappedDouble;


typedef struct
{
   uint8_t   v[ 10];   // assume 80 bit
} NSSwappedLongDouble;


union __NSSwappedLongDoubleTemp
{
   long double           ld;
   NSSwappedLongDouble   swapped;
};


union __NSSwappedDoubleTemp 
{
   double            d;
   NSSwappedDouble   swapped;
};


union __NSSwappedFloatTemp 
{
   float          f;
   NSSwappedFloat swapped;
};


static inline  NSSwappedFloat   NSConvertHostFloatToSwapped( float value) 
{
   return( (union __NSSwappedFloatTemp *) &value)->swapped;
}


static inline float   NSConvertSwappedFloatToHost( NSSwappedFloat value) 
{

    return( (union __NSSwappedFloatTemp *) &value)->f;
}


static inline NSSwappedDouble   NSConvertHostDoubleToSwapped( double value) 
{
    return( (union __NSSwappedDoubleTemp *) &value)->swapped;
}


static inline double   NSConvertSwappedDoubleToHost( NSSwappedDouble value)
{
   return( (union __NSSwappedDoubleTemp *) &value)->d;
}


static inline NSSwappedLongDouble   NSConvertHostLongDoubleToSwapped( long double value)
{
   return( (union __NSSwappedLongDoubleTemp *) &value)->swapped;
}


static inline long double   NSConvertSwappedLongDoubleToHost( NSSwappedLongDouble value)
{
   return( (union __NSSwappedLongDoubleTemp *) &value)->ld;
}

#pragma mark -
#pragma mark operations

static inline NSSwappedFloat   NSSwapFloat( NSSwappedFloat value) 
{
    value.v = NSSwapInt( value.v);
    return( value);
}


static inline NSSwappedDouble   NSSwapDouble( NSSwappedDouble value) 
{
    value.v = NSSwapLongLong( value.v);
    return( value);
}


static inline NSSwappedLongDouble   NSSwapLongDouble( NSSwappedLongDouble value)
{
   NSSwap10Bytes( value.v);
   return( value);
}


#if defined(__BIG_ENDIAN__)

static inline float   NSSwapBigFloatToHost( NSSwappedFloat value)
{
   return( NSConvertSwappedFloatToHost( value));
}


static inline double   NSSwapBigDoubleToHost( NSSwappedDouble value)
{
    return( NSConvertSwappedDoubleToHost( value));
}


static inline long double   NSSwapBigLongDoubleToHost( NSSwappedLongDouble value)
{
   return( NSConvertSwappedLongDoubleToHost( value));
}


// ---

static inline NSSwappedFloat   NSSwapHostFloatToBig( float value)
{
   return( NSConvertHostFloatToSwapped( value));
}


static inline NSSwappedDouble   NSSwapHostDoubleToBig( double value)
{
   return( NSConvertHostDoubleToSwapped( value));
}


static inline NSSwappedLongDouble   NSSwapHostLongDoubleToBig( long double value)
{
   return( NSConvertHostLongDoubleToSwapped( value));
}


// ---

static inline float   NSSwapLittleFloatToHost( NSSwappedFloat value)
{
   return( NSConvertSwappedFloatToHost( NSSwapFloat( value)));
}


static inline double   NSSwapLittleDoubleToHost( NSSwappedDouble value)
{
    return( NSConvertSwappedDoubleToHost( NSSwapDouble( value)));
}


static inline long double   NSSwapLittleLongDoubleToHost( NSSwappedLongDouble value)
{
   return( NSConvertSwappedLongDoubleToHost( NSSwapLongDouble( value)));
}


// ---

static inline NSSwappedFloat   NSSwapHostFloatToLittle( float value)
{
   return( NSSwapFloat( NSConvertHostFloatToSwapped( value)));
}


static inline NSSwappedDouble   NSSwapHostDoubleToLittle( double value)
{
    return( NSSwapDouble( NSConvertHostDoubleToSwapped( value)));
}


static inline NSSwappedLongDouble   NSSwapHostLongDoubleToLittle( long double value)
{
   return( NSSwapLongDouble( NSConvertHostLongDoubleToSwapped( value)));
}


#else


static inline float   NSSwapBigFloatToHost( NSSwappedFloat value)
{
   return( NSConvertSwappedFloatToHost( NSSwapFloat( value)));
}


static inline double   NSSwapBigDoubleToHost( NSSwappedDouble value)
{
    return( NSConvertSwappedDoubleToHost( NSSwapDouble( value)));
}


static inline long double   NSSwapBigLongDoubleToHost( NSSwappedLongDouble value)
{
   return( NSConvertSwappedLongDoubleToHost( NSSwapLongDouble( value)));
}


// ---

static inline NSSwappedFloat   NSSwapHostFloatToBig( float value)
{
   return( NSSwapFloat( NSConvertHostFloatToSwapped( value)));
}


static inline NSSwappedDouble   NSSwapHostDoubleToBig( double value)
{
    return( NSSwapDouble( NSConvertHostDoubleToSwapped( value)));
}


static inline NSSwappedLongDouble   NSSwapHostLongDoubleToBig( long double value)
{
   return( NSSwapLongDouble( NSConvertHostLongDoubleToSwapped( value)));
}



// ---

static inline float   NSSwapLittleFloatToHost( NSSwappedFloat value)
{
   return( NSConvertSwappedFloatToHost( value));
}


static inline double   NSSwapLittleDoubleToHost( NSSwappedDouble value)
{
    return( NSConvertSwappedDoubleToHost( value));
}


static inline long double   NSSwapLittleLongDoubleToHost( NSSwappedLongDouble value)
{
   return( NSConvertSwappedLongDoubleToHost( value));
}

// ---

static inline NSSwappedFloat   NSSwapHostFloatToLittle( float value)
{
    return( NSConvertHostFloatToSwapped( value));
}


static inline NSSwappedDouble   NSSwapHostDoubleToLittle(double value)
{
   return( NSConvertHostDoubleToSwapped( value));
}


static inline NSSwappedLongDouble   NSSwapHostLongDoubleToLittle( long double value)
{
   return( NSConvertHostLongDoubleToSwapped( value));
}

#endif

#endif
