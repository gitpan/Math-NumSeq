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

package Math::NumSeq::PisanoPeriod;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 50;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
# use constant description => Math::NumSeq::__('S(i) = abs(S(i-1) - S(i-2) - S(i-3))');
use constant i_start => 2;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;
use constant characteristic_count => 1;

use constant values_min => 3;

use constant oeis_anum => 'A001175';

sub ith {
  my ($self, $i) = @_;
  ### PisanoPeriod ith(): $i
  if ($i < 2) {
    return undef;
  }
  if (_is_infinite($i)) {
    return $i;
  }

  my $past_f0 = 1;
  my $past_f1 = 1;
  my $f0 = 1;
  my $f1 = 1;
  for (;;) {
    if ($f0 == $past_f0 && $f1 == $past_f1) {
      last;
    }
    ($past_f0,$past_f1) = ($past_f1, ($past_f0+$past_f1) % $i);

    $f0 += $f1;
    $f1 += $f0;
    $f0 %= $i;
    $f1 %= $i;
  }

  my $pos = 1;
  for (;;) {
    ($f0,$f1) = ($f1, ($f0+$f1) % $i);
    if ($f0 == $past_f0 && $f1 == $past_f1) {
      return $pos;
    }
    $pos++;
  }
}

1;
__END__
