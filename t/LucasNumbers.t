#!/usr/bin/perl -w

# Copyright 2013 Kevin Ryde

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
plan tests => 42;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

use Math::NumSeq::LucasNumbers;

# uncomment this to run the ### lines
#use Smart::Comments;


#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 63;
  ok ($Math::NumSeq::LucasNumbers::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::LucasNumbers->VERSION,  $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::LucasNumbers->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::LucasNumbers->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# characteristic(), i_start(), parameters

{
  my $seq = Math::NumSeq::LucasNumbers->new;
  ok ($seq->characteristic('digits'), undef, 'characteristic(digits)');
  ok (! $seq->characteristic('smaller'), 1, 'characteristic(smaller)');
  ok (! $seq->characteristic('count'), 1, 'characteristic(count)');
  ok ($seq->characteristic('integer'), 1, 'characteristic(integer)');

  ok ($seq->characteristic('increasing'), 1,
      'characteristic(increasing)');
  ok ($seq->characteristic('non_decreasing'), 1,
      'characteristic(non_decreasing)');

  ok ($seq->characteristic('increasing_from_i'), $seq->i_start,
      'characteristic(increasing_from_i)');
  ok ($seq->characteristic('non_decreasing_from_i'), $seq->i_start,
      'characteristic(non_decreasing_from_i)');

  ok ($seq->i_start, 1, 'i_start()');

  my @pnames = map {$_->{'name'}} $seq->parameter_info_list;
  ok (join(',',@pnames),
      '');
}

#------------------------------------------------------------------------------
# negative ith()

{
  my $seq = Math::NumSeq::LucasNumbers->new;
  my $l1 = $seq->ith(2);
  my $l0 = $seq->ith(1);
  for (my $i = 0; $i > -10; $i--) {
    my $l = $seq->ith($i);
    ok ($l + $l0, $l1);
    $l1 = $l0;
    $l0 = $l;
  }
}


#------------------------------------------------------------------------------
# docs claim L[i] = F[i+1] + F[i-1]
#                 = F[i+2] - F[i-2]

{
  require Math::NumSeq::Fibonacci;
  my $fib = Math::NumSeq::Fibonacci->new;
  my $luc = Math::NumSeq::LucasNumbers->new;
  for (my $i = 3; $i < 12; $i++) {
    my $l = $luc->ith($i);
    {
      my $fsum = $fib->ith($i+1) + $fib->ith($i-1);
      ok ($fsum, $l);
    }
    if ($i >= 2) {
      my $fdiff = $fib->ith($i+2) - $fib->ith($i-2);
      ok ($fdiff, $l);
    }
  }
}

exit 0;
