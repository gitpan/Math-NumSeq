# Copyright 2013 Kevin Ryde

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


package Math::NumSeq::FibonacciRepresentations;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 64;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq',
        'Math::NumSeq::Base::IterateIth');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Base::Cache
  'cache_hash';

# uncomment this to run the ### lines
# use Smart::Comments;


use constant name => Math::NumSeq::__('Fibonacci Representations');
use constant description => Math::NumSeq::__('Number of ways i can be expressed as a sum of Fibonacci numbers, without duplication.');
use constant default_i_start => 0;
use constant characteristic_count => 1;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;
use constant values_min => 1;

#------------------------------------------------------------------------------

use constant oeis_anum => 'A000119';


#------------------------------------------------------------------------------

sub ith {
  my ($self, $i) = @_;
  ### FibonacciRepresentations ith(): "$i"

  if (_is_infinite($i)) {
    return undef;
  }
  if ($i < 3) {
    return 1;
  }

  my $zero = $i * 0;
  my @fib = (1+$zero, 2+$zero);
  while ($i - $fib[-1] >= $fib[-2]) {
    push @fib, $fib[-1] + $fib[-2];
  }
  ### fibs: join(',',@fib)

  my $count = 0;
  my @i = ($i);
  while (my $fib = pop @fib) {
    ### at: "fib=$fib  i list=".join(',',@i)

    my @new;
    foreach my $i (@i) {
      if ($i < $fib) {
        push @new, $i;
      } elsif ($i == $fib) {
        push @new, $i;
        $count++;
      } else {
        push @new, $i, $i - $fib;
      }
    }
    ### new: join(',',@new)
    @i = @new;
  }

  ### final i's: join(',',@i)
  ### $count
  return $count + scalar(grep {$_==0} @i);
}

sub pred {
  my ($self, $value) = @_;
  return ($value >= 1 && $value == int($value));
}

1;
__END__
