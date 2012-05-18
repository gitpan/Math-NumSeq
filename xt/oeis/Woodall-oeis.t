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
plan tests => 3;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::WoodallNumbers;

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
# A050918 Woodall primes

{
  my $anum = 'A050918';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");
    if ($#$bvalues > 2) {
      $#$bvalues = 2;
      MyTestHelpers::diag ("  shorten to ",scalar(@$bvalues)," values");
    }

    my $woodall = Math::NumSeq::WoodallNumbers->new;
    require Math::NumSeq::Primes;
    my $primes  = Math::NumSeq::Primes->new;

    while (@got < @$bvalues) {
      my ($i, $value) = $woodall->next;
      ### $i
      ### $value
      my $is_prime = $primes->pred($value);
      if (! defined $is_prime) {
        last; # too big
      }
      if ($is_prime) {
        push @got, $value;
      }
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..5]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..5]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum -- woodall primes");
}


#------------------------------------------------------------------------------
# A002234 Woodall primes, the n value

{
  my $anum = 'A002234';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");
    if ($#$bvalues > 2) {
      $#$bvalues = 2;
      MyTestHelpers::diag ("  shorten to ",scalar(@$bvalues)," values");
    }

    my $woodall = Math::NumSeq::WoodallNumbers->new;
    require Math::NumSeq::Primes;
    my $primes  = Math::NumSeq::Primes->new;

    while (@got < @$bvalues) {
      my ($i, $value) = $woodall->next;
      ### $i
      ### $value
      my $is_prime = $primes->pred($value);
      if (! defined $is_prime) {
        last; # too big
      }
      if ($is_prime) {
        push @got, $i;
      }
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..10]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..10]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum -- woodall primes");
}



#------------------------------------------------------------------------------
# A056821 totient(Woodall)

{
  my $anum = 'A056821';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");
    @$bvalues = grep {$_ < 0xFFFF_FFFF} @$bvalues;
    MyTestHelpers::diag ("  shorten to ",scalar(@$bvalues)," values");

    my $woodall = Math::NumSeq::WoodallNumbers->new;
    require Math::NumSeq::Totient;
    my $totient = Math::NumSeq::Totient->new;

    while (@got < @$bvalues) {
      my ($i, $value) = $woodall->next;
      push @got, $totient->ith($value);
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..5]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..5]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum -- woodall primes");
}



#------------------------------------------------------------------------------
exit 0;
