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
use Math::Prime::XS 0.23 'is_prime'; # version 0.23 fix for 1928099
use Math::Factor::XS 0.39 'prime_factors'; # version 0.39 for prime_factors()
use List::Util 'max','min';
use Math::Trig 'pi';

#use Smart::Comments;

# use blib "$ENV{HOME}/perl/bit-vector/Bit-Vector-7.1/blib";

{
  # Lipschitz by seq
  require Math::NumSeq::MathImageLipschitzClass;
  my $seq = Math::NumSeq::MathImageLipschitzClass->new;
  my @P;
  my @I;
  foreach (1 .. 1000) {
    my ($i, $value) = $seq->next;
    push @{$I[$value]}, $i;
  }
  $seq = Math::NumSeq::MathImageLipschitzClass->new (lipschitz_type => 'P');
  foreach (1 .. 1000) {
    my ($i, $value) = $seq->next;
    if ($value) {
      push @{$P[$value]}, $i;
    }
  }

  foreach my $i (1 .. 10) {
    my $Pstr = join(',', @{$P[$i]//[]});
    print "P$i: $Pstr\n";

    my $Istr = join(',', @{$I[$i]//[]});
    print "I$i: $Istr\n";
  }
  exit 0;
}

{
  # The development of prime number theory: from Euclid to Hardy and Littlewood
  #
  # Lipschitz 1890 Bemerkung zu dem aufsatze: Untersuchungen der
  # Eigenschaften einer Gattung von unendlichen Reihen J. Reine Agnew Math
  # 106 27-29
  # http://resolver.sub.uni-goettingen.de/purl?PPN243919689_0106/dmdlog6
  # http://www.digizeitschriften.de/index.php?id=resolveppn&PPN=PPN243919689_0106&DMDID=dmdlog6
  #
  # require Math::NumSeq::MathImageLipschitzClass;
  # my $seq = Math::NumSeq::MathImageLipschitzClass->new;

  my @P = (undef, { 2 => 1 });
  my @I = (undef, { 2 => 1 });
  my %I_left;
  @I_left{3..1000} = (); # hash slice

  foreach my $i (1 .. 10) {
    my $Pstr = join(',',sort {$a<=>$b} keys %{$P[$i]});
    print "P$i: $Pstr\n";

    my $Istr = join(',',sort {$a<=>$b} keys %{$I[$i]});
    print "I$i: $Istr\n";

    foreach my $v (keys %{$I[$i]}) {
      if (is_prime($v+1)) {
        $P[$i+1]->{$v+1} = 1;
      }
    }

    foreach my $v (keys %I_left) {
      if (all_factor_in_Ps($i,$v)) {
        $I[$i+1]->{$v} = 1;
        delete $I_left{$v};
      }
    }
  }

  sub all_factor_in_Ps {
    my ($i, $v) = @_;
    foreach my $factor (prime_factors($v)) {
      if (! factor_in_Ps($i, $factor)) {
        return 0;
      }
    }
    return 1;
  }

  sub factor_in_Ps {
    my ($i, $factor) = @_;
    foreach my $j (1 .. $i) {
      if ($P[$j]->{$factor}) {
        return 1;
      }
    }
    return 0;
  }
  exit 0;
}

{
  # dedekind psi cumulative estimate
  require Math::NumSeq::DedekindPsiCumulative;
  my $seq = Math::NumSeq::DedekindPsiCumulative->new;

  my $target = 2;
  for (;;) {
    my ($i, $value) = $seq->next;
    if ($i >= $target) {
      $target *= 2;
      my $est_i = $seq->value_to_i_estimate($value);
      my $factor = $est_i / $i;
      my $O = ($value - (15*$i**2)/(2*pi()*pi())) / ($i*log($i));
      my $est_value = ($i**2) * 15/(2*pi()*pi()); #  + 0 * ($i*log($i));
      printf "%d %d   %d %.0f  factor=%.3f  O=%.3f\n",
        $i, $est_i, $value, $est_value, $factor, $O;
    }
  }
  exit 0;
}

{
  # deletable primes high zeros
  use Math::NumSeq::DeletablePrimes;
  my $seq = Math::NumSeq::DeletablePrimes->new;

  for my $value (0 .. 100000) {
    (my $low = $value) =~ s/.0+//
      or next;
    is_prime($value) or next;
    if ($seq->pred($value)) { next; }
    $seq->pred($low) or next;

    print "$value $low\n";
  }
  exit 0;
}

{
  # Math::NumSeq::MathImagePierpontPrimes;

  # Erdos-Selfridge
  # 1+ 2, 3, 5, 7, 11, 17, 23, 31, 47, 53, 71, 107, 127, 191, 383, 431, 647,
  # 2+ 13, 19, 29, 41, 43, 59, 61, 67, 79, 83, 89, 97, 101, 109, 131, 137,
  # 3+ 37, 103, 113, 151, 157, 163, 173, 181, 193, 227, 233, 257, 277, 311,
  # 4+ 73, 313, 443, 617, 661, 673, 677, 691, 739, 757, 823, 887, 907, 941,
  my @es_class = (undef, undef, 0, 0);
  sub es_class {
    my ($prime) = @_;
    return ($es_class[$prime]
            //= max (map { es_class($_)+1 } prime_factors($prime+1)));
  }
  
  my @by_class;
  my $seq = Math::NumSeq::Primes->new;
  foreach (1 .. 50) {
    my ($i, $value) = $seq->next;
    my $es_class = es_class($value);
    print "$value  $es_class\n";
    push @{$by_class[$es_class]}, $value;
  }

  foreach my $i (keys @by_class) {
    my $aref = $by_class[$i] || next;
    print "$i  ",join(',',@$aref),"\n";
  }

  exit 0;
}

{
  # pierpont offsets

  my $offset = -7;
  foreach my $x (1 .. 20) {
    foreach my $y (1 .. 20) {
      my $v = 2**$x * 3**$y + $offset;
      last if $v > 0xFFF_FFFF;
      if ($v > 0 && is_prime($v)) {
        print "$x,$y $offset\n";
      }
    }
  }
  exit 0;
}

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
