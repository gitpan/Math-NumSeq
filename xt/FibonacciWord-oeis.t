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
BEGIN { plan tests => 14 }

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
# A000201 - position of 0s, starting from 1

{
  my $anum = 'A000201';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      if ($value == 0) {
        push @got, $i + 1;
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
        1, "$anum -- dense");
}

#------------------------------------------------------------------------------
# A114986 - 1/0 for positions of 0s starting from 1,
# so fib word inverse with extra initial 1

{
  my $anum = 'A114986';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    push @got, 1;
    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, ($value ? 0 : 1);
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
        1, "$anum -- dense");
}

#------------------------------------------------------------------------------
# A003622 - position of 1s

{
  my $anum = 'A003622';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      if ($value == 1) {
        push @got, $i;
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
        1, "$anum -- dense");
}

#------------------------------------------------------------------------------
# A096270 - 0->01, 1->011
# is FibonacciWord invert 1,0 with extra initial 0

{
  my $anum = 'A096270';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    push @got, 0;
    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, ($value ? 0 : 1);
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
        1, "$anum -- dense");
}

#------------------------------------------------------------------------------
# A189479 - 0->01, 1->101
# is FibonacciWord invert 1,0 with extra initial 0,1

{
  my $anum = 'A189479';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    push @got, 0,1;
    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, ($value ? 0 : 1);
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
        1, "$anum -- dense");
}

#------------------------------------------------------------------------------
# A005203 -- bignums of F(n) digits each

{
  my $anum = 'A005203';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    require Math::BigInt;
    my $big = Math::BigInt->new (0);

    require Math::NumSeq::Fibonacci;
    my $fib  = Math::NumSeq::Fibonacci->new;
    $fib->next;
    $fib->next;
    my ($target_i, $target) = $fib->next;

    push @got, 0;
    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;

      if ($i >= $target) {
        push @got, $big;
        ($target_i, $target) = $fib->next;
      }

      $value = 1 - $value;
      $big = 2*$big + $value;
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
        1, "$anum -- decimal bignums");
}

#------------------------------------------------------------------------------
# A008352 -- decimal bignums low to high, 1,2

{
  my $anum = 'A008352';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    require Math::BigInt;
    my $big = Math::BigInt->new (0);

    require Math::NumSeq::Fibonacci;
    my $fib  = Math::NumSeq::Fibonacci->new;
    $fib->next;
    $fib->next;
    my ($target_i, $target) = $fib->next;

    push @got, 1;
    my $seq  = Math::NumSeq::FibonacciWord->new;
    my $pow = 1;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;

      if ($i >= $target) {
        push @got, $big;
        ($target_i, $target) = $fib->next;
      }

      $big += $pow * ($value ? 1 : 2);
      $pow *= 10;
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
        1, "$anum -- decimal bignums");
}

#------------------------------------------------------------------------------
# A005614 - 1,0

{
  my $anum = 'A005614';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      $value = 1 - $value;
      push @got, $value;
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
        1, "$anum -- 1,0");
}

#------------------------------------------------------------------------------
# A003842 - 1,2

{
  my $anum = 'A003842';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, ($value ? 2 : 1);
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
        1, "$anum -- 1,2");
}

#------------------------------------------------------------------------------
# A014675 - 2,1

{
  my $anum = 'A014675';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, ($value ? 1 : 2);
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
        1, "$anum -- 2,1");
}

#------------------------------------------------------------------------------
# A001468 - 1,2 extra initial 1

{
  my $anum = 'A001468';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    push @got, 1;
    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, ($value ? 1 : 2);
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
        1, "$anum -- 1,2");
}

#------------------------------------------------------------------------------
# A076662 - first diffs of positions of 0s, is 2,3 with extra initial 3

{
  my $anum = 'A076662';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    push @got, 3;
    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, ($value ? 2 : 3);
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
        1, "$anum -- 2,1");
}

#------------------------------------------------------------------------------
# A143667 - dense Fibonacci word

{
  my $anum = 'A143667';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i1, $value1) = $seq->next;
      my ($i2, $value2) = $seq->next;
      push @got, 2*$value1 + $value2;
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
        1, "$anum -- dense");
}

#------------------------------------------------------------------------------
# A036299 -- binary bignums high to low, inverted 1,0

{
  my $anum = 'A036299';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    MyTestHelpers::diag ("$anum has ",scalar(@$bvalues)," values");

    require Math::BigInt;
    my $big = Math::BigInt->new (0);

    require Math::NumSeq::Fibonacci;
    my $fib  = Math::NumSeq::Fibonacci->new;
    $fib->next;
    $fib->next;
    my ($target_i, $target) = $fib->next;

    my $seq  = Math::NumSeq::FibonacciWord->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;

      if ($i >= $target) {
        push @got, $big;
        ($target_i, $target) = $fib->next;
      }

      $big *= 10;
      $big += ($value ? 0 : 1);
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..8]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..8]));
    }
  } else {
    MyTestHelpers::diag ("$anum not available");
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum -- decimal bignums");
}


#------------------------------------------------------------------------------
exit 0;
