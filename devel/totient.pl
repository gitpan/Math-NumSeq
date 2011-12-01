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

require 5;
use strict;

# uncomment this to run the ### lines
use Smart::Comments;

{
  require Math::NumSeq::TotientStepsSum;
  my $seq = Math::NumSeq::TotientStepsSum->new;
  my $value_prev = 0;
  my $decr = 0;
  for (1 .. 500) {
    my ($i,$value) = $seq->next;
    if ($value < $value_prev) {
      $decr++;
    } else {
      if ($decr) {
        print "$i decr $decr\n";
      }
      $decr = 0;
    }
    $value_prev = $value;
  }
  exit 0;
}
