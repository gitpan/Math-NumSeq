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
plan tests => 1;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::Totient;

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
# A007617 - non-totients

{
  my $anum = 'A007617';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  my $diff;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq  = Math::NumSeq::Totient->new;
    for (my $n = 1; @got < @$bvalues; $n++) {
      if (! $seq->pred($n)) {
        push @got, $n;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..60]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..60]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum -- non-totients");
}

#------------------------------------------------------------------------------
exit 0;
