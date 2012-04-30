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

use Math::NumSeq::GolayRudinShapiroCumulative;

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
# A051032 - GRS cumulative of 2^n

{
  my $anum = 'A051032';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    require Math::BigInt;
    my $seq = Math::NumSeq::GolayRudinShapiroCumulative->new;
    for (my $n = Math::BigInt->new(1); @got < @$bvalues; $n *= 2) {
      push @got, $seq->ith($n);
    }

    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum - GRS cumulative of 2^n");
}

#------------------------------------------------------------------------------
# A022156 - first differences of A020991 highest occurrence of n in cumulative

{
  my $anum = 'A022156';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq = Math::NumSeq::GolayRudinShapiroCumulative->new;
    my @count;
    my $prev = 0;
    for (my $n = 1; @got < @$bvalues; ) {
      my ($i, $value) = $seq->next;
      $count[$value]++;
      if ($value == $n && $count[$value] >= $n) {
        if ($n >= 2) {
          push @got, $i - $prev;
        }
        $prev = $i;
        $n++;
      }
    }

    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum - first diffs highest occurrence of n as cumulative");
}

#------------------------------------------------------------------------------
# A020991 - highest occurrence of n in cumulative

{
  my $anum = 'A020991';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq = Math::NumSeq::GolayRudinShapiroCumulative->new;
    my @count;
    for (my $n = 1; @got < @$bvalues; ) {
      my ($i, $value) = $seq->next;
      $count[$value]++;
      if ($value == $n && $count[$value] >= $n) {
        push @got, $i;
        $n++;
      }
    }

    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum - highest occurrence of n as cumulative");
}



#------------------------------------------------------------------------------
# A093573 - triangle of n as cumulative

{
  my $anum = 'A093573';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq = Math::NumSeq::GolayRudinShapiroCumulative->new;
    my @triangle;
    for (my $n = 1; @got < @$bvalues; ) {
      my ($i, $value) = $seq->next;

      my $aref = ($triangle[$value] ||= []);
      push @$aref, $i;
      if ($value == $n && scalar(@$aref) == $n) {
        while (@$aref && @got < @$bvalues) {
          push @got, shift @$aref;
        }
        delete $triangle[$value];
        $n++;
      }
    }

    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum - triangle of occurrences of n as cumulative");
}

#------------------------------------------------------------------------------
exit 0;
