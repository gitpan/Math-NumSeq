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

use Math::NumSeq::Fibbinary;

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
# A022342 - Zeckendorf even, i where value is even
#           floor(n*phi)-1

{
  my $anum = 'A022342';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    require Math::NumSeq::Fibonacci;
    my $seq  = Math::NumSeq::Fibbinary->new;
    for (my $n = 0; @got < @$bvalues; $n++) {
      my ($i, $value) = $seq->next;
      if (($value % 2) == 0) {
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
        1, "$anum");
}

#------------------------------------------------------------------------------
# A035514 - Zeckendorf fibonnacis concatenated as decimal digits, high to low

{
  my $anum = 'A035514';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    require Math::NumSeq::Fibonacci;
    my $seq  = Math::NumSeq::Fibbinary->new;
    my $fibonacci  = Math::NumSeq::Fibonacci->new;
    for (my $n = 0; @got < @$bvalues; $n++) {
      my ($i, $value) = $seq->next;
      my $concat = '';
      my $pos = 0;
      while ($value) {
        if ($value & 1) {
          $concat = $fibonacci->ith($pos+2) . $concat;
        }
        $value >>= 1;
        $pos++;
      }
      push @got, $concat || 0;
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

#------------------------------------------------------------------------------
# A035515 - Zeckendorf fibonnacis concatenated as decimal digits, low to high

{
  my $anum = 'A035515';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    require Math::NumSeq::Fibonacci;
    my $seq  = Math::NumSeq::Fibbinary->new;
    my $fibonacci  = Math::NumSeq::Fibonacci->new;
    for (my $n = 0; @got < @$bvalues; $n++) {
      my ($i, $value) = $seq->next;
      my $concat = '';
      my $pos = 0;
      while ($value) {
        if ($value & 1) {
          $concat .= $fibonacci->ith($pos+2);
        }
        $value >>= 1;
        $pos++;
      }
      push @got, $concat || 0;
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

#------------------------------------------------------------------------------
# A035516 - Zeckendorf fibonnacis of each n, high to low
#           with single 0 for n=0

{
  my $anum = 'A035516';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    require Math::NumSeq::Fibonacci;
    my $fibonacci  = Math::NumSeq::Fibonacci->new;
    require Math::NumSeq::Repdigits;
    my $seq  = Math::NumSeq::Fibbinary->new;
  OUTER: for (;;) {
      my ($i, $value) = $seq->next;
      if ($value) {
        my @bits = Math::NumSeq::Repdigits::_digit_split_lowtohigh($value,2);
        foreach my $pos (reverse 0 .. $#bits) {
          if ($bits[$pos]) {
            push @got, $fibonacci->ith($pos+2);
            last OUTER if @got >= @$bvalues;
          }
        }
      } else {
        push @got, 0;
      }
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

#------------------------------------------------------------------------------
# A035517 - Zeckendorf fibonnacis of each n, low to high
#           with single 0 for n=0

{
  my $anum = 'A035517';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    require Math::NumSeq::Fibonacci;
    my $fibonacci  = Math::NumSeq::Fibonacci->new;
    require Math::NumSeq::Repdigits;
    my $seq  = Math::NumSeq::Fibbinary->new;
  OUTER: for (;;) {
      my ($i, $value) = $seq->next;
      if ($value) {
        my @bits = Math::NumSeq::Repdigits::_digit_split_lowtohigh($value,2);
        foreach my $pos (0 .. $#bits) {
          if ($bits[$pos]) {
            push @got, $fibonacci->ith($pos+2);
            last OUTER if @got >= @$bvalues;
          }
        }
      } else {
        push @got, 0;
      }
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum");
}

#------------------------------------------------------------------------------
# A048678 - binary expand 1->01, so no adjacent 1 bits
# is a permutation of the fibbinary numbers

{
  my $anum = 'A048678';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    for (my $n = 0; @got < @$bvalues; $n++) {
      push @got, expand_1_to_01($n);
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum -- binary expand 1->01");
}

sub expand_1_to_01 {
  my ($n) = @_;
  my $bits = digit_split($n,2);  # $bits->[0] low bit
  @$bits = map {$_==0 ? (0) : (1,0)} @$bits;
  return digit_join($bits,2);
}

sub digit_split {
  my ($n, $radix) = @_;
  ### _digit_split(): $n

  if ($n == 0) {
    return [ 0 ];
  }
  my @ret;
  while ($n) {
    push @ret, $n % $radix;  # ret[0] low digit
    $n = int($n/$radix);
  }
  return \@ret;
}

sub digit_join {
  my ($aref, $radix) = @_;
  ### digit_join(): $aref

  my $n = 0;
  foreach my $digit (reverse @$aref) {  # high to low
    $n *= $radix;
    $n += $digit;
  }
  return $n;
}


#------------------------------------------------------------------------------
# A048679 - compressed Fibbinary mapping 01->1
# (permutation of the integers)

{
  my $anum = 'A048679';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    my $seq  = Math::NumSeq::Fibbinary->new;
    while (@got < @$bvalues) {
      my ($i, $value) = $seq->next;
      push @got, compress_01_to_1($value);
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum -- dense");
}

# also delete one 0 from each run of 0s
sub compress_01_to_1 {
  my ($value) = @_;
  my $ret = $value * 0; # inherit bignum
  my $retbit = 1;
  while ($value) {
    my $bits = $value & 3;
    if ($bits == 0 || $bits == 2) {
      $value >>= 1;
    } elsif ($bits == 1) {
      $ret += $retbit;
      $value >>= 2;
    } else {
      die "Oops compress_01 bits 11";
    }
    $retbit <<= 1;
  }
  return $ret;
}


#------------------------------------------------------------------------------
# A048680 - binary expand 1->01, then fibbinary index of that value
# (permutation of the integers)

{
  my $anum = 'A048680';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  if ($bvalues) {
    my $seq  = Math::NumSeq::Fibbinary->new;
    for (my $n = 0; @got < @$bvalues; $n++) {
      my $expand = expand_1_to_01($n);
      my $fib_i = $seq->value_to_i_floor($expand);
      push @got, $fib_i;
    }
    if (! numeq_array(\@got, $bvalues)) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..20]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..20]));
    }
  }
  skip (! $bvalues,
        numeq_array(\@got, $bvalues),
        1, "$anum -- binary expand 1->01 then fibbinary index");
}


#------------------------------------------------------------------------------
exit 0;
