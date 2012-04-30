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
use Math::NumSeq::GolayRudinShapiroCumulative;

# uncomment this to run the ### lines
use Smart::Comments;

{
  my $seq = Math::NumSeq::GolayRudinShapiroCumulative->new;
  for (1 .. 32) {
    my ($i,$value) = $seq->next;
    # my $calc = ith_low_to_high($i+1);
    #my $calc = ith_low_to_high($i+1);
     my $calc = Math::NumSeq::GolayRudinShapiroCumulative::ith(undef,$i);
    my $diff = ($calc == $value ? '' : '   ***');
    print "$i  $value  $calc$diff\n";
  }

  sub ith_high_to_low {
    my ($n) = @_;
    ### ith(): $n

    my $power = 1;
    my @bits;
    while ($n) {
      push @bits, $n % 2;
      $n = int($n/2);

      push @bits, $n % 2;
      $n = int($n/2);

      $power *= 2;
    }

    my $ret = 0;
    my $prev = 0;
    my $neg = 0;

    while (@bits) {
      my $bit = pop @bits;
      if ($bit) {
        if ($neg) {
          $ret -= $power;
        } else {
          ### first add: $power
          $ret += $power;
        }
      }
      if ($bit && $prev) {
        $neg ^= 1;
      }
      $prev = $bit;

      $power /= 2;
      last unless @bits;

      $bit = pop @bits;
      if ($bit) {
        if ($neg) {
          $ret -= $power;
        } else {
          ### second add: $power
          $ret += $power;
        }
      }
      if ($bit && $prev) {
        $neg ^= 1;
      }
      $prev = $bit;
    }
    return $ret;
  }

  sub Xith_low_to_high {
    my ($n) = @_;
    my $ret = 0;
    my $power = 1;
    my $neg = 0;
    my $pos = 0;
    while ($n) {
      if ($n % 2) {
        if ($neg) {
          $ret -= $power;
        } else {
          $ret += $power;
        }
        $neg ^= $pos;
      }
      $n = int($n/2);
      $pos ^= 1;

      $power *= 2;

      if ($n % 2) {
        if ($neg) {
          $ret -= $power;
        } else {
          $ret += $power;
        }
        $neg ^= $pos;
      }
      $n = int($n/2);
      $pos ^= 1;
    }
    return $ret;
  }
  exit 0;
}
