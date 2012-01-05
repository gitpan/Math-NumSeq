#!/usr/bin/perl -w

# Copyright 2011, 2012 Kevin Ryde

# This file is part of Math-NumSeq.
#
# Math-NumSeq is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# Math-NumSeq is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.

use blib "$ENV{HOME}/p/fx/38_02/blib";
use Math::Factor::XS 'prime_factors';

use 5.004;
use strict;
use Math::Factor::XS 'factors','matches','prime_factors';

# uncomment this to run the ### lines
use Smart::Comments;

{
  require Devel::TimeThis;
  require Math::NumSeq::PrimeFactorCount;
  my $seq = Math::NumSeq::PrimeFactorCount->new;

  my $num = 50000;
  {
    my $t = Devel::TimeThis->new('ith');
    foreach (1 .. $num) {
      $seq->ith($_);
    }
  }
  {
    my $t = Devel::TimeThis->new('prime_factors');
    foreach (1 .. $num) {
      my @f = prime_factors($_);
      scalar(@f);
    }
  }
  exit 0;
}

{
  # factors() is slower, maybe due to arg checking overhead
  require Devel::TimeThis;
  require Math::NumSeq::DivisorCount;
  my $seq = Math::NumSeq::DivisorCount->new;

  my $num = 50000;
  {
    my $t = Devel::TimeThis->new('ith');
    foreach (1 .. $num) {
      $seq->ith($_);
    }
  }
  {
    my $t = Devel::TimeThis->new('factors');
    foreach (1 .. $num) {
      factors($_);
    }
  }
  {
    my $t = Devel::TimeThis->new('xs_factors');
    foreach (1 .. $num) {
      Math::Factor::XS::xs_factors($_);
    }
  }
  exit 0;
}

{
  require Math::NumSeq::DivisorCount;
  my $seq = Math::NumSeq::DivisorCount->new;
  foreach my $i (2 .. 2500) {
    my @f = factors($i);
    my $f = scalar(@f) + 2;
    my $ith = $seq->ith($i);
    $f == $ith or die "$f == $ith";
  }
  exit 0;
}

{
  print join(', ', factors(30)),"\n";
  ### factors(): factors(12345)
  ### factors(): factors(65536)
  ### factors(): factors(2*3*5*7)
  exit 0;
}

{
  foreach my $i (1 .. 32) {
    my $sign = 1;
    my $t = 0;
    for (my $bit = 1; $bit <= $i; $bit <<= 1, $sign = -$sign) {
      if ($i & $bit) {
        $t += $sign * $bit;
      }
    }
    print "$i  $t\n";
  }
  exit  0;
}

{
  { package MyTie;
    sub TIESCALAR {
      my ($class) = @_;
      return bless {}, $class;
    }
    sub FETCH {
      print "fetch\n";
      return { skip_multiples => 1 };
    }
  }
  my $t;
  tie $t, 'MyTie';

  {
    my @ret = matches(12,[2,2,3,4,6],{ skip_multiples => 1 });
    ### matches(): @ret
  }
  {
    my @ret = matches(12,[2,2,3,4,6],$t);
    ### matches(): @ret
  }
  for (;;) { matches(12,[2,2,3,4,6]); }
  exit 0;
}



{
  for (;;) {
    factors(12345);
  }
  exit 0;
}
