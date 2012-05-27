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
plan tests => 2;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::Squares;

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
# A000037 - non-squares

{
  my $anum = 'A000037';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::Squares->new;
    my @got;
    for (my $i = 0; @got < @$bvalues; $i++) {
      if (! $seq->pred($i)) {
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
# A010052 - characteristic 1/0 of squares

{
  my $anum = 'A010052';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::Squares->new;
    my @got;
    for (my $i = 0; @got < @$bvalues; $i++) {
      push @got, $seq->pred($i) ? 1 : 0;
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
# A001105 - 2*n^2

{
  my $anum = 'A001105';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $seq = Math::NumSeq::Squares->new;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, 2*$value;
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
exit 0;
