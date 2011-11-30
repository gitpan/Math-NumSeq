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
plan tests => 10;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

use Math::NumSeq::Fibbinary;


#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 19;
  ok ($Math::NumSeq::Fibbinary::VERSION, $want_version, 'VERSION variable');
  ok (Math::NumSeq::Fibbinary->VERSION,  $want_version, 'VERSION class method');

  ok (eval { Math::NumSeq::Fibbinary->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::Fibbinary->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# pred()

{
  my $seq = Math::NumSeq::Fibbinary->new;
  ok ($seq->pred(0), 1);
  ok ($seq->pred(1), 1);
  ok (! $seq->pred(3), 1);
  ok ($seq->pred(4), 1);

  ok ($seq->pred(17), 1);
  ok ($seq->pred(17 * 2**256), 1);
}
exit 0;


