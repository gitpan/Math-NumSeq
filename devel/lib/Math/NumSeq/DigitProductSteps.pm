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


# http://www.inwap.com/pdp10/hbaker/hakmem/number.html#item56
#


package Math::NumSeq::DigitProductSteps;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 40;
use Math::NumSeq;
use List::Util 'reduce';
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::DigitProduct;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
use constant description => Math::NumSeq::__('Number of steps of the digit product until reaching a single digit.');
use constant i_start => 0;
use constant characteristic_count => 1;
use constant characteristic_integer => 1;

use Math::NumSeq::Base::Digits;   # radix
use constant parameter_info_array => 
  [
   Math::NumSeq::Base::Digits::parameter_common_radix(),
   {
    name => 'values_type',
      type    => 'enum',
      default => 'count',
      choices => ['count',
                  'root',
                 ],
      choices_display => [Math::NumSeq::__('Count'),
                          Math::NumSeq::__('Root'),
                         ],
      description => Math::NumSeq::__('The values, either steps count or the final value after the steps.'),
   } ];
use constant values_min => 0;

#------------------------------------------------------------------------------
# cf A046511 - numbers with persistence 2
#
#    A031348 - iterate product of squares of digits until 0,1
#    A031349 - iterate product of cubes of digits
#    A031350 -
#    A031351
#    A031352
#    A031353
#    A031354
#    A031355 -
#    A031356 - 10th powers of digits
#
#    A087471 - iterate product of alternate digits, final digit
#    A087472 - num steps
#    A087473 - first of n iterations
#    A087474 - triangle of values of those first taking n iterations
#
#    A031286 - additive persistence to single digit
#    A010888 - additive root single digit

my %oeis_anum;

$oeis_anum{'count'}->[10] = 'A031346';
# OEIS-Catalogue: A031346

$oeis_anum{'root'}->[10] = 'A031347';
# OEIS-Catalogue: A031347 values_type=root

sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'values_type'}}->[$self->{'radix'}];
}

#------------------------------------------------------------------------------

sub ith {
  my ($self, $i) = @_;
  ### ith(): $i

  if (_is_infinite($i)) {
    return $i;  # don't loop forever if $i is +infinity
  }

  my $radix = $self->{'radix'};
  my $count = 0;
  for (;;) {
    my @digits = _digit_split($i, $radix);
    if (@digits <= 1) {
      if ($self->{'values_type'} eq 'count') {
        return $count;
      } else {
        return $i;  # final root
      }
    }
    $i = reduce {$a*$b} @digits;
    $count++;
  }
}

sub _digit_split {
  my ($n, $radix) = @_;
  ### _digit_split(): $n
  my @ret;
  while ($n) {
    push @ret, $n % $radix;
    $n = int($n/$radix);
  }
  return @ret;   # low to high
}

1;
__END__

=for stopwords Ryde Math-NumSeq BigInt

=head1 NAME

Math::NumSeq::DigitProductSteps -- product of digits, multiplicative persistence and root

=head1 SYNOPSIS

 use Math::NumSeq::DigitProductSteps;
 my $seq = Math::NumSeq::DigitProductSteps->new ();
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

I<In progress ...>

This is an iteration of taking the product of digits repeated until reaching
a single digit value.  The default is the count of steps, which is also
called the multiplicative persistence.

    starting i=0
    0,0,..0,0,1,1,..1,1,2,2,2,2,2,1,1,1,1,2,2,2,2,2,3,1,1,1,2,...

For example i=39 goes 3*9=27, 2*7=14, 1*4=4 to reach a single digit, so
value=3 iterations.

The C<values_type =E<gt> 'root'> gives the final digit reached by the steps,
which is also called the multiplicative root.

    values_type => 'root'
    0,1,2,...,9,0,1,...,9,0,2,4,6,8,0,2,4,6,8,0,3,6,9,2,5,8,...

i=0 through i=9 are already single digits so their count is 0 and root is it
itself.  Then i=10 to i=19 all take just a single iteration to reach a
single digit.  i=25 is the first to require 2 iterations.

Any i with a 0 digit takes just one iteration and finishes with root 0.  Any
any i like 119111 which is all 1s except for at most one non-1 takes just
one iteration.

=head2 Radix

An optional C<radix> parameter selects a base other than decimal.

Binary C<radix=E<gt>2> is not very interesting since the digit product is
always either 0 or 1 so for iE<gt>=2 always just 1 iteration and root 0
except i=2^k-1 all 1s with root 1.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::DigitProductSteps-E<gt>new ()>

=item C<$seq = Math::NumSeq::DigitProductSteps-E<gt>new (values_type =E<gt> $str, radix =E<gt> $integer)>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>ith($value)>

Return the iteration result, either count or final root value as selected.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitProduct>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2012 Kevin Ryde

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
