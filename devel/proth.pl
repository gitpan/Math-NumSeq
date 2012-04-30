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

{
  # value_to_i_estimate()

  require Math::NumSeq::ProthNumbers;
  my $seq = Math::NumSeq::ProthNumbers->new;

  my $target = 2;
  for (;;) {
    my ($i, $value) = $seq->next;
    if ($i >= $target) {
      $target *= 1.1;

      # require Math::BigRat;
      # $value = Math::BigRat->new($value);

      # require Math::BigFloat;
      # $value = Math::BigFloat->new($value);

      my $est_i = $seq->value_to_i_estimate($value);
      my $factor = $est_i / $i;
      printf "%d %d   %.10s  factor=%.3f\n",
        $i, $est_i, $value, $factor;
    }
  }
  exit 0;
}

{
  # BigInt
  require Math::NumSeq::ProthNumbers;
  my $seq = Math::NumSeq::ProthNumbers->new;

  my $n = 1;
  my $target = 2;
  for (;;) {
    my ($i, $value) = $seq->next;
    if ($value >= $target) {
      printf "%d  %d %X\n", $n, $i, $value;
      $n++;
      $target *= 2;
    }
  }
  exit 0;
}
