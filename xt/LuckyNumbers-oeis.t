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
plan tests => 18;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::LuckyNumbers;

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
# A137164 etc - Lucky with various modulo

foreach my $elem (['A137164', 0, 3],
                  ['A137165', 1, 3],

                  ['A137168', 1, 4],
                  ['A137170', 3, 4],

                  ['A137182', 0, 7],
                  ['A137183', 1, 7],
                  ['A137184', 2, 7],
                  ['A137185', 3, 7],
                  ['A137186', 4, 7],
                  ['A137187', 5, 7],
                  ['A137188', 6, 7],

                  ['A137190', 1, 8],
                  ['A137192', 3, 8],
                  ['A137194', 5, 8],
                  ['A137196', 7, 8],
                 ) {
  my ($anum, $target, $modulus) = @$elem;
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");
    my $seq = Math::NumSeq::LuckyNumbers->new;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      if (($value % $modulus) == $target) {
        push @got, $value;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("target=$target modulus=$modulus");
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum - lucky congruent to $target modulo $modulus");
}

#------------------------------------------------------------------------------
# A118567 - Lucky with only odd digits

{
  my $anum = 'A118567';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    if ($bvalues->[20] == 171) {
      MyTestHelpers::diag ("  insert apparently missing 159");
      splice @$bvalues, 20,0, 159;
    }

    my $seq = Math::NumSeq::LuckyNumbers->new;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      if ($value =~ /^[13579]+$/) {
        push @got, $value;
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
        "$anum - lucky with only odd digits");
}

#------------------------------------------------------------------------------
# A050505 - non-Lucky numbers

{
  my $anum = 'A050505';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");
    my $seq = Math::NumSeq::LuckyNumbers->new;
    my @got;
    my ($i, $value) = $seq->next;
    for (my $n = 1; @got < @$bvalues; $n++) {
      if ($n < $value) {
        push @got, $n;
      } else {
        ($i, $value) = $seq->next;
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
        "$anum - non-lucky");
}

#------------------------------------------------------------------------------
# A145649 - 0,1 characteristic

{
  my $anum = 'A145649';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");
    my $seq = Math::NumSeq::LuckyNumbers->new;
    my @got;
    my ($i, $value) = $seq->next;
    for (my $n = 1; @got < @$bvalues; $n++) {
      if ($n < $value) {
        push @got, 0;
      } else {
        push @got, 1;
        ($i, $value) = $seq->next;
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
        "$anum - 0,1 characteristic");
}

#------------------------------------------------------------------------------
exit 0;
