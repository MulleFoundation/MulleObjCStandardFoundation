//
//  mulle-mini-tm.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2021 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#ifndef mulle_mini_tm_h__
#define mulle_mini_tm_h__

#include <stdint.h>


#define mulle_mini_tm_min_year ((int) (~0UL << 17))
#define mulle_mini_tm_max_year ((int) (1UL << 17))

//
// 64 bit large, supports only gregorian really at the moment
//
struct mulle_mini_tm
{
   unsigned int     type    : 6;    // 0: gregorian (0-63)
   unsigned int     second  : 6;    // 0-59 (63)
   unsigned int     minute  : 6;    // 0-59 (63)
   unsigned int     hour    : 5;    // 0-23 (31)
   unsigned int     day     : 5;    // 1-31 (31)
   unsigned int     month   : 4;    // 1-12 (15)

   // universe age 13,81 ± 0,04 Mrd. Jahre[2]
   // 13,810,000,000 years 0x33723e080  (does not fit :/()
   // age of earth 4,54 ± 0.05 also too large
   int32_t          year;
};


static inline int   mulle_mini_tm_equal_tm( struct mulle_mini_tm a,
                                            struct mulle_mini_tm b)
{
   return( a.type   == b.type &&
           a.year   == b.year &&
           a.month  == b.month &&
           a.day    == b.day &&
           a.hour   == b.hour &&
           a.minute == b.minute &&
           a.second == b.second);  // gimme hope compiler
}

#endif
