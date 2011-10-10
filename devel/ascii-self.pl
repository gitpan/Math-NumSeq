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

{
  require App::MathImage::NumSeq::AsciiSelf;
  require Math::BaseCnv;
  foreach my $radix (2 .. 64) {
    print "$radix   ";
    foreach my $i (48 .. 47+$radix) {
      my @ascii = App::MathImage::NumSeq::AsciiSelf::_radix_ascii($radix,$i);
      if ($ascii[0] == $i) {
        my $base = Math::BaseCnv::cnv($i,10,$radix);
        print join('_',@ascii), "  [$base], ";
      }
    }
    print "\n";
  }
  exit 0;
}

{
  require App::MathImage::NumSeq::AsciiSelf;
  foreach my $radix (2 .. 40) {
    my $seq = App::MathImage::NumSeq::AsciiSelf->new (radix => $radix);
    print "$radix   ",join(',',@{$seq->{'pending'}}),"\n";
  }
  exit 0;
}

