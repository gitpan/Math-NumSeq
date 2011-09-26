#!/usr/bin/perl -w

# Copyright 2010, 2011 Kevin Ryde

# This file is part of Math-NumSeq.
#
# Math-NumSeq is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# Math-NumSeq is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.

use 5.004;
use strict;
use Test::More;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

# uncomment this to run the ### lines
#use Devel::Comments '###';

use POSIX ();
POSIX::setlocale(POSIX::LC_ALL(), 'C'); # no message translations

use constant DBL_INT_MAX => (POSIX::FLT_RADIX() ** POSIX::DBL_MANT_DIG());
use constant MY_MAX => (POSIX::FLT_RADIX() ** (POSIX::DBL_MANT_DIG()-5));

{
  require Math::BigInt;
  MyTestHelpers::diag ('Math::BigInt version ', Math::BigInt->VERSION);

  my $n = Math::BigInt->new(1);
  if (! $n->can('bsqrt')) {
    MyTestHelpers::diag ('skip due to Math::BigInt no bsqrt()');
    plan skip_all => 'skip due to Math::BigInt no bsqrt()';
  }
}

plan tests => 114;

sub diff_nums {
  my ($gotaref, $wantaref) = @_;
  for (my $i = 0; $i < @$gotaref; $i++) {
    if ($i > @$wantaref) {
      return "want ends prematurely i=$i";
    }
    my $got = $gotaref->[$i];
    my $want = $wantaref->[$i];
    if (! defined $got && ! defined $want) {
      next;
    }
    if (! defined $got || ! defined $want) {
      return "different i=$i got=".(defined $got ? $got : '[undef]')
        ." want=".(defined $want ? $want : '[undef]');
    }
    if ($got != $want) {
      return "different i=$i numbers got=$got want=$want";
    }
  }
  return undef;
}

sub _delete_duplicates {
  my ($arrayref) = @_;
  my %seen;
  @seen{@$arrayref} = ();
  @$arrayref = sort {$a<=>$b} keys %seen;
}

sub _min {
  my $ret = shift;
  while (@_) {
    my $next = shift;
    if ($ret > $next) {
      $ret = $next;
    }
  }
  return $ret;
}

#------------------------------------------------------------------------------
# Math::NumSeq various classes

foreach my $elem
  (
   # ChampernowneBinaryLsb.pm
   # PrimeFactorCount.pm
   # DigitsModulo.pm~
   # DigitsModulo.pm
   # Expression.pm~
   # Expression.pm
   # FractionDigits.pm
   # Ln2Bits.pm~
   # Ln2Bits.pm
   # MobiusFunction.pm
   # PiBits.pm~
   # PiBits.pm
   # Repdigits.pm
   # SqrtDigits.pm

   [ 'Math::NumSeq::DigitSumModulo', 0,
     [ 0,  # 00
       1,  # 01
       1,  # 10
       2,  # 11,
       1,  # 100
       2,  # 101
       2,  # 110
       0,  # 111
       1,  # 1000
     ],
     { radix => 2, modulus => 3 } ],

   [ 'Math::NumSeq::DigitProduct', 0,
     [ 0,
       1,
       0,  # 10
       1,  # 11,
       0,
       0,
       0,
       1,  # 111
       0, ],
     { radix => 2 } ],

   [ 'Math::NumSeq::DigitProduct', 0,
     [ 0,1,2,
       0,1,2,
       0,2,4,  # 20,21,22
       
       0,0,0,  # 100,101,102
       0,1,2,
       0,2,4,

       0,0,0,
       0,2,4,
       0,4,8, ],
     { radix => 3 } ],

   [ 'Math::NumSeq::SqrtDigits', 0,
     [ 1, 0, 1, 1, 0, 1, 0, 1, 0, ],
     { radix => 2, sqrt => 2 } ],

   [ 'Math::NumSeq::FractionDigits', 0,
     [ 0,9,0,9,0,9,0,9,0,9,0,9, ],
     { fraction => '1/11' } ],

   [ 'Math::NumSeq::ProthNumbers', 0,
     [ 3, 5, 9, 13, 17, 25, 33, 41, 49, 57, 65, 81, 97, 113, 129, 145,
       161, 177, 193, 209, 225, 241, 257, 289, 321, 353, 385, 417, 449, 481,
       513, 545, 577, 609, 641, 673, 705, 737, 769, 801, 833, 865, 897, 929,
       961, 993, 1025, 1089, 1153, 1217, 1281, 1345, 1409 ] ],

   # [ 'Math::NumSeq::TotientSum', 0,
   #   [ 0, 1, 2, 4, 6, 10, 12, 18, 22, 28, 32, 42 ],
   # ],
   #
   # [ 'Math::NumSeq::Loeschian', 0,
   #   [ 0,1,3,4,7,9,12,13,16,19,21,25 ] ],
   
   [ 'Math::NumSeq::DigitCount', 0,
     [ 0,1,1,2,
       1,2,2,3,
       1,2,2,3,
       2,3,3,4 ],
     { radix => 2,
     } ],
   [ 'Math::NumSeq::DigitCount', 0,
     [ 0,  # 0
       0,  # 1
       1,  # 10
       0,  # 11
       2,  # 100
       1,  # 101
       1,  # 110
       0,  # 111
       3,  # 1000
       2,  # 1001
     ],
     { radix => 2,
       digit => 0,
     } ],
   [ 'Math::NumSeq::DigitCount', 0,
     [ 0,0,0,0,0,
       0,0,0,0,1,
       0,0,0,0,0,
       0,0,0,0,1,
     ],
     { radix => 10,
       digit => 9,
     } ],
   
   # [ 'Math::NumSeq::DigitCountLow', 0,
   #   [ 0,  # 0
   #     0,  # 1
   #     1,  # 10
   #     0,  # 11
   #     2,  # 100
   #     0,  # 101
   #     1,  # 110
   #     0,  # 111
   #     3,  # 1000
   #   ],
   #   { radix => 2,
   #     digit => 0,
   #   } ],
   # [ 'Math::NumSeq::DigitCountLow', 0,
   #   [ 0,  # 0
   #     1,  # 1
   #     0,  # 10
   #     2,  # 11
   #     0,  # 100
   #     1,  # 101
   #     0,  # 110
   #     3,  # 111
   #   ],
   #   { radix => 2,
   #     digit => 1,
   #   } ],
   # [ 'Math::NumSeq::DigitCountLow', 0,
   #   [ 0,  # 0
   #     0,  # 1
   #     0,  # 2
   #     1,  # 10
   #     0,  # 11
   #     0,  # 12
   #     1,  # 20
   #     0,  # 21
   #     0,  # 22
   #     2,  # 100
   #   ],
   #   { radix => 3,
   #     digit => 0,
   #   } ],
   # [ 'Math::NumSeq::DigitCountLow', 0,
   #   [ 0,  # 0
   #     0,  # 1
   #     0,  # 2
   #     0,  # 3
   #     0,  # 4
   #     1,  # 10
   #     0,  # 11
   #     0,  # 12
   #     0,  # 13
   #     0,  # 14
   #     1,  # 20
   #     0,  # 21
   #     0,  # 22
   #     0,  # 23
   #     0,  # 24
   #     1,  # 30
   #   ],
   #   { radix => 5,
   #     digit => 0,
   #   } ],


   [ 'Math::NumSeq::CullenNumbers', 0,
     [ 1, 3, 9, 25, 65, 161, 385, 897, 2049, 4609, ] ],

   # [ 'Math::NumSeq::SumXsq3Ysq', 0,
   #   [ 4,7,12,13,16,19,21,28,31,36,37 ] ],
   #
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0, 1, 3, 5, 7, 9, 15, 17, 21, 27, 31, 33, 45, 51,
   #     63, 65, 73, 85, 93, 99, 107, 119, 127, 129, 153,
   #     165, 189, 195, 219, 231, 255, 257, 273, 297, 313,
   #     325, 341, 365, 381, 387, 403, 427, 443, 455, 471,
   #     495, 511, 513, 561, 585, 633, 645, 693, 717, 765,
   #     771, 819, 843, ],
   #   { radix => 2 },
   # ],
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0, 1, 2, 4, 8, 10, 13, 16, 20, 23, 26, 28, 40, 52,
   #     56, 68, 80, 82, 91, 100, 112, 121, 130, 142, 151,
   #     160, 164, 173, 182, 194, 203, 212, 224, 233, 242,
   #     244, 280, 316, 328, 364, 400, 412, 448, 484, 488,
   #     524, 560, 572, 608, 644, 656, 692, 728, 730, 757,
   #     784, 820, 847, 874, 910, ],
   #   { radix => 3 },
   # ],
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0, 1, 2, 3, 5, 10, 15, 17, 21, 25, 29, 34, 38, 42,
   #     46, 51, 55, 59, 63, 65, 85, 105, 125, 130, 150, 170,
   #     190, 195, 215, 235, 255, 257, 273, 289, 305, 325, 341,
   #     357, 373, 393, 409, 425, 441, 461, 477, 493, 509, 514,
   #     530, 546, 562, 582, 598, 614, 630, 650, 666, 682, 698,
   #     718, 734, ],
   #   { radix => 4 },
   # ],
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0, 1, 2, 3, 4, 6, 12, 18, 24, 26, 31, 36, 41, 46,
   #     52, 57, 62, 67, 72, 78, 83, 88, 93, 98, 104, 109, 114,
   #     119, 124, 126, 156, 186, 216, 246, 252, 282, 312, 342,
   #     372, 378, 408, 438, 468, 498, 504, 534, 564, 594, 624,
   #     626, 651, 676, 701, 726, 756, 781, ],
   #   { radix => 5 },
   # ],
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0, 1, 2, 3, 4, 5, 7, 14, 21, 28, 35, 37, 43, 49, 55,
   #     61, 67, 74, 80, 86, 92, 98, 104, 111, 117, 123, 129,
   #     135, 141, 148, 154, 160, 166, 172, 178, 185, 191, 197,
   #     203, 209, 215, 217, 259, 301, 343, 385, 427, 434, 476,
   #     518, 560, 602, 644, 651, 693, 735, ],
   #   { radix => 6 },
   # ],
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0, 1, 2, 3, 4, 5, 6, 8, 16, 24, 32, 40, 48, 50, 57,
   #     64, 71, 78, 85, 92, 100, 107, 114, 121, 128, 135, 142,
   #     150, 157, 164, 171, 178, 185, 192, 200, 207, 214, 221,
   #     228, 235, 242, 250, 257, 264, 271, 278, 285, 292, 300,
   #     307, 314, 321, 328, 335, 342, ],
   #   { radix => 7 },
   # ],
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0, 1, 2, 3, 4, 5, 6, 7, 9, 18, 27, 36, 45, 54, 63,
   #     65, 73, 81, 89, 97, 105, 113, 121, 130, 138, 146, 154,
   #     162, 170, 178, 186, 195, 203, 211, 219, 227, 235, 243,
   #     251, 260, 268, 276, 284, 292, 300, 308, 316, 325, 333,
   #     341, 349, 357, 365, 373, 381, 390, ],
   #   { radix => 8 },
   # ],
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 20, 30, 40, 50, 60,
   #     70, 80, 82, 91, 100, 109, 118, 127, 136, 145, 154,
   #     164, 173, 182, 191, 200, 209, 218, 227, 236, 246, 255,
   #     264, 273, 282, 291, 300, 309, 318, 328, 337, 346, 355,
   #     364, 373, 382, 391, 400, 410, 419, ],
   #   { radix => 9 },
   # ],
   # [ 'Math::NumSeq::Palindromes', 0,
   #   [ 0,1,2,3,4,5,6,7,8,9,
   #     11,22,33,44,55,66,77,88,99,
   #     101,111,121,131,141,151,161,171,181,191,
   #     202,212,222,232,242,252,262,272,282,292,
   #     303,313,323,333,343,353,363,373,383,393,
   #     404,414,424,434,444,454,464,474,484,494,
   #     505,515,525,535,545,555,565,575,585,595,
   #     606,616,626,636,646,656,666,676,686,696,
   #     707,717,727,737,747,757,767,777,787,797,
   #     808,818,828,838,848,858,868,878,888,898,
   #     909,919,929,939,949,959,969,979,989,999,
   #     1001,1111,1221,1331,1441,1551,1661,1771,1881,1991,
   #   ] ],

   [ 'Math::NumSeq::Factorials', 0,
     [ 1, 1, 2, 6, 24, 120, 720 ],
   ],

   [ 'Math::NumSeq::Primorials', 0,
     [ 1, 2, 6, 30, 210, ],
   ],

   # [ 'Math::NumSeq::SumTwoSquares', 1,
   #   [ 2, 5, 8, 10, 13, 17, 18, 20, 25, 26, 29, 32, 34, 37,
   #     40, 41, 45, 50, 52, 53, 58, 61, 65, 68, 72, 73, 74,
   #     80, 82, 85, 89, 90, 97, 98, 100, 101, 104, 106, 109,
   #     113, 116, 117, 122, 125, 128, 130, 136, 137, 145,
   #     146, 148, 149, 153, 157, 160, 162, 164, 169, 170,
   #     173, 178 ] ],
   #
   # [ 'Math::NumSeq::PythagoreanHypots', 1,
   #   [ 5, 10, 13, 15, 17, 20, 25, 26, 29, 30 ] ],
   #
   # [ 'Math::NumSeq::All', 0,
   #   [ 0, 1, 2, 3, 4, 5, 6, 7 ] ],
   # [ 'Math::NumSeq::All', 17,
   #   [ 17, 18, 19 ] ],
   #
   [ 'Math::NumSeq::Odd', 1,
     [ 1, 3, 5, 7, 9, 11, 13 ] ],
   [ 'Math::NumSeq::Odd', 6,
     [ 7, 9, 11, 13 ] ],

   [ 'Math::NumSeq::Even', 0,
     [ 0, 2, 4, 6, 8, 10, 12 ] ],
   [ 'Math::NumSeq::Even', 5,
     [ 6, 8, 10, 12 ] ],

   # [ 'Math::NumSeq::Multiples', 0,
   #   [ 0, 2, 4, 6, 8, 10, 12 ],
   #   { multiples => 2 },
   # ],
   #
   # [ 'Math::NumSeq::Obstinate', 1,
   #   [ 1, 3, 127, ] ],

   # [ 'Math::NumSeq::Fibonacci', 1,
   #   [ 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144,
   #     233, 377, 610, 987, 1597, ] ],

   # [ 'Math::NumSeq::Tribonacci', 0,
   #   [ 0, 0, 1, 1, 2, 4, 7, 13, 24, ],
   # ],
   #
   # [ 'Math::NumSeq::Abundant', 0,
   #   [  12, 18, 20, 24, 30 ],
   # ],
   #
   # [ 'Math::NumSeq::Lucas', 0,
   #   [  1, 3, 4, 7, 11, 18, 29 ],
   # ],
   # [ 'Math::NumSeq::RepdigitAnyBase', 0,
   #   [  0,
   #      7,  # 111 base 2
   #      13, # 111 base 3
   #      15, # 1111 base 2
   #      21, # 111 base 4
   #      26, # 222 base 3
   #      31, # 11111 base 2
   #   ],
   # ],

   [ 'Math::NumSeq::RadixWithoutDigit', 0,
     [ 1, 2,    # 1,2
       4,5,     # 11,12
     ],
     { radix => 3,
       digit => 0,
     },
   ],
   [ 'Math::NumSeq::RadixWithoutDigit', 0,
     [ 0, 2,    # 0,2
       6, 8,    # 20, 22
     ],
     { radix => 3,
       digit => 1,
     },
   ],
   [ 'Math::NumSeq::RadixWithoutDigit', 0,
     [ 0, 1,    # 0,1
       3, 4,    # 10, 11
       # 6, 7,    # 20, 21
       9, 10,   # 100, 101
       12, 13,  # 110, 111
       27, 28,  # 1000, 1001
     ],
     { radix => 3,
       digit => 2,
     },
   ],

   [ 'Math::NumSeq::RadixWithoutDigit', 0,
     [ 0x01, 0x02, 0x03,    # 1,2,3
       0x05, 0x06, 0x07,    # 11,12,13
       0x09, 0x0A, 0x0B,    # 21,22,23
       0x0D, 0x0E, 0x0F,    # 31,32,33
       0x15, 0x16, 0x17,    # 111,112,113
     ],
     { radix => 4,
       digit => 0,
     },
   ],
   [ 'Math::NumSeq::RadixWithoutDigit', 0,
     [ 0x00, 0x02, 0x03,    # 0,2,3
       0x08, 0x0A, 0x0B,    # 20,22,23
     ],
     { radix => 4,
       digit => 1,
     },
   ],
   [ 'Math::NumSeq::RadixWithoutDigit', 0,
     [ 0x00, 0x01, 0x03,    # 0,1,3
       0x04, 0x05, 0x07,    # 10,11,13
     ],
     { radix => 4,
       digit => 2,
     },
   ],
   [ 'Math::NumSeq::RadixWithoutDigit', 0,
     [ 0x00, 0x01, 0x02,    # 0,1,2
       0x04, 0x05, 0x06,    # 10,11,12
       0x08, 0x09, 0x0A,    # 20,21,22
       0x10, 0x11, 0x12,    # 100,101,102
       0x14, 0x15, 0x16,    # 200,201,202
     ],
     { radix => 4,
       digit => 3,
     },
   ],

   #
   # [ 'Math::NumSeq::Base4Without3', 0,
   #   [ 0x00, 0x01, 0x02,    # 0,1,2
   #     0x04, 0x05, 0x06,    # 10,11,12
   #     0x08, 0x09, 0x0A,    # 20,21,22
   #     0x10, 0x11, 0x12,    # 100,101,102
   #     0x14, 0x15, 0x16,    # 200,201,202
   #   ] ],
   #
   # [ 'Math::NumSeq::TernaryWithout2', 0,
   #   [ 0, 1,    # 0,1
   #     3, 4,    # 10, 11
   #     # 6, 7,    # 20, 21
   #     9, 10,   # 100, 101
   #     12, 13,  # 110, 111
   #     27, 28,  # 1000, 1001
   #   ] ],

   [ 'Math::NumSeq::StarNumbers', 0,
     [ 1, 13, 37, 73, 121, ],
   ],

   # [ 'Math::NumSeq::Pentagonal', 0,
   #   [ 0,1,5,12,22 ],
   #   { pairs => 'first' } ],
   # [ 'Math::NumSeq::Pentagonal', 0,
   #   [ 0,2,7,15,26 ],
   #   { pairs => 'second' } ],
   # [ 'Math::NumSeq::Pentagonal', 0,
   #   [ 0,1,2,5,7,12,15,22,26 ],
   #   { pairs => 'both' } ],

   # not yet
   # [ 'Math::NumSeq::Pentagonal', 0,
   #   [ 0, 1.5, 6, 13,5, 24 ],
   #   { pairs => 'average' } ],

   [ 'Math::NumSeq::Polygonal', 0,
     [ 0, 1, 3, 6, 10, 15, 21 ],  # triangular
     { polygonal => 3 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,
     [ 0, 1, 4, 9, 16 ],    # squares
     { polygonal => 4 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,
     [ 0,1,5,12,22 ],    # pentagonal
     { polygonal => 5 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,
     [ 0,1,5,12,22 ],    # pentagonal
     { polygonal => 5 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,
     [ 0, 1, 6, 15, 28, 45, 66 ],    # hexagonal
     { polygonal => 6 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,
     [ 0, 1, 7, 18, 34, 55, 81, ],    # heptagonal
     { polygonal => 7 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,
     [ 0, 1, 8, 21, 40, 65, 96, ],    # octagonal
     { polygonal => 8 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,                  # nonagonal
     [ 0, 1, 9, 24, 46, 75, 111, 154, 204, 261, 325, 396,
       474, 559, 651, 750, 856, 969, ],
     { polygonal => 9 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,
     [ 0, 1, 10, 27, 52, 85, 126, 175 ],    # decagonal
     { polygonal => 10 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,
     [ 0, 1, 11, 30, 58, 95, 141, 196, 260 ],  # hendecagonal
     { polygonal => 11 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,  # 12-gonal
     [ 0, 1, 12, 33, 64, 105, 156, 217, 288, 369, 460, 561,
       672, 793, 924, 1065, 1216, 1377, 1548, 1729, 1920,
       2121, 2332, 2553, 2784, 3025, 3276, 3537, 3808,
       4089, 4380, 4681, 4992, 5313, 5644, 5985, 6336,
       6697, 7068, 7449, 7840, 8241, 8652 ],
     { polygonal => 12 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,  # 13-gonal
     [ 0, 1, 13, 36, 70, 115, 171, 238, 316, 405, 505, 616,
       738, 871, 1015, ],
     { polygonal => 13 },
   ],
   [ 'Math::NumSeq::Polygonal', 0,  # 14-gonal
     [ 0, 1, 14, 39, 76, 125, 186, ],
     { polygonal => 14 },
   ],


   [ 'Math::NumSeq::Tetrahedral', 0,
     [ 0, 1, 4, 10, 20, 35, 56, 84, 120 ] ],

   # # with a!=b
   # [ 'Math::NumSeq::UndulatingNumbers', 0,
   #   [ 0,1,2,3,4,5,6,7,8,9,
   #     10,12,13,14,15,16,17,18,19,
   #     20,21,23,24,25,26,27,28,29,
   #     30,31,32,34,35,36,37,38,39,
   #     40,41,42,43,45,46,47,48,49,
   #     50,51,52,53,54,56,57,58,59,
   #     60,61,62,63,64,65,67,68,69,
   #     70,71,72,73,74,75,76,78,79,
   #     80,81,82,83,84,85,86,87,89,
   #     90,91,92,93,94,95,96,97,98,
   #     101,121,131,141,151,161,171,181,191,
   #     202,212,232,242,252,262,272,282,292,
   #     303,313,323,343,353,363,373,383,393,
   #     404,414,424,434,454,464,474,484,494,
   #     505,515,525,535,545,565,575,585,595,
   #     606,616,626,636,646,656,676,686,696,
   #     707,717,727,737,747,757,767,787,797,
   #     808,818,828,838,848,858,868,878,898,
   #     909,919,929,939,949,959,969,979,989,
   #     1010,1212,1313,1414,1515,1616,1717,1818,1919,
   #   ] ],
   #
   # # with a!=b
   # [ 'Math::NumSeq::UndulatingNumbers', 0,
   #   [ 0x0,   # 0b00
   #     0x1,   # 0b01
   #     0x2,   # 0b10
   #     0x5,   # 0b101
   #     0xA,   # 0b1010
   #     0x15,  # 0b10101
   #     0x2A,  # 0b101010
   #     0x55,  # 0b1010101
   #     0xAA,  # 0b1010_1010
   #     0x155, # 0b1_0101_0101
   #   ],
   #   { radix => 2 },
   # ],
   #
   # # # http://oeis.org/A033619
   # # # including a==b
   # # [ 'Math::NumSeq::UndulatingNumbers', 0,
   # #   [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
   # #     15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
   # #     28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
   # #     41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53,
   # #     54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66,
   # #     67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
   # #     80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92,
   # #     93, 94, 95, 96, 97, 98, 99, 101, 111, 121, 131, 141,
   # #     151 ] ],

   [ 'Math::NumSeq::Emirps', 0,
     [ 13, 17, 31, 37, 71, 73, 79, 97, 107, 113, 149, 157,
       167, 179, 199, 311, 337, 347, 359, 389, 701, 709,
       733, 739, 743, 751, 761, 769, 907, 937, 941, 953,
       967, 971, 983, 991, 1009, 1021, 1031, 1033, 1061,
       1069, 1091, 1097, 1103, 1109, 1151, 1153, 1181, 1193
     ] ],

   [ 'Math::NumSeq::Squares', 0,
     [ 0, 1, 4, 9, 16, 25 ] ],
   [ 'Math::NumSeq::Squares', 3,
     [ 4, 9, 16, 25 ] ],

   [ 'Math::NumSeq::Cubes', 0,
     [ 0, 1, 8, 27, 64, 125 ] ],
   [ 'Math::NumSeq::Cubes', 3,
     [ 8, 27, 64, 125 ] ],

   [ 'Math::NumSeq::Triangular', 0,
     [ 0, 1, 3, 6, 10, 15, 21 ] ],
   [ 'Math::NumSeq::Triangular', 5,
     [ 6, 10, 15, 21 ] ],

   [ 'Math::NumSeq::Pronic', 0,
     [ 0, 2, 6, 12, 20, 30, 42 ] ],
   [ 'Math::NumSeq::Pronic', 5,
     [ 6, 12, 20, 30, 42 ] ],

   # [ 'Math::NumSeq::Perrin', 0,
   #   [ 3, 0, 2, 3, 2, 5, 5, 7, 10, 12, 17 ] ],
   # [ 'Math::NumSeq::Padovan', 0,
   #   [ 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12 ],
   #   undef,
   #   { bfile_offset => 5 } ],
   #
   # [ 'Math::NumSeq::Pell', 0,
   #   [ 0, 1, 2, 5, 12, 29, 70, 169, 408, 985, 2378, 5741,
   #     13860, 33461, 80782, 195025, 470832, 1136689,
   #   ] ],
   # [ 'Math::NumSeq::Pell', 6,
   #   [ 12, 29, 70, 169, 408, 985, 2378, 5741,
   #     13860, 33461, 80782, 195025, 470832, 1136689,
   #   ] ],
   
   [ 'Math::NumSeq::Primes', 1,
     [ 2, 3, 5, 7, 11, 13, 17 ] ],
   # [ 'Math::NumSeq::Primes', 10,
   #   [ 11, 13, 17 ] ],
   
   [ 'Math::NumSeq::TwinPrimes', 0,
     [ 3, 5, 7, 11, 13, 17, 19, 29, 31 ],
     { pairs => 'both' },
   ],
   # [ 'Math::NumSeq::TwinPrimes', 10,
   #   [ 11, 13, 17, 19, 29, 31 ],
   #   { pairs => 'both' },
   # ],
   
   [ 'Math::NumSeq::TwinPrimes', 0,
     [ 3, 5, 11, 17, 29 ],
     { pairs => 'first' },
   ],
   # [ 'Math::NumSeq::TwinPrimes', 4,
   #   [ 5, 11, 17, 29 ],
   #   { pairs => 'first' },
   # ],
   
   [ 'Math::NumSeq::TwinPrimes', 0,
     [ 5, 7, 13, 19, 31 ],
     { pairs => 'second' },
   ],
   # [ 'Math::NumSeq::TwinPrimes', 6,
   #   [ 7, 13, 19, 31 ],
   #   { pairs => 'second' },
   # ],
   
   # # sloanes
   # # http://oeis.org/A001358
   # [ 'Math::NumSeq::SemiPrimes', 0,
   #   [ 4, 6, 9, 10, 14, 15, 21, 22, 25, 26, 33, 34, 35, 38,
   #     39, 46, 49, 51, 55, 57, 58, 62, 65, 69, 74, 77, 82,
   #     85, 86, 87, 91, 93, 94, 95, 106, 111, 115, 118, 119,
   #     121, 122, 123, 129, 133, 134, 141, 142, 143, 145,
   #     146, 155, 158, 159, 161, 166, 169, 177, 178, 183,
   #     185, 187 ] ],
   #
   # # [ 'Math::NumSeq::SemiPrimesOdd', 0,
   # #   [ 9, 15, 21, 25, 33, 35,
   # #     39, 49, 51, 55, 57, 65, 69, 77,
   # #   ] ],

   # http://oeis.org/A005384
   [ 'Math::NumSeq::SophieGermainPrimes', 0,
     [ 2, 3, 5, 11, 23, 29, 41, 53, 83, 89, 113, 131, 173,
       179, 191, 233, 239, 251, 281, 293, 359, 419, 431,
       443, 491, 509, 593, 641, 653, 659, 683, 719, 743,
       761, 809, 911, 953, 1013, 1019, 1031, 1049, 1103,
       1223, 1229, 1289, 1409, 1439, 1451, 1481, 1499,
       1511, 1559 ],
   ],
   
   # # http://oeis.org/A005385
   # [ 'Math::NumSeq::SafePrimes', 0,
   #   [ 5, 7, 11, 23, 47, 59, 83, 107, 167, 179, 227, 263,
   #     347, 359, 383, 467, 479, 503, 563, 587, 719, 839,
   #     863, 887, 983, 1019, 1187, 1283, 1307, 1319, 1367,
   #     1439, 1487, 1523, 1619, 1823, 1907, 2027, 2039,
   #     2063, 2099, 2207, 2447, 2459, 2579, 2819, 2879, 2903,
   #   ],
   # ],
   #
   # # sloanes
   # # http://oeis.org/A005224
   # [ 'Math::NumSeq::Aronson', 0,
   #   [ 1, 4, 11, 16, 24, 29, 33, 35, 39, 45, 47, 51, 56, 58,
   #     62, 64, 69, 73, 78, 80, 84, 89, 94, 99, 104, 111,
   #     116, 122, 126, 131, 136, 142, 147, 158, 164, 169,
   #     174, 181, 183, 193, 199, 205, 208, 214, 220, 226,
   #     231, 237, 243, 249, 254, 270, 288, 303, 307, 319,
   #     323, 341 ],
   #   { conjunctions => 0 },
   #   { module => 'Math::Aronson' },
   # ],
   #
   # # sloanes
   # # http://www.research.att.com/%7Enjas/sequences/A079000
   # [ 'Math::NumSeq::NumaronsonA', 0,
   #   [ 1, 4, 6, 7, 8, 9, 11, 13, 15, 16, 17, 18, 19, 20,
   #     21, 23, 25, 27, 29, 31, 33, 34, 35, 36, 37, 38, 39,
   #     40, 41, 42, 43, 44, 45, 47, 49, 51, 53, 55, 57, 59,
   #     61, 63, 65, 67, 69, 70, 71, 72, 73, 74, 75, 76, 77,
   #     78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
   #     91, 92, 93, 95, 97 ],
   #   undef,
   # ],

   # [ 'Math::NumSeq::ThueMorseEvil', 0,
   #   [ 0, 3, 5, 6, 9, 10, 12, 15, 17, 18, 20, 23, 24, 27,
   #     29, 30, 33, 34, 36, 39, 40, 43, 45, 46, 48, 51, 53,
   #     54, 57, 58, 60, 63, 65, 66, 68, 71, 72, 75, 77, 78,
   #     80, 83, 85, 86, 89, 90, 92, 95, 96, 99, 101, 102,
   #     105, 106, 108, 111, 113, 114, 116, 119, 120, 123,
   #     125, 126, 129 ] ],
   # [ 'Math::NumSeq::ThueMorseEvil', 1, [ 3, 5, 6, 9 ] ],
   # [ 'Math::NumSeq::ThueMorseEvil', 2, [ 3, 5, 6, 9 ] ],
   # [ 'Math::NumSeq::ThueMorseEvil', 3, [ 3, 5, 6, 9 ] ],
   # [ 'Math::NumSeq::ThueMorseEvil', 4, [ 5, 6, 9 ] ],
   # [ 'Math::NumSeq::ThueMorseEvil', 5, [ 5, 6, 9 ] ],
   #
   # [ 'Math::NumSeq::ThueMorseOdious', 0,
   #   [ 1, 2, 4, 7, 8, 11, 13, 14, 16, 19, 21, 22, 25, 26,
   #     28, 31, 32, 35, 37, 38, 41, 42, 44, 47, 49, 50, 52,
   #     55, 56, 59, 61, 62, 64, 67, 69, 70, 73, 74, 76, 79,
   #     81, 82, 84, 87, 88, 91, 93, 94, 97, 98, 100, 103,
   #     104, 107, 109, 110, 112, 115, 117, 118, 121, 122,
   #     124, 127, 128 ] ],
   # [ 'Math::NumSeq::ThueMorseOdious', 1, [ 1, 2, 4, 7, ] ],
   # [ 'Math::NumSeq::ThueMorseOdious', 2, [ 2, 4, 7, ] ],
   # [ 'Math::NumSeq::ThueMorseOdious', 3, [ 4, 7, ] ],
   # [ 'Math::NumSeq::ThueMorseOdious', 4, [ 4, 7, ] ],
   # [ 'Math::NumSeq::ThueMorseOdious', 5, [ 7, ] ],

   # # A030190 bits, A030303 positions of 1s
   # [ 'Math::NumSeq::ChampernowneBinary', 0,
   #   [ 1, 2, 4, 5, 6, 9, 11, 12, 13, 15, 16, 17, 18, 22,
   #     25, 26, 28, 30, 32, 33, 34, 35, 38, 39, 41, 42, 43,
   #     44, 46, 47, 48, 49, 50, 55, 59, 60, 63, 65, 68, 69,
   #     70, 72, 75, 77, 79, 80, 82, 83, 85, 87, 88, 89, 90,
   #     91, 95, 96, 99, 100, 101, 103, 105 ] ],
   #
   # # A070939
   # [ 'Math::NumSeq::DigitLength', 0,
   #   [ 1,       # 0
   #     1,       # 1
   #     2,2,     # 2,3
   #     3,3,3,3, # 4,5,6,7,
   #     4,4,4,4,4,4,4,4,  # 8-15
   #     5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5, # 16-31
   #     6,       # 32
   #   ],
   #   { radix => 2 },
   # ],
   #
   # # A083652
   # [ 'Math::NumSeq::DigitLengthCumulative', 0,
   #   [ 1, 2, 4, 6, 9, 12, 15, 18, 22, 26, 30, 34, 38, 42,
   #     46, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100,
   #     105, 110, 115, 120, 125, 130, 136, 142, 148, 154,
   #     160, 166, 172, 178, 184, 190, 196, 202, 208, 214,
   #     220, 226, 232, 238, 244, 250, 256, 262, 268, 274,
   #     280, 286, 292 ],
   #   { radix => 2 },
   # ],

   [ 'Math::NumSeq::Repdigits', 0,
     [ 0,
       1,2,3,4,5,6,7,8,9,
       11,22,33,44,55,66,77,88,99,
       111,222,333,444,555,666,777,888,999,
     ] ],
   [ 'Math::NumSeq::Repdigits', 0,
     ## no critic (ValuesAndExpressions::ProhibitLeadingZeros)
     ## no critic (Lax::ProhibitLeadingZeros::ExceptChmod)
     [ 0,
       01,02,03,04,05,06,07,
       011,022,033,044,055,066,077,
       0111,0222,0333,0444,0555,0666,0777, ],
     { radix => 8 },
   ],
   [ 'Math::NumSeq::Repdigits', 0,
     [ 0, 1,2,
       4, # 11
       8, # 22
       13, # 111
       26, # 222
       40, # 1111
       80, # 2222
     ],
     { radix => 3 },
   ],

   [ 'Math::NumSeq::Beastly', 0,
     [ 666,
       1666, 2666, 3666, 4666, 5666,
       6660,6661,6662,6663,6664,6665,6666,6667,6668,6669,
       7666, 8666, 9666,
       10666,11666,12666,13666,14666,15666,
       16660,16661,16662,16663,16664,16665,16666,16667,16668,
       16669,
       17666,18666,19666,
       20666,21666,22666,23666,24666,25666,
       26660,26661,26662,26663,26664,26665,26666,26667,26668,
       26669,
       27666,28666,29666,
     ] ],
   [ 'Math::NumSeq::Beastly', 0,
     [ 0666,
       01666, 02666, 03666, 04666, 05666,
       06660,06661,06662,06663,06664,06665,06666,06667,
       07666,
       010666,011666,012666,013666,014666,015666,
       016660,016661,016662,016663,016664,016665,016666,016667,
       017666,
       020666,021666,022666,023666,024666,025666,
       026660,026661,026662,026663,026664,026665,026666,026667,
       027666,
     ],
     { radix => 8 } ],

   # [ 'Math::NumSeq::PrimeQuadraticEuler', 0,
   #   [ 41, 43, 47, 53, 61, 71, 83, 97, 113, 131, 151 ] ],
   # [ 'Math::NumSeq::PrimeQuadraticLegendre', 0,
   #   [ 29, 31, 37, 47, 61, 79, 101, 127, 157, 191, 229 ] ],
   # [ 'Math::NumSeq::PrimeQuadraticHonaker', 0,
   #   [ 59, 67, 83, 107, 139, 179, 227, 283, 347, 419, 499 ] ],
   #
   # # 0
   # # 1         1
   # #  0
   # #   1       3
   # #    10     4
   # #      101  6,8
   # [ 'Math::NumSeq::GoldenSequence', 0,
   #   [ 1,3,4,6,8, 9, 11,12 ] ],
   #
   # # [ 'Math::NumSeq::GolayRudinShapiro', 0,
   # #   [ 0,1,2,4,5,7 ] ],
   # # http://oeis.org/A022155
   # # positions of -1, odd num of "11"s
   # [ 'Math::NumSeq::GolayRudinShapiro', 3,
   #   [ 3, 6, 11, 12, 13, 15, 19, 22, 24, 25,
   #     26, 30, 35, 38, 43, 44, 45, 47, 48, 49,
   #     50, 52, 53, 55, 59, 60, 61, 63, 67, 70,
   #     75, 76, 77, 79, 83, 86, 88, 89, 90, 94,
   #     96, 97, 98, 100, 101, 103, 104, 105,
   #     106, 110, 115, 118, 120, 121, 122, 126,
   #     131, 134, 139, 140 ] ],

  ) {
  my ($class, $lo, $want, $values_options, $test_options) = @$elem;
  $values_options ||= {};

  my $name = join (' ',
                   $class,
                   map {"$_=$values_options->{$_}"} keys %$values_options);
  eval "require $class; 1" or die $@;
  my $seq = $class->new (lo => $lo,
                         %$values_options);

  #### $want
  my $hi = $want->[-1];
  # diag "$name $lo to ",$hi;

  # SKIP: {
  #    require Module::Load;
  #    if (! eval { Module::Load::load ($class);
  #                 $seq = $class->new (lo => $lo,
  #                                     hi => $hi,
  #                                     %$values_options);
  #                 1; }) {
  #      my $err = $@;
  #      diag "$name caught error -- $err";
  #      if (my $module = $test_options->{'module'}) {
  #        if (! eval "require $module; 1") {
  #          skip "$name due to no module $module", 2;
  #        }
  #        diag "But $module loads successfully";
  #      }
  #      die $err;
  #    }

  {
    my $got = [ map {
      my ($i, $value) = $seq->next;
      (defined $value ? $value : $i)
    } 0 .. $#$want ];
    foreach (@$got) { if ($_ == 0) { $_ = 0 } }  # avoid "-0"

    is_deeply ($got, $want, "$name, lo=$lo hi=$hi");
    if (! eq_array($got,$want)) {
      diag "got len ".scalar(@$got);
      diag "want len ".scalar(@$want);
      if ($#$got > 200) { $#$got = 200 }
      if ($#$want > 200) { $#$want = 200 }
      diag "got  ". join(',', map {defined() ? $_ : 'undef'} @$got);
      diag "want ". join(',', map {defined() ? $_ : 'undef'} @$want);
    }
  }

SKIP: {
  $seq->can('pred')
    or skip "no pred() for $seq", 1;
  if ($seq->characteristic('count')) {
    skip "no pred on characteristic(count) for $seq", 1;
  }
  if ($seq->characteristic('digits')) {
    skip "no pred on characteristic(digits) for $seq", 1;
  }
  if ($seq->characteristic('modulus')) {
    skip "no pred on characteristic(modulus) for $seq", 1;
  }

  if ($hi > 1000) {
    $hi = 1000;
    $want = [ grep {$_<=$hi} @$want ];
  }
  my @got;
  foreach my $value (_min(@$want) .. $want->[-1]) {
    ### $value
    if ($seq->pred($value)) {
      push @got, $value;
    }
  }
  _delete_duplicates($want);
  #### $want
  my $got = \@got;
  my $diff = diff_nums($got, $want);
  is ($diff, undef,
      "$class pred() lo=$lo hi=$hi");
  if (defined $diff) {
    diag "got len ".scalar(@$got);
    diag "want len ".scalar(@$want);
    if ($#$got > 200) { $#$got = 200 }
    if ($#$want > 200) { $#$want = 200 }
    diag "got  ". join(',', map {defined() ? $_ : 'undef'} @$got);
    diag "want ". join(',', map {defined() ? $_ : 'undef'} @$want);
  }
}
}

#------------------------------------------------------------------------------

# diag "Math::Prime::XS version ", Math::Prime::XS->VERSION;

exit 0;
