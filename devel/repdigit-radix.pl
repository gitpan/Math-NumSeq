#!/usr/bin/perl -w

# Copyright 2011 Kevin Ryde

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

# uncomment this to run the ### lines
use Smart::Comments;


{
  require App::MathImage::NumSeq::RepdigitRadix;
  my $seq = App::MathImage::NumSeq::RepdigitRadix->new;
  my @seen;
  foreach (1 .. 5000) {
    my ($i,$value) = $seq->next;
    $seen[$value] = 1;
  }
  foreach my $radix (2 .. $#seen) {
    if (! $seen[$radix]) {
      print "$radix, ";
    }
  }
  print "\n";
  exit 0;
}


