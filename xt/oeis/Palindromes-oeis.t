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
plan tests => 8;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::Palindromes;

# uncomment this to run the ### lines
#use Smart::Comments '###';


sub diff_nums {
  my ($gotaref, $wantaref) = @_;
  for (my $i = 0; $i < @$gotaref; $i++) {
    if ($i > @$wantaref) {
      return "want ends prematurely pos=$i";
    }
    my $got = $gotaref->[$i];
    my $want = $wantaref->[$i];
    if (! defined $got && ! defined $want) {
      next;
    }
    if (! defined $got || ! defined $want) {
      return ("different pos=$i def/undef"
              . "\n  got=".(defined $got ? $got : '[undef]')
              . "\n want=".(defined $want ? $want : '[undef]'));
    }
    $got =~ /^[0-9.-]+$/
      or return "not a number pos=$i got='$got'";
    $want =~ /^[0-9.-]+$/
      or return "not a number pos=$i want='$want'";
    if ($got ne $want) {
      ### $got
      ### $want
      return ("different pos=$i numbers"
              . "\n  got=".(defined $got ? $got : '[undef]')
              . "\n want=".(defined $want ? $want : '[undef]'));
    }
  }
  return undef;
}


#------------------------------------------------------------------------------
# A029735 - cubes are hex palindromes

{
  my $anum = 'A029735';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum,
                                                      max_value => 10000);
  my @got;
  my $diff;
  if ($bvalues) {
    require Math::NumSeq::Cubes;
    my $cubeseq = Math::NumSeq::Cubes->new;
    my $palseq = Math::NumSeq::Palindromes->new (radix => 16);
    while (@got < @$bvalues) {
      my ($i, $value) = $cubeseq->next;
      if ($palseq->pred($value)) {
        push @got, $i;
      }
    }
    $diff = diff_nums (\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A029736 - hex palindrome cubes

{
  my $anum = 'A029736';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum,
                                                      max_value => 10000**3);
  my @got;
  my $diff;
  if ($bvalues) {
    require Math::NumSeq::Cubes;
    my $cubeseq = Math::NumSeq::Cubes->new;
    my $palseq = Math::NumSeq::Palindromes->new (radix => 16);
    while (@got < @$bvalues) {
      my ($i, $value) = $cubeseq->next;
      if ($palseq->pred($value)) {
        push @got, $value;
      }
    }
    $diff = diff_nums (\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A029731 - palindromes in both decimal and hexadecimal

{
  my $anum = 'A029731';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values ($anum);
  my @got;
  my $diff;
  if ($bvalues) {
    my $dec = Math::NumSeq::Palindromes->new;
    my $hex = Math::NumSeq::Palindromes->new (radix => 16);

    while (@got < @$bvalues) {
      my ($i, $value) = $dec->next;
      if ($hex->pred($value)) {
        push @got, $value;
      }
    }
    $diff = diff_nums (\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A029733 - squares are hex palindromes

{
  my $anum = 'A029733';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::Palindromes->new (radix => 16);
    for (my $n = 0; @got < @$bvalues; $n++) {
      if ($seq->pred($n*$n)) {
        push @got, $n;
      }
    }
    $diff = diff_nums (\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A029734 - hex palindrome squares

{
  my $anum = 'A029734';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::Palindromes->new (radix => 16);
    for (my $n = 0; @got < @$bvalues; $n++) {
      my $square = $n*$n;
      if ($seq->pred($square)) {
        push @got, $square;
      }
    }
    $diff = diff_nums (\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A137180 count of palindromes 1 to n

{
  my $anum = 'A137180';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  my $diff;
  if ($bvalues) {
    my $palindromes = Math::NumSeq::Palindromes->new;
    my $count = 0;
    push @got, 0;  # starting n=0 not considered a palindrome
    for (my $n = 1; @got < @$bvalues; $n++) {
      $count++ if $palindromes->pred($n);
      push @got, $count;
    }
    $diff = diff_nums (\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum -- palindromes which are primes");
}


#------------------------------------------------------------------------------
# A002385 Palindromes primes, decimal

{
  my $anum = 'A002385';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values
    ($anum,
     max_value => 0xFFFF_FFFF);
  my @got;
  my $diff;
  if ($bvalues) {
    my $palindromes = Math::NumSeq::Palindromes->new;
    require Math::NumSeq::Primes;
    my $primes  = Math::NumSeq::Primes->new;

    while (@got < @$bvalues) {
      my ($i, $value) = $palindromes->next;
      ### $i
      ### $value
      my $is_prime = $primes->pred($value);
      if (! defined $is_prime) {
        MyTestHelpers::diag ("  too big at i=$i, value=$value");
        last;
      }
      if ($is_prime) {
        push @got, $value;
      }
    }
    $diff = diff_nums (\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum -- palindromes which are primes");
}

#------------------------------------------------------------------------------
# A029732 Palindromes primes, hexadecimal

{
  my $anum = 'A029732';

  my ($bvalues, $lo, $filename) = MyOEIS::read_values
    ($anum,
     max_value => 0xFFFF_FFFF);
  my @got;
  my $diff;
  if ($bvalues) {
    my $palindromes = Math::NumSeq::Palindromes->new (radix => 16);
    require Math::NumSeq::Primes;
    my $primes  = Math::NumSeq::Primes->new;

    while (@got < @$bvalues) {
      my ($i, $value) = $palindromes->next;
      ### $i
      ### $value
      my $is_prime = $primes->pred($value);
      if (! defined $is_prime) {
        MyTestHelpers::diag ("  too big at i=$i, value=$value");
        last;
      }
      if ($is_prime) {
        push @got, $value;
      }
    }
    $diff = diff_nums (\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum -- palindromes which are primes");
}


#------------------------------------------------------------------------------
exit 0;
