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
plan tests => 4;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::BalancedBinary;

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
      return "different pos=$i got=".(defined $got ? $got : '[undef]')
        ." want=".(defined $want ? $want : '[undef]');
    }
    $got =~ /^[0-9.-]+$/
      or return "not a number pos=$i got='$got'";
    $want =~ /^[0-9.-]+$/
      or return "not a number pos=$i want='$want'";
    if ($got != $want) {
      return "different pos=$i numbers got=$got want=$want";
    }
  }
  return undef;
}


#------------------------------------------------------------------------------
# A080300 - ranking, value -> i or if no such then 0

{
  my $anum = 'A080300';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got;
    for (my $value = 0; @got < @$bvalues; $value++) {
      my $i = $seq->value_to_i($value);
      push @got, $i || 0;
    }
    $diff = diff_nums(\@got, $bvalues);
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
# A085192 first diffs

{
  my $anum = 'A085192';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my $prev = 0;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, $value - $prev;
      $prev = $value;
    }
    $diff = diff_nums(\@got, $bvalues);
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
# A085223 - positions of single trailing zero

{
  my $anum = 'A085223';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      if (($value % 4) == 3) {
        push @got, $i;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
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
# A080237 - num trailing zeros

{
  my $anum = 'A080237';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    require Math::NumSeq::DigitCountLow;
    my $seq = Math::NumSeq::BalancedBinary->new;
    my $low = Math::NumSeq::DigitCountLow->new (radix => 2, digit => 0);
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, $low->ith($value);
    }
    $diff = diff_nums(\@got, $bvalues);
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
# A080116 predicate 0,1

{
  my $anum = 'A080116';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got = (1);
    for (my $value = 1; @got < @$bvalues; $value++) {
      push @got, ($seq->pred($value) ? 1 : 0);
    }
    $diff = diff_nums(\@got, $bvalues);
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
# A063171 - in binary

{
  my $anum = 'A063171';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::BalancedBinary->new;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, to_binary_str($value);
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

sub to_binary_str {
  my ($n) = @_;
  if (ref $n) {
    my $str = $n->as_bin;
    $str =~ s/^0b//;
    return $str;
  }
  if ($n == 0) { return '0'; }
  my $str = '';
  my @bits;
  while ($n) {
    push @bits, $n%2;
    $n = int($n/2);
  }
  return join('',reverse @bits);
}


#------------------------------------------------------------------------------
exit 0;
