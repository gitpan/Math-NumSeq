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
use Math::NumSeq::MathImageAlphabeticalLength;
use Lingua::Any::Numbers;
use Encode;
use PerlIO::encoding;

use Smart::Comments;

{
  my @langs = Lingua::Any::Numbers::available();
  @langs = sort @langs;
  print "count $#langs\n";
  foreach my $lang (@langs) {
    print "$lang\n";

    foreach my $i (1 .. 5) {
      my $str = Lingua::Any::Numbers::to_string($i,$lang);
      my $ord = Lingua::Any::Numbers::to_ordinal($i,$lang);
      $str //= '[undef]';
      $ord //= '[undef]';
      $str = Encode::encode('latin-1',$str,Encode::FB_PERLQQ());
      $ord = Encode::encode('latin-1',$ord,Encode::FB_PERLQQ());
      print "$i $str    $ord\n";
    }
    print "\n";
  }
  exit 0;
}

{
  # IT -- no get_ordinate()
  require Lingua::IT::Numbers;
  foreach my $i (1 .. 5) {
    my $str = Lingua::IT::Numbers::number_to_it($i);
    my $ord = Lingua::IT::Numbers->get_ordinate($i);
    $str //= '[undef]';
    $ord //= '[undef]';
    $str = Encode::encode('latin-1',$str,Encode::FB_PERLQQ());
    $ord = Encode::encode('latin-1',$ord,Encode::FB_PERLQQ());
    print "$i $str    $ord\n";
  }
  exit 0;
}


