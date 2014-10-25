#!/usr/bin/perl -w

# Copyright 2012, 2013 Kevin Ryde

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

use Math::NumSeq::Triangular;

my $test_count = (tests => 33)[1];
plan tests => $test_count;


#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 62;
  ok ($Math::NumSeq::Triangular::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::Triangular->VERSION,  $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::Triangular->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::Triangular->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# characteristic(), i_start(), parameters

{
  my $seq = Math::NumSeq::Triangular->new;
  ok ($seq->characteristic('increasing'), 1, 'characteristic(increasing)');
  ok ($seq->characteristic('integer'),    1, 'characteristic(integer)');
  ok (! $seq->characteristic('smaller'),  1, 'characteristic(smaller)');
  ok ($seq->i_start, 0, 'i_start()');

  my @pnames = map {$_->{'name'}} $seq->parameter_info_list;
  ok (join(',',@pnames),
      '');
}


#------------------------------------------------------------------------------
# value_to_i_floor()

{
  my $seq = Math::NumSeq::Triangular->new;
  ok ($seq->value_to_i_floor(0), 0);
  ok ($seq->value_to_i_floor(0.5), 0);
  ok ($seq->value_to_i_floor(1), 1);
  ok ($seq->value_to_i_floor(1.5), 1);

  ok ($seq->value_to_i_floor(2.5), 1);
  ok ($seq->value_to_i_floor(3), 2);
  ok ($seq->value_to_i_floor(3.5), 2);

  ok ($seq->value_to_i_floor(27.5), 6);
  ok ($seq->value_to_i_floor(28), 7);
  ok ($seq->value_to_i_floor(28.5), 7);

  ok ($seq->value_to_i_floor(-0.5), 0);
  ok ($seq->value_to_i_floor(-100), 0);
}

#------------------------------------------------------------------------------
# value_to_i_ceil()

{
  my $seq = Math::NumSeq::Triangular->new;
  ok ($seq->value_to_i_ceil(0), 0);
  ok ($seq->value_to_i_ceil(0.5), 1);
  ok ($seq->value_to_i_ceil(1), 1);
  ok ($seq->value_to_i_ceil(1.5), 2);

  ok ($seq->value_to_i_ceil(2.5), 2);
  ok ($seq->value_to_i_ceil(3), 2);
  ok ($seq->value_to_i_ceil(3.5), 3);

  ok ($seq->value_to_i_ceil(27.5), 7);
  ok ($seq->value_to_i_ceil(28), 7);
  ok ($seq->value_to_i_ceil(28.5), 8);

  ok ($seq->value_to_i_ceil(-0.5), 0);
  ok ($seq->value_to_i_ceil(-100), 0);
}

#------------------------------------------------------------------------------
# seek_to_value()

# {
#   my $seq = Math::NumSeq::Triangular->new;
#   {
#     $seq->seek_to_value(-123);
#     my ($i, $value) = $seq->next;
#     ok ($i, 0);
#     ok ($value, 0);
#   }
#   {
#     $seq->seek_to_value(0);
#     my ($i, $value) = $seq->next;
#     ok ($i, 0);
#     ok ($value, 0);
#   }
#   {
#     $seq->seek_to_value(0.5);
#     my ($i, $value) = $seq->next;
#     ok ($i, 1);
#     ok ($value, 1);
#   }
#   {
#     $seq->seek_to_value(1);
#     my ($i, $value) = $seq->next;
#     ok ($i, 1);
#     ok ($value, 1);
#   }
#   {
#     $seq->seek_to_value(1.5);
#     my ($i, $value) = $seq->next;
#     ok ($i, 2);
#     ok ($value, 4);
#   }
#   {
#     $seq->seek_to_value(3);
#     my ($i, $value) = $seq->next;
#     ok ($i, 2);
#     ok ($value, 4);
#   }
#   {
#     $seq->seek_to_value(28);
#     my ($i, $value) = $seq->next;
#     ok ($i, 7);
#     ok ($value, 7);
#   }
# }

exit 0;


