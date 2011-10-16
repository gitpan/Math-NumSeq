# Copyright 2011 Kevin Ryde

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


package Math::NumSeq::DigitProduct;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 12;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use constant name => Math::NumSeq::__('Digit Product');
use constant description => Math::NumSeq::__('Product of digits a given radix.');
use constant characteristic_smaller => 1;
use constant characteristic_monotonic => 0;

use Math::NumSeq::Base::Digits;
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;

use constant values_min => 0;
sub values_max {
  my ($self) = @_;
  return ($self->{'radix'} == 2 ? 1 : undef);
}  

#------------------------------------------------------------------------------
# apparently no ternary or base 4 ...
# cf A036987 binary, but takes i=0 to be an empty product equal to 1

my @oeis_anum;

$oeis_anum[10] = 'A007954'; # 10 decimal, starting from 0
# OEIS-Catalogue: A007954 radix=10

sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'radix'}];
}

#------------------------------------------------------------------------------

sub ith {
  my ($self, $i) = @_;

  if (_is_infinite ($i)) {
    return $i;
  }
  my $radix = $self->{'radix'};
  my $product = ($i % $radix);  # low digit
  for (;;) {
    $i = int($i/$radix) || last;
    ($product *= ($i % $radix)) || last;
  }
  return $product;
}

sub pred {
  my ($self, $value) = @_;
  if (_is_infinite ($value)
      || $value < 0
      || $value != int($value)) {
    return 0;
  }
  my $radix = $self->{'radix'};
  for (my $i = 2; $i < $radix && $value > 1; $i++) {
    until ($value % $i) {
      $value /= $i;
    }
  }
  return ($value <= 1);  # remainder
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::DigitProduct -- product of digits

=head1 SYNOPSIS

 use Math::NumSeq::DigitProduct;
 my $seq = Math::NumSeq::DigitProduct->new (radix => 10);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The products of the digits of i, for example at i=456 the value is
4*5*6=120.  i=0 is treated as a single digit 0, so it's product is 0.

For binary (C<radix =E<gt> 2>) the digits are all just 0 or 1 which means
the product is 1 for numbers 0b1, 0b11, 0b111, etc, 2**k-1, or 0 otherwise.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::DigitProduct-E<gt>new ()>

=item C<$seq = Math::NumSeq::DigitProduct-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.  The default radix is 10,
ie. decimal, or a C<radix> parameter can be given.

=item C<$value = $seq-E<gt>ith($i)>

Return the product of the digits of C<$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is the product of some set of digits.  This means
its factors (prime factors) are all less than the radix, since anything
bigger cannot occur.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitLength>,
L<Math::NumSeq::DigitSum>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011 Kevin Ryde

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
