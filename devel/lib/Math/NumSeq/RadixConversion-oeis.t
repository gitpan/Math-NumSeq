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
use POSIX 'ceil';
use Test;
plan tests => 2;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::Math::NumSeq::RadixConversion;

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
# A062847 - base 2 interpreted as base 6 is multiple of original

{
  my $anum = 'A156660';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my @got;
    my $seq = Math::NumSeq::RadixConversion->new (radix => 2,
                                                  to_radix => 6);
    for (my $n = 0; @got < @$bvalues; $n++) {
      my $value = $seq->ith($n);
      if (($value % $n) == 0) {
        push @got, $n;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..30]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..30]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
exit 0;
