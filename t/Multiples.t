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

use lib 't';
use MyTestHelpers;
BEGIN { MyTestHelpers::nowarnings(); }

use Math::NumSeq::Multiples;

my $test_count = (tests => 10)[1];
plan tests => $test_count;


#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 37;
  ok ($Math::NumSeq::Multiples::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::Multiples->VERSION,  $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::Multiples->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::Multiples->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# characteristic(), i_start(), parameters

{
  my $seq = Math::NumSeq::Multiples->new (multiples => 29);
  ok ($seq->characteristic('integer'), 1, 'characteristic(integer)');
  ok ($seq->i_start, 0, 'i_start()');

  my @pnames = map {$_->{'name'}} $seq->parameter_info_list;
  ok (join(',',@pnames),
      'multiples');
}

{
  my $seq = Math::NumSeq::Multiples->new (multiples => 1.5);
  ok (! $seq->characteristic('integer'), 1, 'characteristic(integer)');
}

#------------------------------------------------------------------------------
# value_to_i_estimate

{
  my $seq = Math::NumSeq::Multiples->new (multiples => 10);
  ok ($seq->value_to_i_estimate(30), 3);
}

{
  my $seq = Math::NumSeq::Multiples->new (multiples => 0);
  my $i = $seq->value_to_i_estimate(123);
  require POSIX;
  ok ($i >= POSIX::DBL_MAX(), 1);
}

exit 0;


