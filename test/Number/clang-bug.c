#include <stdio.h>
// Type your code here, or load an example.
#include <limits.h>
#include <stdlib.h>
#include <assert.h>
#include <float.h>


int   fits_llong( double value)
{
    long long  l_val;

    if( value <= (double) LLONG_MAX)
    {
        l_val = (long long) value;
        mulle_fprintf( stderr, "Considering %f as %lld\n", value, l_val);
        return( l_val == value);
    }
    return( 0);
}


int   main( int argc, char *argv[])
{
   double  value;

   assert( (double) LLONG_MAX <= DBL_MAX);

   // keep my code optimiza
   if( argc == 1)
      value = (double) LLONG_MAX;
   else
      value = (double) (LLONG_MAX - atoi( argv[ 1]));

   if( fits_llong( value))
      mulle_printf( "FITS\n");
   else
      mulle_printf( "NOPE\n");
   return( 0);
}