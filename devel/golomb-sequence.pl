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

require 5;
use strict;
use Math::NumSeq::GolombSequence;

# uncomment this to run the ### lines
#use Smart::Comments;

{
  require Math::NumSeq::OEIS::File;
  my $hi = 30;
  my $seqstr;
  {
    my $seq = Math::NumSeq::GolombSequence->new (using_values => '3k');
    # $seq = Math::NumSeq::OEIS::File->new (anum => 'A080606');
    for (1 .. $hi) {
      my ($i,$value) = $seq->next or last;
      $seqstr .= "$value,";
    }
    print "$seqstr\n";
  }
  my $repstr;
  {
    my $seq = Math::NumSeq::GolombSequence->new (using_values => '3k');
    # $seq = Math::NumSeq::OEIS::File->new (anum => 'A080606');
    my $count = 1;
    my (undef,$prev) = $seq->next;
    OUTER: for (1 .. $hi) {
      for (;;) {
        my ($i,$value) = $seq->next or last OUTER;
        if ($value == $prev) {
          $count++;
        } else {
          ### $prev
          ### $value
          ### $count
          $repstr .= "$count,";
          $count = 1;
          $prev = $value;
          last;
        }
      }
    }
    print "final count $count\n";
    print "$repstr\n";
  }
  if ($repstr ne $seqstr) {
    print "different\n";
  }
  exit 0;
}

{
  my $start = 2;
  my $inc = 2;
  my @small = ($start) x $start;
  my $value = $start;
  foreach my $i (1 .. $#small) {
    $value += $inc;
    push @small, ($value) x $small[$i];
  }

  print join(' ',@small),"\n";
  exit 0;

  # 12, 12, 12, 14, 14, 14, 14, 14, 14, 16, 16, 16, 16, 16, 16, 18, 18, 18,
  # 18, 18, 18, 18, 18, 20, 20, 20, 20, 20, 20, 20, 20, 22, 22, 22, 22, 22,
  # 22, 22, 22, 24, 24, 24, 24, 24, 24, 24, 24, 26, 26, 26, 26, 26
}

{
  print "2 2 4 4 6 6 6 6 8 8 8 8 10 10 10 10 10 10 12 12 12,\n";

  my @a = (1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9);
  @a = map {(2*$_,2*$_)} @a;
  print join(' ',@a),"\n";
  exit 0;

  # 12, 12, 12, 14, 14, 14, 14, 14, 14, 16, 16, 16, 16, 16, 16, 18, 18, 18,
  # 18, 18, 18, 18, 18, 20, 20, 20, 20, 20, 20, 20, 20, 22, 22, 22, 22, 22,
  # 22, 22, 22, 24, 24, 24, 24, 24, 24, 24, 24, 26, 26, 26, 26, 26
}


__END__

        Values                            Run Lengths
 1,                                           1
 3,  3,  3,                                   3
 5,  5,  5,                                   3
 7,  7,  7,                                   3
 9,  9,  9,  9,  9,                           5
11, 11, 11, 11, 11,                           5
13, 13, 13, 13, 13,                           5
15, 15, 15, 15, 15, 15, 15,                   7
17, 17, 17, 17, 17, 17, 17,                   7
19, 19, 19, 19, 19, 19, 19,                   7
21, 21, 21, 21, 21, 21, 21, 21, 21,           9
23, 23, 23, 23, 23, 23, 23, 23, 23, 23,      10
25, 25, 25, 25, 25, 25, 25, 25, 25            9


