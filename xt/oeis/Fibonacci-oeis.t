#!/usr/bin/perl -w

# Copyright 2012 Kevin Ryde

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

use 5.004;
use strict;
use Test;
plan tests => 5;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::FibonacciWord;

# uncomment this to run the ### lines
#use Smart::Comments '###';


sub numeq_array {
  my ($a1, $a2) = @_;
  if (! ref $a1 || ! ref $a2) {
    return 0;
  }
  my $i = 0; 
  while ($i < @$a1 && $i < @$a2) {
    if ($a1->[$i] ne $a2->[$i]) {
      return 0;
    }
    $i++;
  }
  return (@$a1 == @$a2);
}


#------------------------------------------------------------------------------
# A020909 - length in bits of F[n]

{
  my $anum = 'A020909';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    require Math::BigInt;
    require Math::NumSeq::DigitLength;
    my $len  = Math::NumSeq::DigitLength->new(radix=>2);
    my $seq  = Math::NumSeq::Fibonacci->new;
    $seq->next; # skip initial 0
    while (@got < @$bvalues) {
      my ($i, $fib) = $seq->next;
      push @got, $len->ith($fib);
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

#------------------------------------------------------------------------------
# A087172 - next lower Fibonacci <= n

{
  my $anum = 'A087172';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    my $seq  = Math::NumSeq::Fibonacci->new;
    $seq->next; # skip 0
    (undef, my $fib) = $seq->next;
    (undef, my $next_fib) = $seq->next;
    for (my $n = 2; @got < @$bvalues; $n++) {
      while ($next_fib < $n) {
        $fib = $next_fib;
        (undef, $next_fib) = $seq->next;
      }
      push @got, $fib;
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

#------------------------------------------------------------------------------
# A005592 - F(2n+1)+F(2n-1)-1

{
  my $anum = 'A005592';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    my $seq  = Math::NumSeq::Fibonacci->new;
    for (my $n = Math::NumSeq::_to_bigint(1); @got < @$bvalues; $n++) {
      push @got, $seq->ith(2*$n+1) + $seq->ith(2*$n-1) - 1
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

#------------------------------------------------------------------------------
# A108852 - num fibs <= n

{
  my $anum = 'A108852';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    my $seq  = Math::NumSeq::Fibonacci->new;
    push @got, 1;   # past 1 occurring twice
    my $count = 3;
    for (my $n = 2; @got < @$bvalues; $n++) {
      push @got, $count;
      if ($seq->pred($n)) {
        $count++;
      }
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

#------------------------------------------------------------------------------
# A035105 - LCM of fibs

{
  my $anum = 'A035105';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    my $seq  = Math::NumSeq::Fibonacci->new;
    $seq->next; # skip 0
    my $lcm = Math::NumSeq::_to_bigint(1);
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      $lcm = lcm($lcm,$value);
      push @got, $lcm;
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

sub lcm {
  my $ret = shift;
  while (@_) {
    my $value = shift;
    my $gcd = Math::BigInt::bgcd($ret,$value);
    $ret *= $value/$gcd;
  }
  return $ret;
}

#------------------------------------------------------------------------------
exit 0;
