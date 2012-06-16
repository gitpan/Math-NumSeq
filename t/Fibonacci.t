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
plan tests => 6;

use lib 't';
use MyTestHelpers;
MyTestHelpers::nowarnings();

use Math::NumSeq::Fibonacci;

# uncomment this to run the ### lines
#use Smart::Comments;

#------------------------------------------------------------------------------
# VERSION

{
  my $want_version = 43;
  ok ($Math::NumSeq::Fibonacci::VERSION, $want_version,
      'VERSION variable');
  ok (Math::NumSeq::Fibonacci->VERSION,  $want_version,
      'VERSION class method');

  ok (eval { Math::NumSeq::Fibonacci->VERSION($want_version); 1 },
      1,
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Math::NumSeq::Fibonacci->VERSION($check_version); 1 },
      1,
      "VERSION class check $check_version");
}


#------------------------------------------------------------------------------
# ith() automatic BigInt

{
  my $seq = Math::NumSeq::Fibonacci->new;
  my $value = $seq->ith(256);
  ok (ref $value && $value->isa('Math::BigInt'),
      1);
}

#------------------------------------------------------------------------------
# bigfloat nan

my $skip_bigfloat;

# Note: not "require Math::BigFloat" since it does tie-ins to BigInt in its
if (! eval "use Math::BigFloat; 1") {
  MyTestHelpers::diag ("Math::BigFloat not available -- ",$@);
  $skip_bigfloat = "Math::BigFloat not available";
}

if (! Math::BigFloat->can('bnan')) {
  MyTestHelpers::diag ("Math::BigFloat no bnan()");
  $skip_bigfloat = "Math::BigFloat no bnan()";
}

{
  my @nans;
  unless ($skip_bigfloat) {
    my $seq = Math::NumSeq::Fibonacci->new;

    my $nan = Math::BigFloat->bnan;
    my $inf = Math::BigFloat->bnan;
    my $neginf = Math::BigFloat->bnan('-');

    foreach my $f ($nan, $inf, $neginf) {
      my $value = $seq->ith($f);
      my $value_is_nan = (ref $value && $value->is_nan ? 1 : 0);
      push @nans, $value_is_nan;
    }
  }

  skip ($skip_bigfloat,
        join(',',@nans),
        '1,1,1',
        'ith() on BigFloat nan,inf,neginf should return big nan');
}

exit 0;


