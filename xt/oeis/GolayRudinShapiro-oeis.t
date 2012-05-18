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

use Math::NumSeq::GolayRudinShapiro;

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
# A022156 - first differences of A020991 highest occurrence of n in cumulative

{
  my $anum = 'A022156';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq = Math::NumSeq::GolayRudinShapiro->new;
    my $cumulative = 0;
    my @count;
    my $prev = 0;
    for (my $n = 1; @got < @$bvalues; ) {
      my ($i, $value) = $seq->next;
      $cumulative += $value;
      $count[$cumulative]++;
      if ($cumulative == $n && $count[$cumulative] >= $n) {
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
# A020987 - 0,1 values

{
  my $anum = 'A020987';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq = Math::NumSeq::GolayRudinShapiro->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, ($value == 1 ? 0 : 1);
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum - values 0,1");
}

#------------------------------------------------------------------------------
# A022155 - positions of -1

{
  my $anum = 'A022155';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq = Math::NumSeq::GolayRudinShapiro->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      if ($value == -1) {
        push @got, $i;
      }
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum - positions of -1");
}


#------------------------------------------------------------------------------
# A020986 - cumulative +1,-1

{
  my $anum = 'A020986';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if (! $bvalues) {
    MyTestHelpers::diag ("$anum not available");
  } else {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq = Math::NumSeq::GolayRudinShapiro->new;
    my $cumulative = 0;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      $cumulative += $value;
      push @got, $cumulative;
    }

    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum - cumulative");
}


#------------------------------------------------------------------------------
# A020990 - cumulative with flip for low bit

{
  my $anum = 'A020990';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");
  } else {
    MyTestHelpers::diag ("$anum not available");
  }

  {
    my @got;
    if ($bvalues) {
      my $seq = Math::NumSeq::GolayRudinShapiro->new;
      my $cumulative = 0;
      while (@got < @$bvalues) {
        my ($i, $value) = $seq->next;
        if ($i & 1) {
          $value = -$value;
        }
        $cumulative += $value;
        push @got, $cumulative;
      }

      if (! numeq_array(\@got, $bvalues)) {
        MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
        MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
      }
    }
    skip (! $bvalues,
          numeq_array(\@got, $bvalues),
          1, "$anum - cumulative with flip odd");
  }

  # is also GRS(2n+1)
  {
    my @got;
    if ($bvalues) {
      my $seq = Math::NumSeq::GolayRudinShapiro->new;
      my $cumulative = 0;
      for (my $n = 1; @got < @$bvalues; $n += 2) { # odd 1,3,5,7,etc
        my $value = $seq->ith($n);
        $cumulative += $value;
        push @got, $cumulative;
      }

      if (! numeq_array(\@got, $bvalues)) {
        MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
        MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
      }
    }
    skip (! $bvalues,
          numeq_array(\@got, $bvalues),
          1, "$anum - cumulative with flip odd, by GRS(2n+1)");
  }
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

    my $seq = Math::NumSeq::GolayRudinShapiro->new;
    my $cumulative = 0;
    my @count;
    for (my $n = 1; @got < @$bvalues; ) {
      my ($i, $value) = $seq->next;
      $cumulative += $value;
      $count[$cumulative]++;
      if ($cumulative == $n && $count[$cumulative] >= $n) {
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

    my $seq = Math::NumSeq::GolayRudinShapiro->new;
    my $cumulative = 0;
    my @triangle;
    for (my $n = 1; @got < @$bvalues; ) {
      my ($i, $value) = $seq->next;
      $cumulative += $value;

      my $aref = ($triangle[$cumulative] ||= []);
      push @$aref, $i;
      if ($cumulative == $n && scalar(@$aref) == $n) {
        while (@$aref && @got < @$bvalues) {
          push @got, shift @$aref;
        }
        delete $triangle[$cumulative];
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
