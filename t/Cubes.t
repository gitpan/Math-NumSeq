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

use 5.004;
use strict;
use Test;
plan tests => 7;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

use Math::NumSeq::Cubes;

# uncomment this to run the ### lines
#use Smart::Comments;

#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 9;
  ok ($Math::NumSeq::Cubes::VERSION, $want_version, 'VERSION variable');
  ok (Math::NumSeq::Cubes->VERSION,  $want_version, 'VERSION class method');

  ok (eval { Math::NumSeq::Cubes->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::Cubes->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# characteristic()

{
  my $seq = Math::NumSeq::Cubes->new;
  ok (! $seq->characteristic('count'), 1, 'characteristic(count)');
  ok ($seq->characteristic('digits'), undef, 'characteristic(digits)');
}


#------------------------------------------------------------------------------
# pred()

{
  my $seq = Math::NumSeq::Cubes->new;
  ok (!! $seq->pred(27),
      1,
      'pred() 27 is cube');

}


#------------------------------------------------------------------------------
# bit of a diagnostic to see how accurate cbrt() is, for the cbrt(27) not an
# integer struck in the past
{
  require Math::Libm;
  my $n = 27;
  $n = Math::Libm::cbrt ($n);
  MyTestHelpers::diag("cbrt(27) is $n");
  my $i = int($n);
  MyTestHelpers::diag("int() is $i");
  my $eq = ($n == int($n));
  MyTestHelpers::diag("equal is '$eq'");
}

exit 0;


