#!/usr/bin/perl -w

# Copyright 2011 Kevin Ryde

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

use lib 't';
use MyTestHelpers;
BEGIN { MyTestHelpers::nowarnings(); }

use Math::NumSeq::FractionDigits;

# uncomment this to run the ### lines
#use Smart::Comments;

my $test_count = (tests => 29)[1];
plan tests => $test_count;

{
  require Math::BigInt;
  MyTestHelpers::diag ('Math::BigInt version ', Math::BigInt->VERSION);

  my $n = Math::BigInt->new(1);
  if (! $n->can('bsqrt')) {
    MyTestHelpers::diag ('skip due to Math::BigInt no bsqrt()');
    foreach (1 .. $test_count) {
      skip ('skip due to Math::BigInt no bsqrt()', 1, 1);
    }
    exit 0;
  }
}



#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 25;
  ok ($Math::NumSeq::FractionDigits::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::FractionDigits->VERSION,  $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::FractionDigits->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::FractionDigits->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# _to_int_and_decimals()

{
  foreach my $elem (['1', '1',0],
                    ['1.', '1',0],
                    ['1.5', '15',1],
                    ['1.50', '15',1],
                    ['1.500', '15',1],
                    ['1.005', '1005',3],
                    ['1.0050', '1005',3],
                    ['1.00500', '1005',3],
                   ) {
    my ($n, $want, $want_decimals) = @$elem;
    my ($got, $got_decimals)
      = Math::NumSeq::FractionDigits::_to_int_and_decimals($n);
    ok ($got, $want, "$n");
    ok ($got_decimals, $want_decimals, "$n");
  }
}


#------------------------------------------------------------------------------
# characteristic()

{
  my $seq = Math::NumSeq::FractionDigits->new (fraction => '1/29');
  ok ($seq->characteristic('digits'), 10, 'characteristic(digits)');
  ok ($seq->characteristic('smaller'), 1, 'characteristic(smaller)');
  ok (! $seq->characteristic('count'), 1, 'characteristic(count)');
  ok ($seq->characteristic('integer'), 1, 'characteristic(integer)');

  ok (! $seq->characteristic('increasing'), 1,
      'characteristic(increasing)');
  ok (! $seq->characteristic('non_decreasing'), 1,
      'characteristic(non_decreasing)');
  ok ($seq->characteristic('increasing_from_i'), undef,
      'characteristic(increasing_from_i)');
  ok ($seq->characteristic('non_decreasing_from_i'), undef,
      'characteristic(non_decreasing_from_i)');
}


#------------------------------------------------------------------------------
# BigInt

{
  my $uv_len = length(~0);
  my $num = '257'x$uv_len;
  my $den = '9'x(3*$uv_len);
  my $frac = "$num/$den";
  # MyTestHelpers::diag ("uv_len $uv_len, frac $frac");

  my $seq = Math::NumSeq::FractionDigits->new(fraction => $frac);
  my $want_i = 0;
  my $bad = 0;
  foreach (1 .. 2*$uv_len) {
    { my ($i,$value) = $seq->next;
      if ($i != $want_i++) {
        MyTestHelpers::diag ("i=$i want_i=$want_i");
        last if ++$bad > 10;
      }
      if ($value != 2) {
        MyTestHelpers::diag ("value=$value want 2");
        last if ++$bad > 10;
      }
    }
    { my ($i,$value) = $seq->next;
      if ($i != $want_i++) {
        MyTestHelpers::diag ("i=$i want_i=$want_i");
        last if ++$bad > 10;
      }
      if ($value != 5) {
        MyTestHelpers::diag ("value=$value want 5");
        last if ++$bad > 10;
      }
    }
    { my ($i,$value) = $seq->next;
      if ($i != $want_i++) {
        MyTestHelpers::diag ("i=$i want_i=$want_i");
        last if ++$bad > 10;
      }
      if ($value != 7) {
        MyTestHelpers::diag ("value=$value want 7");
        last if ++$bad > 10;
      }
    }
  }
  ok ($bad, 0);
}


exit 0;