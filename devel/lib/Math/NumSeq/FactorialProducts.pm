# Copyright 2012 Kevin Ryde

# This file is part of Math-NumSeq.
#
# Math-NumSeq is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 3, or (at your option) any later
# version.
#
# Math-NumSeq is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.


# SB RationalsTree straight lines

package Math::NumSeq::FactorialProducts;
use 5.004;
use strict;
use Math::Prime::XS 0.23 'is_prime'; # version 0.23 fix for 1928099

use vars '$VERSION', '@ISA';
$VERSION = 53;

use Math::NumSeq;
use Math::NumSeq::Base::IteratePred;
@ISA = ('Math::NumSeq',
        'Math::NumSeq::Base::IteratePred');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Primes;
use Math::NumSeq::Squares;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
use constant description => Math::NumSeq::__('...');
use constant default_i_start => 1;
use constant characteristic_integer => 1;
use constant values_min => 1;

#------------------------------------------------------------------------------
# cf A046523 least with same prime sig as n
#    A115746 products of p! for any prime p, excluding 1
#
use constant oeis_anum => 'A001013';   # p!
# use constant oeis_anum => 'A115746';  # n!


#------------------------------------------------------------------------------

sub pred {
  my ($self, $value) = @_;
  ### FactorialProducts pred(): "$value"

  if (_is_infinite($value)) {
    return undef;
  }
  if ($value != int($value)) {
    return 0;
  }
  if ($value < 2) {
    return ($value == 1);
    return 0;
  }

  my (@value,@limit);
  my $limit = 2**64; # infinity
  my $f = 1;
  for (;;) {
    $f++;
    if ($f > $limit || $value % $f) {
      ### backtrack ...
      if (@value) {
        $f = 1;
        $value = pop @value;
        $limit = pop @limit;
      } else {
        return 0;
      }
    } else {
      $value /= $f;
      if ($value <= 1) {
        return 1;
      }

        push @value, $value;
        push @limit, $f;
      if (is_prime($f)) {
      }
    }
  }
}

1;
__END__
