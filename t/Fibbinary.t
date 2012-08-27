#!/usr/bin/perl -w

# Copyright 2011, 2012 Kevin Ryde

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
plan tests => 12;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

use Math::NumSeq::Fibbinary;

# uncomment this to run the ### lines
#use Smart::Comments;


#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 50;
  ok ($Math::NumSeq::Fibbinary::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::Fibbinary->VERSION,  $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::Fibbinary->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::Fibbinary->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# characteristic()

{
  my $seq = Math::NumSeq::Fibbinary->new;
  ok ($seq->characteristic('integer'), 1, 'characteristic(integer)');
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

  {
    my $nv = 17 * 2**256;
    ok ($seq->pred($nv), 1,
        '17*2**256 float -> bigint');
    MyTestHelpers::diag ("nv is ",$nv);
    MyTestHelpers::diag ("~0 is ",~0);
    my $str = sprintf('%.0f',$nv);
    MyTestHelpers::diag ("sprintf is ",$str);
    my $big = Math::NumSeq::_to_bigint($str);
    MyTestHelpers::diag ("_to_bigint(nv) is ",$big);
    MyTestHelpers::diag ("big & (big>>1) is ",$big & ($big>>1));
  }
}

#------------------------------------------------------------------------------
# value_to_i_floor()

{
  my $bad = 0;
  my $seq = Math::NumSeq::Fibbinary->new;
  my ($i, $value) = $seq->next;
 OUTER: foreach (1 .. 50) {
    my ($next_i, $next_value) = $seq->next;
    foreach my $try_value ($value .. $next_value-1) {
      my $got_i = $seq->value_to_i_floor($try_value);
      if ($i != $got_i) {
        MyTestHelpers::diag ("value_to_i_floor($try_value) got $got_i want $i");
        last OUTER if $bad++ > 20;
      }
    }
    $i = $next_i;
    $value = $next_value;
  }
  ok ($bad, 0, 'value_to_i_floor()');
}


exit 0;


