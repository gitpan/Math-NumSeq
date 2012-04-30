#!/usr/bin/perl -w

# Copyright 2012 Kevin Ryde

# This file is part of Math-NumSeq.
#
# Math-NumSeq is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 3, or (at your option) any later
# version.
#
# Math-NumSeq is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.

use 5.010;
use strict;
use warnings;
use POSIX;
use List::Util 'max','min';

#use Smart::Comments;


{
  # sieve stages
  my @sieve = (map { 2*$_+1} 0 .. 100); # odd 1,3,5,7 etc
  for (my $upto = 1; $upto <= $#sieve; $upto++) {
    my $str = join(',',@sieve);
    $str = substr($str,0,70);
    print "$str\n";

    my $step = $sieve[$upto];
    ### $step
    for (my $i = $step-1; $i <= $#sieve; $i += $step-1) {
      splice @sieve, $i, 1;
    }
  }
  exit 0;
}

