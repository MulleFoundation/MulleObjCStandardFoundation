/*
 *  MulleFoundationTests - A tiny Foundation replacement
 *
 *  test_common_NSByteOrder.m is a part of MulleFoundation
 *
 *  Copyright (C) 2012 Nat!, Mulle kybernetiK
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#include "test_mulleCCoreParentIncludes.h"


static void   test_NSSwapShort( void)
{
   UKIntsEqual( 0, NSSwapShort( 0));
   UKIntsEqual( 0xCDAB, NSSwapShort( 0xABCD));
   UKIntsEqual( 0x4818, NSSwapShort( 0x1848));
}


static void   test_NSSwapInt( void)
{
   UKIntsEqual( 0, NSSwapInt( 0));
   UKIntsEqual( 0xCDAB0000, NSSwapInt( 0xABCD));
   UKIntsEqual( 0x4818CDAB, NSSwapInt( 0xABCD1848));
   UKIntsEqual( 0xCDAB4818, NSSwapLong( 0x1848ABCD));
}


static void   test_NSSwapLong( void)
{
   UKIntsEqual( 0, NSSwapLong( 0));
   UKIntsEqual( 0xCDAB0000L, NSSwapLong( 0xABCDL));
   UKIntsEqual( 0x4818CDABL, NSSwapLong( 0xABCD1848L));
   UKIntsEqual( 0xCDAB4818L, NSSwapLong( 0x1848ABCDL));
}


static void   test_NSSwapLongLong( void)
{
   UKIntsEqual( 0, NSSwapLongLong( 0));
   UKIntsEqual( 0xCDAB000000000000LL, NSSwapLongLong( 0xABCDLL));
   UKIntsEqual( 0x4818CDAB00000000LL, NSSwapLongLong( 0xABCD1848LL));
   UKIntsEqual( 0x481867452301CDABLL, NSSwapLongLong( 0xABCD012345671848LL));
}


static void   test_NSSwapFloat( void)
{
   NSSwappedFloat   x, y;

   x.v = 0xCDAB4818;
   y   = NSSwapFloat( x);

   UKIntsEqual( NSSwapInt( x.v), y.v);
}


static void   test_NSSwapDouble( void)
{
   NSSwappedDouble   x, y;

   x.v = 0x481867452301CDABLL;
   y   = NSSwapDouble( x);

   UKIntsEqual( NSSwapLongLong( x.v), y.v);
}


static void   test_NSSwapBigShortToHost( void)
{
   unsigned short  x;
   unsigned char   *p;

   p     = (unsigned char *)  &x;
   p[ 0] = 0x18;
   p[ 1] = 0x48;

   UKIntsEqual( 0x1848, NSSwapBigShortToHost( x));
}


static void   test_NSSwapBigIntToHost( void)
{
   unsigned int   x;
   unsigned char  *p;

   p     = (unsigned char *) &x;
   p[ 0] = 0x18;
   p[ 1] = 0x48;
   p[ 2] = 0xAB;
   p[ 3] = 0xCD;

   UKIntsEqual( 0x1848ABCD, NSSwapBigIntToHost( x));
}



static void   test_NSSwapBigLongToHost( void)
{
   unsigned long  x;
   unsigned char  *p;

   p     = (unsigned char *) &x;
   p[ 0] = 0x18;
   p[ 1] = 0x48;
   p[ 2] = 0xAB;
   p[ 3] = 0xCD;

   UKIntsEqual( 0x1848ABCD, NSSwapBigLongToHost( x));
}


static void   test_NSSwapBigLongLongToHost( void)
{
   unsigned long long  x;
   unsigned char       *p;

   p     = (unsigned char *) &x;
   p[ 0] = 0x18;
   p[ 1] = 0x48;
   p[ 2] = 0xAB;
   p[ 3] = 0xCD;
   p[ 4] = 0x01;
   p[ 5] = 0x02;
   p[ 6] = 0x03;
   p[ 7] = 0x04;

   UKIntsEqual( 0x1848ABCD01020304LL, NSSwapBigLongLongToHost( x));
}


static void   test_NSSwapHostShortToBig( void)
{
   unsigned short  x;
   unsigned char   *p;

   p     = (unsigned char *)  &x;
   p[ 0] = 0x18;
   p[ 1] = 0x48;

   UKIntsEqual( x, NSSwapHostShortToBig( 0x1848));
}


static void   test_NSSwapHostIntToBig( void)
{
   unsigned int   x;
   unsigned char  *p;

   p     = (unsigned char *) &x;
   p[ 0] = 0x18;
   p[ 1] = 0x48;
   p[ 2] = 0xAB;
   p[ 3] = 0xCD;

   UKIntsEqual( x, NSSwapHostIntToBig( 0x1848ABCD));
}


static void   test_NSSwapHostLongToBig( void)
{
   unsigned long  x;
   unsigned char  *p;

   p     = (unsigned char *) &x;
   p[ 0] = 0x18;
   p[ 1] = 0x48;
   p[ 2] = 0xAB;
   p[ 3] = 0xCD;

   UKIntsEqual( x, NSSwapHostLongToBig( 0x1848ABCD));
}


static void   test_NSSwapHostLongLongToBig( void)
{
   unsigned long long  x;
   unsigned char       *p;

   p     = (unsigned char *) &x;
   p[ 0] = 0x18;
   p[ 1] = 0x48;
   p[ 2] = 0xAB;
   p[ 3] = 0xCD;
   p[ 4] = 0x01;
   p[ 5] = 0x02;
   p[ 6] = 0x03;
   p[ 7] = 0x04;

   UKIntsEqual( x, NSSwapHostLongLongToBig( 0x1848ABCD01020304LL));
}


static void   test_NSSwapLittleShortToHost( void)
{
   unsigned short  x;
   unsigned char   *p;

   p     = (unsigned char *)  &x;
   p[ 1] = 0x18;
   p[ 0] = 0x48;

   UKIntsEqual( 0x1848, NSSwapLittleShortToHost( x));
}


static void   test_NSSwapLittleIntToHost( void)
{
   unsigned int   x;
   unsigned char  *p;

   p     = (unsigned char *) &x;
   p[ 3] = 0x18;
   p[ 2] = 0x48;
   p[ 1] = 0xAB;
   p[ 0] = 0xCD;

   UKIntsEqual( 0x1848ABCD, NSSwapLittleIntToHost( x));
}



static void   test_NSSwapLittleLongToHost( void)
{
   unsigned long  x;
   unsigned char  *p;

   p     = (unsigned char *) &x;
   p[ 3] = 0x18;
   p[ 2] = 0x48;
   p[ 1] = 0xAB;
   p[ 0] = 0xCD;

   UKIntsEqual( 0x1848ABCD, NSSwapLittleLongToHost( x));
}


static void   test_NSSwapLittleLongLongToHost( void)
{
   unsigned long long  x;
   unsigned char       *p;

   p     = (unsigned char *) &x;
   p[ 7] = 0x18;
   p[ 6] = 0x48;
   p[ 5] = 0xAB;
   p[ 4] = 0xCD;
   p[ 3] = 0x01;
   p[ 2] = 0x02;
   p[ 1] = 0x03;
   p[ 0] = 0x04;

   UKIntsEqual( 0x1848ABCD01020304LL, NSSwapLittleLongLongToHost( x));
}


static void   test_NSSwapHostShortToLittle( void)
{
   unsigned short  x;
   unsigned char   *p;

   p     = (unsigned char *)  &x;
   p[ 1] = 0x18;
   p[ 0] = 0x48;

   UKIntsEqual( x, NSSwapHostShortToLittle( 0x1848));
}


static void   test_NSSwapHostIntToLittle( void)
{
   unsigned int   x;
   unsigned char  *p;

   p     = (unsigned char *) &x;
   p[ 3] = 0x18;
   p[ 2] = 0x48;
   p[ 1] = 0xAB;
   p[ 0] = 0xCD;

   UKIntsEqual( x, NSSwapHostIntToLittle( 0x1848ABCD));
}


static void   test_NSSwapHostLongToLittle( void)
{
   unsigned long  x;
   unsigned char  *p;

   p     = (unsigned char *) &x;
   p[ 3] = 0x18;
   p[ 2] = 0x48;
   p[ 1] = 0xAB;
   p[ 0] = 0xCD;

   UKIntsEqual( x, NSSwapHostLongToLittle( 0x1848ABCD));
}


static void   test_NSSwapHostLongLongToLittle( void)
{
   unsigned long long  x;
   unsigned char       *p;

   p     = (unsigned char *) &x;
   p[ 7] = 0x18;
   p[ 6] = 0x48;
   p[ 5] = 0xAB;
   p[ 4] = 0xCD;
   p[ 3] = 0x01;
   p[ 2] = 0x02;
   p[ 1] = 0x03;
   p[ 0] = 0x04;

   UKIntsEqual( x, NSSwapHostLongLongToLittle( 0x1848ABCD01020304LL));
}




static void   test_NSConvertSwappedFloatToHost( void)
{
   float   v;

   v = -0.12345e-10;

   UKFloatsEqual( NSConvertSwappedFloatToHost( NSConvertHostFloatToSwapped( v)), v, 0.0);
}


static void   test_NSConvertSwappedDoubleToHost( void)
{
   double   v;

   v = -0.123456789e-10;

   UKFloatsEqual( NSConvertSwappedDoubleToHost( NSConvertHostDoubleToSwapped( v)), v, 0.0);
}


static void   test_NSConvertHostFloatToSwapped( void)
{
   // s.a.
}

static void   test_NSConvertHostDoubleToSwapped( void)
{
   // s.a.
}


static void   test_NSSwapBigDoubleToHost( void)
{
   NSSwappedDouble   x;
   unsigned char     *p;
   double            v;

   p     = (unsigned char *) &x;

   // value a little different than long long
   p[ 0] = 0x04;
   p[ 1] = 0x03;
   p[ 2] = 0x02;
   p[ 3] = 0x01;
   p[ 4] = 0xCD;
   p[ 5] = 0xAB;
   p[ 6] = 0x48;
   p[ 7] = 0x18;

   v = NSSwapBigDoubleToHost( x);
   UKFloatsEqual( 2.4380743395473987e-289, v, 0.0);
}


static void   test_NSSwapBigFloatToHost( void)
{
   NSSwappedFloat   x;
   unsigned char    *p;
   float            v;

   p = (unsigned char *) &x;

   p[ 0] = 0x04;
   p[ 1] = 0x03;
   p[ 2] = 0x02;
   p[ 3] = 0x01;

   v = NSSwapBigFloatToHost( x);
   UKFloatsEqual( 1.53998961443955806e-36, v, 0.0);
}


static void   test_NSSwapHostDoubleToBig( void)
{
   NSSwappedDouble   x;
   unsigned char     *p;
   NSSwappedDouble   v;

   p     = (unsigned char *) &x;

   // value a little different than long long
   p[ 0] = 0x04;
   p[ 1] = 0x03;
   p[ 2] = 0x02;
   p[ 3] = 0x01;
   p[ 4] = 0xCD;
   p[ 5] = 0xAB;
   p[ 6] = 0x48;
   p[ 7] = 0x18;

   v = NSSwapHostDoubleToBig( 2.4380743395473987e-289);
   UKIntsEqual( 0, memcmp( &x, &v, sizeof( NSSwappedDouble)));
}


static void   test_NSSwapHostFloatToBig( void)
{
   NSSwappedFloat    x;
   unsigned char     *p;
   NSSwappedFloat    v;

   p     = (unsigned char *) &x;

   // value a little different than long long
   p[ 0] = 0x04;
   p[ 1] = 0x03;
   p[ 2] = 0x02;
   p[ 3] = 0x01;

   v = NSSwapHostFloatToBig( 1.53998961443955806e-36);
   UKIntsEqual( 0, memcmp( &x, &v, sizeof( NSSwappedFloat)));
}


static void   test_NSSwapLittleDoubleToHost( void)
{
   NSSwappedDouble   x;
   unsigned char     *p;
   double            v;

   p     = (unsigned char *) &x;

   // value a little different than long long
   p[ 7] = 0x04;
   p[ 6] = 0x03;
   p[ 5] = 0x02;
   p[ 4] = 0x01;
   p[ 3] = 0xCD;
   p[ 2] = 0xAB;
   p[ 1] = 0x48;
   p[ 0] = 0x18;

   v = NSSwapLittleDoubleToHost( x);
   UKFloatsEqual( 2.4380743395473987e-289, v, 0.0);
}


static void   test_NSSwapLittleFloatToHost( void)
{
   NSSwappedFloat    x;
   unsigned char     *p;
   float             v;

   p     = (unsigned char *) &x;

   // value a little different than long long
   p[ 3] = 0xCD;
   p[ 2] = 0xAB;
   p[ 1] = 0x48;
   p[ 0] = 0x18;

   v = NSSwapLittleFloatToHost( x);
   UKFloatsEqual( -359203584, v, 0.0);
}


static void   test_NSSwapHostDoubleToLittle( void)
{
   NSSwappedDouble   x;
   NSSwappedDouble   v;
   unsigned char     *p;

   p     = (unsigned char *) &x;

   // value a little different than long long
   p[ 7] = 0x04;
   p[ 6] = 0x03;
   p[ 5] = 0x02;
   p[ 4] = 0x01;
   p[ 3] = 0xCD;
   p[ 2] = 0xAB;
   p[ 1] = 0x48;
   p[ 0] = 0x18;

   v = NSSwapHostDoubleToLittle( 2.4380743395473987e-289);
   UKIntsEqual( 0, memcmp( &x, &v, sizeof( NSSwappedDouble)));
}


static void   test_NSSwapHostFloatToLittle( void)
{
   NSSwappedFloat   x;
   NSSwappedFloat   v;
   unsigned char    *p;

   p     = (unsigned char *) &x;

   // value a little different than long long
   p[ 3] = 0xCD;
   p[ 2] = 0xAB;
   p[ 1] = 0x48;
   p[ 0] = 0x18;

   v = NSSwapHostFloatToLittle( -359203584);
   UKIntsEqual( 0, memcmp( &x, &v, sizeof( NSSwappedFloat)));
}



void  test_common_NSByteOrder( void);

//
// as these functions are run in their own process, we
// don't care about leaks
//
void  test_common_NSByteOrder()
{
   UKRunTestFunction( test_NSSwapShort);
   UKRunTestFunction( test_NSSwapInt);
   UKRunTestFunction( test_NSSwapLong);
   UKRunTestFunction( test_NSSwapLongLong);

   UKRunTestFunction( test_NSSwapFloat);
   UKRunTestFunction( test_NSSwapDouble);

   UKRunTestFunction( test_NSSwapBigShortToHost);
   UKRunTestFunction( test_NSSwapBigIntToHost);
   UKRunTestFunction( test_NSSwapBigLongToHost);
   UKRunTestFunction( test_NSSwapBigLongLongToHost);

   UKRunTestFunction( test_NSSwapHostShortToBig);
   UKRunTestFunction( test_NSSwapHostIntToBig);
   UKRunTestFunction( test_NSSwapHostLongToBig);
   UKRunTestFunction( test_NSSwapHostLongLongToBig);

   UKRunTestFunction( test_NSSwapLittleShortToHost);
   UKRunTestFunction( test_NSSwapLittleIntToHost);
   UKRunTestFunction( test_NSSwapLittleLongToHost);
   UKRunTestFunction( test_NSSwapLittleLongLongToHost);

   UKRunTestFunction( test_NSSwapHostShortToLittle);
   UKRunTestFunction( test_NSSwapHostIntToLittle);
   UKRunTestFunction( test_NSSwapHostLongToLittle);
   UKRunTestFunction( test_NSSwapHostLongLongToLittle);

   UKRunTestFunction( test_NSConvertSwappedFloatToHost);
   UKRunTestFunction( test_NSConvertSwappedDoubleToHost);

   UKRunTestFunction( test_NSConvertHostFloatToSwapped);
   UKRunTestFunction( test_NSConvertHostDoubleToSwapped);

   UKRunTestFunction( test_NSSwapBigDoubleToHost);
   UKRunTestFunction( test_NSSwapBigFloatToHost);
   UKRunTestFunction( test_NSSwapHostDoubleToBig);
   UKRunTestFunction( test_NSSwapHostFloatToBig);

   UKRunTestFunction( test_NSSwapLittleDoubleToHost);
   UKRunTestFunction( test_NSSwapLittleFloatToHost);
   UKRunTestFunction( test_NSSwapHostDoubleToLittle);
   UKRunTestFunction( test_NSSwapHostFloatToLittle);
}
