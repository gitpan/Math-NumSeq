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

use Math::NumSeq::ReverseAdd;

my $test_count = (tests => 9)[1];
plan tests => $test_count;


#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 29;
  ok ($Math::NumSeq::ReverseAdd::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::ReverseAdd->VERSION,  $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::ReverseAdd->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::ReverseAdd->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# characteristic(), i_start(), parameters

{
  my $seq = Math::NumSeq::ReverseAdd->new;
  ok ($seq->characteristic('increasing'), 1, 'characteristic(increasing)');
  ok ($seq->characteristic('integer'),    1, 'characteristic(integer)');
  ok ($seq->i_start, 0, 'i_start()');

  my @pnames = map {$_->{'name'}} $seq->parameter_info_list;
  ok (join(',',@pnames),
      'start,radix');
}


#------------------------------------------------------------------------------
# _reverse_in_radix()

{
  my $n = Math::NumSeq::_bigint()->new("3377699871522813");
  my $rev = Math::NumSeq::ReverseAdd::_reverse_in_radix($n,2);
  my $revstr = "$rev";
  ok ($revstr, "3377699468869635");
}

exit 0;


