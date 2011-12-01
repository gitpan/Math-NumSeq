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
plan tests => 635;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

use Math::NumSeq::SqrtEngel;

# uncomment this to run the ### lines
#use Smart::Comments;


#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 20;
  ok ($Math::NumSeq::SqrtEngel::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::SqrtEngel->VERSION,  $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::SqrtEngel->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::SqrtEngel->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# i_start, parameters

{
  my $seq = Math::NumSeq::SqrtEngel->new;
  ok ($seq->i_start, 1, 'i_start()');

  my @pnames = map {$_->{'name'}} $seq->parameter_info_list;
  ok (join(',',@pnames),
      'sqrt');
}


#------------------------------------------------------------------------------
# values

{
  foreach my $sqrt (2 .. 20) {
    my $seq = Math::NumSeq::SqrtEngel->new (sqrt => $sqrt);

    my $num = Math::NumSeq::_bigint()->new(0);
    my $den = Math::NumSeq::_bigint()->new(1);
    my $want_i = 1;
    my $prev_value = 0;

    foreach (1 .. 10) {
      my ($i, $value) = $seq->next
        or do {
          ok ($den == 1);
          ok ($num*$num == $sqrt);
          last;
        };

      ok ($i, $want_i);
      $want_i++;

      ok ($value >= $prev_value);

      if ($value > 1) {
        my $above_num = $num * ($value-1) + 1;
        my $above_den = $den * ($value-1);
        ### num: "$above_num"
        ### den: "$above_den"

        # n/d > sqrt(s)
        # n^2 > s*d^2
        ok ($above_num * $above_num >= $above_den * $above_den * $sqrt,
            1,
            'value-1 would be > sqrt');
      }

      # n/d + 1/dv = (nv+1)/dv
      #
      $num = $num * $value + 1;
      $den = $den * $value;
      ### value: "$value"
      ### num: "$num"
      ### den: "$den"


      # n/d < sqrt(s)
      # n^2 < s*d^2
      ok ($num * $num <= $den * $den * $sqrt,
          1,
          "total < sqrt($sqrt)   at num=$num den=$den");
    }
  }
}

exit 0;
