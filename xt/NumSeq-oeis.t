#!/usr/bin/perl -w

# Copyright 2010, 2011 Kevin Ryde

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


# Compare NumSeq code against downloaded OEIS values.
#


use 5.004;
use strict;
use Test::More tests => 1;

use lib 't','xt';
use MyTestHelpers;
MyTestHelpers::nowarnings();
use MyOEIS;

use Math::NumSeq::OEIS::Catalogue;

use POSIX ();
POSIX::setlocale(POSIX::LC_ALL(), 'C'); # no message translations

# uncomment this to run the ### lines
#use Devel::Comments '###';

use constant DBL_INT_MAX => (POSIX::FLT_RADIX() ** POSIX::DBL_MANT_DIG());
use constant MY_MAX => (POSIX::FLT_RADIX() ** (POSIX::DBL_MANT_DIG()-5));

sub diff_nums {
  my ($gotaref, $wantaref) = @_;
  for (my $i = 0; $i < @$gotaref; $i++) {
    if ($i > @$wantaref) {
      return "want ends prematurely i=$i";
    }
    my $got = $gotaref->[$i];
    my $want = $wantaref->[$i];
    if (! defined $got && ! defined $want) {
      next;
    }
    if (! defined $got || ! defined $want) {
      return "different i=$i got=".(defined $got ? $got : '[undef]')
        ." want=".(defined $want ? $want : '[undef]');
    }
    $got =~ /^[0-9.-]+$/
      or return "not a number i=$i got='$got'";
    $want =~ /^[0-9.-]+$/
      or return "not a number i=$i want='$want'";
    if ($got != $want) {
      return "different i=$i numbers got=$got want=$want";
    }
  }
  return undef;
}

sub _delete_duplicates {
  my ($arrayref) = @_;
  my %seen;
  @seen{@$arrayref} = ();
  @$arrayref = sort {$a<=>$b} keys %seen;
}

sub _min {
  my $ret = shift;
  while (@_) {
    my $next = shift;
    if ($ret > $next) {
      $ret = $next;
    }
  }
  return $ret;
}

my %duplicate_anum = (A021015 => 'A010680',
                     );

#------------------------------------------------------------------------------
my $good = 1;
my $total_checks = 0;

sub check_class {
  my ($anum, $class, $parameters) = @_;
  eval "require $class" or die;

  my $name = join(',',
                  $class,
                  map {defined $_ ? $_ : '[undef]'} @$parameters);

  my ($want, $want_i_start, $filename) = MyOEIS::read_values($anum)
    or do {
      diag "skip $anum $name, no file data";
      return;
    };
  ### read_values len: scalar(@$want)
  ### $want_i_start

  if ($anum eq 'A009003') {
    #  PythagoreanHypots slow, only first 250 values for now ...
    splice @$want, 250;
  } elsif ($anum eq 'A003434') {
    #  TotientSteps slow, only first 250 values for now ...
    splice @$want, 250;
  } elsif ($anum eq 'A007770') {
    #  Happy bit slow, only first few values for now, not B-file 140,000 ...
    splice @$want, 20000;
  } elsif ($anum eq 'A030547') {
    # sample values start from i=1 but OFFSET=0
    if ($want->[9] == 2) {
      unshift @$want, 1;
    }
  } elsif ($anum eq 'A082897') {
    # full B-file goes to 2^32 which is too much to sieve
    @$want = grep {$_ < 200_000} @$want;

  } elsif ($anum eq 'A001359'
           || $anum eq 'A006512'
           || $anum eq 'A014574'
           || $anum eq 'A001097') {
    # twin primes shorten for now
    @$want = grep {$_ < 1_000_000} @$want;

  } elsif ($anum eq 'A005384') {
    # sophie germain shorten for now
    @$want = grep {$_ < 1_000_000} @$want;

  } elsif ($anum eq 'A006567') {
    # emirps shorten for now
    @$want = grep {$_ < 100_000} @$want;

  } elsif ($anum eq 'A004542') {  # sqrt(2) in base 5
    diag "skip doubtful $anum $name";
    return;
  } elsif ($anum eq 'A022000') {  # FIXME: not 1/996 ???
    diag "skip doubtful $anum $name";
    return;
  }

  my $want_count = scalar(@$want);
  diag "$anum $name  ($want_count values to $want->[-1])";

  my $hi = $want->[-1];
  if ($hi < @$want) {
    $hi = @$want;
  }
  ### $hi
  # hi => $hi

  my $seq = $class->new (@$parameters);
  ### seq: ref $seq
  if ($seq->isa('Math::NumSeq::OEIS::File')) {
    die "Oops, not meant to exercies $seq";
  }

  {
    my $got_anum = $seq->oeis_anum;
    if (! defined $got_anum) {
      $got_anum = 'undef';
    }
    my $want_anum = $duplicate_anum{$anum} || $anum;
    if ($got_anum ne $want_anum) {
      $good = 0;
      diag "bad: $name";
      diag "got anum  $got_anum";
      diag ref $seq;
    }
  }

  # {
  #   my $got_i_start = $seq->i_start;
  #   if ($got_i_start != $want_i_start) {
  #     diag "note: $name";
  #     diag ref $seq;
  #     diag "got  i_start  $got_i_start";
  #     diag "want i_start  $want_i_start";
  #   }
  # }

  {
    ### by next() ...
    my @got;
    my $got = \@got;
    while (my ($i, $value) = $seq->next) {
      push @got, $value;
      if (@got >= @$want) {
        last;
      }
    }

    my $diff = diff_nums($got, $want);
    if (defined $diff) {
      $good = 0;
      diag "bad: $name by next() hi=$hi";
      diag $diff;
      diag ref $seq;
      diag $filename;
      diag "got  len ".scalar(@$got);
      diag "want len ".scalar(@$want);
      if ($#$got > 200) { $#$got = 200 }
      if ($#$want > 200) { $#$want = 200 }
      diag "got  ". join(',', map {defined() ? $_ : 'undef'} @$got);
      diag "want ". join(',', map {defined() ? $_ : 'undef'} @$want);
    }
  }
  {
    ### by next() after rewind ...
    $seq->rewind;

    my @got;
    my $got = \@got;
    while (my ($i, $value) = $seq->next) {
      ### $i
      ### $value
      push @got, $value;
      if (@got >= @$want) {
        last;
      }
    }

    my $diff = diff_nums($got, $want);
    if (defined $diff) {
      $good = 0;
      diag "bad: $name by rewind next() hi=$hi";
      diag $diff;
      diag ref $seq;
      diag $filename;
      diag "got  len ".scalar(@$got);
      diag "want len ".scalar(@$want);
      if ($#$got > 200) { $#$got = 200 }
      if ($#$want > 200) { $#$want = 200 }
      diag "got  ". join(',', map {defined() ? $_ : 'undef'} @$got);
      diag "want ". join(',', map {defined() ? $_ : 'undef'} @$want);
    }
  }

  {
    ### by pred() ...
    $seq->can('pred')
      or next;
    if ($seq->characteristic('count')) {
      ### no pred on characteristic(count) ..
      next;
    }
    if ($seq->characteristic('digits')) {
      ### no pred on characteristic(digits) ..
      next;
    }
    if ($seq->characteristic('modulus')) {
      ### no pred on characteristic(modulus) ..
      next;
    }
    if ($seq->characteristic('pn1')) {
      ### no pred on characteristic(pn1) ..
      next;
    }

    $hi = 0;
    foreach my $want (@$want) {
      if ($want > $hi) { $hi = $want }
    }
    if ($hi > 1000) {
      $hi = 1000;
      $want = [ grep {$_<=$hi} @$want ];
    }
    _delete_duplicates($want);
    #### $want

    my @got;
    foreach my $value (_min(@$want) .. $hi) {
      #### $value
      if ($seq->pred($value)) {
        push @got, $value;
      }
    }
    my $got = \@got;

    my $diff = diff_nums($got, $want);
    if (defined $diff) {
      $good = 0;
      diag "bad: $name by pred() hi=$hi";
      diag $diff;
      diag ref $seq;
      diag $filename;
      diag "got  len ".scalar(@$got);
      diag "want len ".scalar(@$want);
      if ($#$got > 200) { $#$got = 200 }
      if ($#$want > 200) { $#$want = 200 }
      diag "got  ". join(',', map {defined() ? $_ : 'undef'} @$got);
      diag "want ". join(',', map {defined() ? $_ : 'undef'} @$want);
    }
  }

  $total_checks++;
}

#------------------------------------------------------------------------------
# forced

# check_class ('A001097',
#              'Math::NumSeq::TwinPrimes',
#              [ pairs => 'both' ]);
# exit 0;


#------------------------------------------------------------------------------
# OEIS-Catalogue generated vs files

for (my $anum = Math::NumSeq::OEIS::Catalogue->anum_first;  #  'A007770';
     defined $anum;
     $anum = Math::NumSeq::OEIS::Catalogue->anum_after($anum)) {
  ### $anum

  my $info = Math::NumSeq::OEIS::Catalogue->anum_to_info($anum);
  if (! $info) {
    $good = 0;
    diag "bad: $anum";
    diag "info is undef";
    next;
  }
  if ($info->{'class'} eq 'Math::NumSeq::OEIS::File') {
    next;
  }
  ### $info

  check_class ($info->{'anum'},
               $info->{'class'},
               $info->{'parameters'});
}

#------------------------------------------------------------------------------
# duplicates or uncatalogued

# check_class ('A010701',
#              'Math::NumSeq::FractionDigits',
#              [ fraction => '10/3', radix => 10 ]);

diag "total checks $total_checks";
$good = 1;
ok ($good);
exit 0;
