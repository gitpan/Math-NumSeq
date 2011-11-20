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
#use Devel::Comments;

{
  # 2^32 F(k) = 3,524,578
  # 2^64 F(k) = 27,777,890,035,288 = 44 bits
  require Math::NumSeq::Fibbinary;
  my $f0 = 0;
  my $f1 = 1;
  foreach my $i (0 .. 70) {
    ($f1,$f0) = ($f1+$f0,$f1);
    my $fibbinary = Math::NumSeq::Fibbinary->ith($f1);
    my $bits = sprintf "%b", $fibbinary;
    my $len = length($bits);
    printf "$i $f1  $len  $bits\n";
  }
  exit 0;
}
