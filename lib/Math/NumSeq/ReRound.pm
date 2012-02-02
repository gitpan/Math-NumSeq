# Copyright 2011, 2012 Kevin Ryde

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

package Math::NumSeq::ReRound;
use 5.004;
use strict;
use POSIX 'ceil';
use List::Util 'max';

use vars '$VERSION','@ISA';
$VERSION = 32;

use Math::NumSeq 7; # v.7 for _is_infinite()
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;

use constant description => Math::NumSeq::__('...');
use constant values_min => 1; # at i=1
use constant i_start => 1;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;

use constant parameter_info_array =>
  [
   { name    => 'extra_multiples',
     display => Math::NumSeq::__('Extra Multiples'),
     type    => 'integer',
     default => '0',
     minimum => 0,
     width   => 2,
     # description => Math::NumSeq::__('...'),
   },
  ];

# cf A000959 lucky numbers 1, 3, 7, 9, 13, 15, 21, ... delete multiples of the next remaining
#    A145649 characteristic of lucky numbers
#    A050505 lucky complement, unlucky
#    A007952 sieve+1
#    A099361 sieve by primes
#    A099204 sieve by primes
#    A099207 sieve by primes
#    A099243 sieve by primes
#    A002960 square sieve
#
#    A056533 sieve evens, every 2nd, 3rd, etc
#    A039672 sieve fibonacci style i+j prev terms
#    A056530 Flavius Josephus after 2nd round
#    A056531 Flavius Josephus after 4th round
#    A119446 cf A100461
#
#    A113749 k multiples
#
my @oeis_anum
  = (
     # OEIS-Catalogue array begin
     'A002491',   #                     # Mancala stones
     'A000960',   # extra_multiples=1   # Flavius Josephus
     'A112557',   # extra_multiples=2   # more Mancala stones ...
     'A112558',   # extra_multiples=3   # more Mancala stones ...
     'A113742',   # extra_multiples=4   # more Mancala stones ...
     'A113743',   # extra_multiples=5   # more Mancala stones ...
     'A113744',   # extra_multiples=6   # more Mancala stones ...
     'A113745',   # extra_multiples=7   # more Mancala stones ...
     'A113746',   # extra_multiples=8   # more Mancala stones ...
     'A113747',   # extra_multiples=9   # more Mancala stones ...
     'A113748',   # extra_multiples=10  # more Mancala stones ...
     # OEIS-Catalogue array end
    );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'extra_multiples'}];
}

sub ith {
  my ($self, $i) = @_;
  ### ReRound ith(): $i

  if (_is_infinite($i)) {
    return $i;  # don't loop forever if $i is +infinity
  }

  my $extra_multiples = $self->{'extra_multiples'};
  ### $extra_multiples

  for (my $m = $i-1; $m >= 1; $m--) {
    ### add: (-$i % $m) + $extra_multiples*$m

    $i += (-$i % $m) + $extra_multiples*$m;
  }
  return $i;
}

# 1,3,7,13,19
# 2->2+1=3
# 3->4+2=6->6+1=7
# 4->6+m3=9->10+m2=12->12+m1=13
#
# next = prev + (-prev mod m) + k*m
# next-k*m = prev + (-prev mod m)

sub pred {
  my ($self, $value) = @_;
  ### ReRound pred(): $value

  my $extra_multiples = $self->{'extra_multiples'};

  if (_is_infinite($value)) {
    return undef;
  }
  if ($value <= 1 || $value != int($value)) {
    return ($value == 1);
  }

  # special case m=1 stepping down to an even number
  if (($value -= $extra_multiples) % 2) {
    return 0;
  }

  my $m = 2;
  while ($value > $m) {
    ### at: "value=$value  m=$m"

    if (($value -= $extra_multiples*$m) <= 0) {
      ### no, negative: $value
      return 0;
    }
    ### subtract to: "value=$value"

    ### rem: "modulus=".($m+1)." rem ".($value%($m+1))
    my $rem;
    if (($rem = ($value % ($m+1))) == $m) {
      ### no, remainder: "rem=$rem  modulus=".($m+1)
      return 0;
    }

    $value -= $rem;
    $m++;
  }

  ### final ...
  ### $value
  ### $m

  return ($value == $m);
}

# v1.02 for leading underscore
use constant 1.02 _PI => 4*atan2(1,1); # similar to Math::Complex pi()

sub value_to_i_estimate {
  my ($self, $value) = @_;
  if ($value < 0) { return 0; }
  return int(sqrt($value * _PI));
}

1;
__END__

=for stopwords Ryde

=head1 NAME

Math::NumSeq::ReRound -- sequence from repeated rounding up

=head1 SYNOPSIS

 use Math::NumSeq::ReRound;
 my $seq = Math::NumSeq::ReRound->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is the sequence of values formed by repeatedly rounding up to a
multiple of i-1,i-2,...,2,1.

    1, 2, 4, 6, 10, 12,

For example i=5 is rounded up to a multiple of 4 to give 8, then rounded up
to a multiple of 3 to give 9, then rounded up to a multiple of 2 for value
10 at i=5.

When rounding up if a value is already a suitable multiple then it's
unchanged.  For example i=4 round up to a multiple of 3 to give 6, then 6
round up to a multiple of 2 is 6 unchanged since it's already a multiple
of 2.

For iE<gt>2 the last step rounds up to a multiple of 2 so the values are all
even.  They're also always increasing and end up approximately

    value ~= i^2 / pi

though there's values both bigger and smaller than this approximation.

=head2 Extra Multiples

The C<extra_multiples> option can round up at each step to an extra
multiple.  For example C<extra_multiples E<gt>= 2> changes i=5 to round up
to a multiple of 4 and then step by 2 further multiples of 4, similarly for
round up to 3 and 2 further multiples, etc.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::ReRound-E<gt>new ()>

=item C<$seq = Math::NumSeq::ReRound-E<gt>new (extra_multiples =E<gt> $integer)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i> rounded up to multiples of i-1,...,2.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a ReRound value.

=back

=head1 FORMULAS

=head2 Predicate

The rounding procedure can be reversed to test for a ReRound value.

    for i=2,3,4,etc
      remainder = value mod i
      if remainder==i-1 then not a ReRound
      otherwise
      value -= remainder    # round down to multiple of i
    stop when value <= i
    is a ReRound if value==i (and i is its index)

For example to test 28, it's a multiple of 2, so ok for the final rounding.
It's predecessor in the rounding steps was a multiple of 3, so round down to
a multiple of 3 which is 27.  The predecessor of 27 was a multiple of 4 so
round down to 24.  But at that point there's a contradiction because if 24
was the value then it's already a multiple of 3 and so wouldn't have gone up
to 27.  This case where a round-down gives a multiple of both i and i-1 is
identified by the remainder value % i == i-1, since the value is already a
multiple of i-1 and subtracting an i-1 would leave it still so.

=head1 SEE ALSO

L<Math::NumSeq>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011, 2012 Kevin Ryde

Math-NumSeq is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

Math-NumSeq is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
Math-NumSeq.  If not, see <http://www.gnu.org/licenses/>.

=cut
