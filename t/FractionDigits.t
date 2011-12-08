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

my $test_count = (tests => 260)[1];
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
  my $want_version = 21;
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
# BigInt

{
  my $uv_len = length(~0);
  my $num = '257'x$uv_len;
  my $den = '9'x(3*$uv_len);
  my $frac = "$num/$den";
  # MyTestHelpers::diag ("uv_len $uv_len, frac $frac");

  my $seq = Math::NumSeq::FractionDigits->new(fraction => $frac);
  my $want_i = 0;
  foreach (1 .. 2*$uv_len) {
    { my ($i,$value) = $seq->next;
      ok ($i, $want_i++);
      ok ($value, 2);
    }
    { my ($i,$value) = $seq->next;
      ok ($i, $want_i++);
      ok ($value, 5);
    }
    { my ($i,$value) = $seq->next;
      ok ($i, $want_i++);
      ok ($value, 7);
    }
  }
}


exit 0;
