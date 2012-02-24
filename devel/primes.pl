#!/usr/bin/perl -w

# Copyright 2010, 2011, 2012 Kevin Ryde

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

use Smart::Comments;

# use blib "$ENV{HOME}/perl/bit-vector/Bit-Vector-7.1/blib";

{
  # pierpont
  use Math::NumSeq::MathImagePierpontPrimes;
  my $seq = Math::NumSeq::MathImagePierpontPrimes->new;

  foreach (1 .. 50) {
    my ($i, $value) = $seq->next;
    my ($x, $y) = pierpont_xy ($value);
    my $cmp = ($x <=> $y);
    print "$value    $x $y      $cmp\n";
  }

  sub pierpont_xy {
    my ($value) = @_;

    my $v = $value - 1;
    my $x = 0;
    until ($v % 2) {
      $v = int($v/2);
      $x++;
    }
    my $y = 0;
    until ($v % 3) {
      $v = int($v/3);
      $y++;
    }
    return ($x, $y);
  }

  exit 0;
}


# n	pi_2(n)
# 10^3	35
# 10^4	205
# 10^5	1224
# 10^6	8169
# 10^7	58980
# 10^8	440312
# 10^9	3424506
# 10^(10)	27412679
# 10^(11)	224376048
# 10^(12)	1870585220
# 10^(13)	15834664872
# 10^(14)	135780321665
# 10^(15)	1177209242304
# 10^(16)	10304195697298

{
  # twin primes count
  use Math::NumSeq::TwinPrimes;
  my $seq = Math::NumSeq::TwinPrimes->new;

  {
    my $value = 5.4e15;
    my $est_i = $seq->value_to_i_estimate($value);
    print "$value  $est_i\n";
  }


  my $target = 2;
  for (;;) {
    my ($i, $value) = $seq->next;
    if ($i >= $target) {
      $target *= 2;
      my $est_i = $seq->value_to_i_estimate($value);
      my $factor = $est_i / $i;
      printf "%d %d   %d  %.3f\n", $i, $est_i, $value, $factor;
    }
  }
  exit 0;
}

{
  use Math::Prime::FastSieve;
  my @ret = Math::Prime::FastSieve::primes(20);
  ### @ret;

  require Test::Weaken;
  my $leaks = Test::Weaken::leaks (sub { Math::Prime::FastSieve::primes(20) });
  ### $leaks

  my $sieve = Math::Prime::FastSieve::Sieve->new( 2_000_000 );
  ### isprime: $sieve->isprime(1928099)

  exit 0;
}
{
  require Math::Prime::TiedArray;
  tie my @primes, 'Math::Prime::TiedArray';
  foreach my $i (0 .. 200) {
    print int(sqrt($primes[$i])),"\n";
  }
  exit 0;
}
{
  require Math::Prime::TiedArray;
  tie my @primes, 'Math::Prime::TiedArray';
  local $, = "\n";
  print @primes[0..5000];
  exit 0;
}

{
  require Bit::Vector;
  my $size = 0xFF; # F00000;
  my $vector = Bit::Vector->new($size);
  $vector->Primes();
  print $vector->bit_test(0),"\n";
  print $vector->bit_test(1),"\n";
  print $vector->bit_test(2),"\n";
  print $vector->bit_test(3),"\n";
  print $vector->bit_test(4),"\n";
  print $vector->bit_test(5),"\n";
  print $vector->bit_test(1928099),"\n";
  foreach my $i (0 .. 100) {
    if ($vector->bit_test($i)) {
      print ",$i";
    }
  }
  print "\n";


  # require Math::Prime::XS;
  # foreach my $i (65536 .. $size-1) {
  #   my $v = 0 + $vector->bit_test($i);
  #   my $x = 0 + Math::Prime::XS::is_prime($i);
  #   if ($v != $x) {
  #     print "$i $v $x\n";
  #   }
  # }
  exit 0;
}

{
  require Math::Prime::XS;
  local $, = "\n";
  print Math::Prime::XS::sieve_primes(2,3);
  exit 0;
}
