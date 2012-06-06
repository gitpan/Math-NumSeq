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
use List::Util 'max';

use Test;
plan tests => 7;

use lib 't','xt',              'devel/lib';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::LeastPrimitiveRoot;

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
# A114885 - primes with new record least primitive root, the prime index

{
  my $anum = 'A114885';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum,
                                                      max_value => 50_000);
  my $diff;
  if ($bvalues) {
    my $primes = Math::NumSeq::Primes->new;
    my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
    my $record = 0;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $prime) = $primes->next or last;
      my $root = $seq->ith($prime);
      if ($root > $record) {
        push @got, $i;
        $record = $root;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..10]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..10]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A071894 - largest primitive root of primes

{
  my $anum = 'A071894';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $primes = Math::NumSeq::Primes->new;
    my $seq = Math::NumSeq::LeastPrimitiveRoot->new (root_type => 'negative');
    my @got;
    while (@got < @$bvalues) {
      my ($i, $prime) = $primes->next or last;
      push @got, $prime + $seq->ith($prime);
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
# A002199 - least negative primitive root of primes

{
  my $anum = 'A002199';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $primes = Math::NumSeq::Primes->new;
    my $seq = Math::NumSeq::LeastPrimitiveRoot->new (root_type => 'negative');
    my @got;
    while (@got < @$bvalues) {
      my ($i, $prime) = $primes->next or last;
      push @got, - $seq->ith($prime);
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
# A001918 - least primitive root of primes

{
  my $anum = 'A001918';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my $diff;
  if ($bvalues) {
    my $primes = Math::NumSeq::Primes->new;
    my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $prime) = $primes->next or last;
      push @got, $seq->ith($prime);
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
# A001122 - primes with 2 as primitive root

{
  my $anum = 'A001122';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  my $diff;
  if ($bvalues) {
    my $primes = Math::NumSeq::Primes->new;
    my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
    while (@got < @$bvalues) {
      my ($i, $prime) = $primes->next or last;
      if ($seq->ith($prime) == 2) {
        push @got, $prime;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..10]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..10]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

# #------------------------------------------------------------------------------
# # A029932 - primes with new record least primitive root which is a prime
# 
# {
#   my $anum = 'A029932';
#   my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum,
#                                                       max_value => 100_000);
#   my $diff;
#   if ($bvalues) {
#     my $primes = Math::NumSeq::Primes->new;
#     my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
#     my $record = 0;
#     my @got;
#     while (@got < @$bvalues) {
#       my ($i, $prime) = $primes->next or last;
#       my $root = $seq->ith($prime);
#       next unless $primes->pred($root);
#       if ($root > $record) {
#         push @got, $prime;
#         $record = $root;
#       }
#     }
#     $diff = diff_nums(\@got, $bvalues);
#     if ($diff) {
#       MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..10]));
#       MyTestHelpers::diag ("got:     ",join(',',@got[0..10]));
#     }
#   }
#   skip (! $bvalues,
#         $diff, undef,
#         "$anum");
# }
# 
# #------------------------------------------------------------------------------
# # A002231 - primes with new record least primitive root which is a prime, the roots
# 
# {
#   my $anum = 'A002231';
#   my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum,
#                                                       max_count => 10);
#   my $diff;
#   if ($bvalues) {
#     my $primes = Math::NumSeq::Primes->new;
#     my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
#     my $record = 0;
#     my @got;
#     while (@got < @$bvalues) {
#       my ($i, $prime) = $primes->next or last;
#       my $root = $seq->ith($prime);
#       next unless $primes->pred($root);
#       if ($root > $record) {
#         push @got, $root;
#         $record = $root;
#       }
#     }
#     $diff = diff_nums(\@got, $bvalues);
#     if ($diff) {
#       MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..10]));
#       MyTestHelpers::diag ("got:     ",join(',',@got[0..10]));
#     }
#   }
#   skip (! $bvalues,
#         $diff, undef,
#         "$anum");
# }

#------------------------------------------------------------------------------
# A023048 - least prime with least primitive root n

{
  my $anum = 'A023048';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum,
                                                      max_value => 100_000);
  my $diff;
  if ($bvalues) {
    my $bmax = max(@$bvalues);
    my $primes = Math::NumSeq::Primes->new;
    my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
    my $record = 0;
    my @got;
    $got[1] = 2;
    for (;;) {
      my ($i, $prime) = $primes->next or last;
      my $root = $seq->ith($prime);
      if ($root < @$bvalues) {
        $got[$root] ||= $prime;
      }
      last if $prime >= $bmax;
    }
    shift @got; # not 0
    foreach (@got) {
      $_ ||= 0;
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
# A002230 - primes with new record least primitive root

{
  my $anum = 'A002230';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum,
                                                      max_value => 100_000);
  my $diff;
  if ($bvalues) {
    my $primes = Math::NumSeq::Primes->new;
    my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
    my $record = 0;
    my @got;
    while (@got < @$bvalues) {
      my ($i, $prime) = $primes->next or last;
      my $root = $seq->ith($prime);
      if ($root > $record) {
        push @got, $prime;
        $record = $root;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..10]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..10]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
# A001122 - primes with 2 as primitive root

{
  my $anum = 'A001122';
  my ($bvalues, $lo, $filename) = MyOEIS::read_values($anum);
  my @got;
  my $diff;
  if ($bvalues) {
    my $primes = Math::NumSeq::Primes->new;
    my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
    while (@got < @$bvalues) {
      my ($i, $prime) = $primes->next or last;
      if ($seq->ith($prime) == 2) {
        push @got, $prime;
      }
    }
    $diff = diff_nums(\@got, $bvalues);
    if ($diff) {
      MyTestHelpers::diag ("bvalues: ",join(',',@{$bvalues}[0..10]));
      MyTestHelpers::diag ("got:     ",join(',',@got[0..10]));
    }
  }
  skip (! $bvalues,
        $diff, undef,
        "$anum");
}

#------------------------------------------------------------------------------
exit 0;
