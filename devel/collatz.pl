#!/usr/bin/perl -w

# Copyright 2013 Kevin Ryde

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
use List::Util 'max';
use Math::Factor::XS 0.39 'prime_factors'; # version 0.39 for prime_factors()


{
  # reverse steps

  # 3k+1 = 4n
  # 3k = 4n+1
  # k = (4n+1)/3

  N: foreach my $n (1 .. 20) {
    print "n=$n\n";
    for (1 .. 10) {
      my $count = 0;
      until ($n%3 == 2) {
        $n *= 2;
        print "$n  doubled\n";
        if (++$count > 6) {
          next N;
        }
      }

      $n = ($n+1) / 3;
      print "$n\n";
      $n == int($n) or die;
    }
    print "\n";
  }
  exit 0;
}
