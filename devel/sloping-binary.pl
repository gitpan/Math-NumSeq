#!/usr/bin/perl -w

# Copyright 2011, 2012 Kevin Ryde

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
use Math::NumSeq::MathImageSlopingBinaryExcluded;
use Math::BigInt;

{
  my $seq = Math::NumSeq::MathImageSlopingBinaryExcluded->new;
  foreach (1 .. 50) {
    my ($i, $value) = $seq->next;
    printf "%60s\n", Math::BigInt->new($value)->as_bin;
  }
  exit 0;
}
