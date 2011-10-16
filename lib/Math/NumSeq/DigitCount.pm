# Copyright 2010, 2011 Kevin Ryde

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

package Math::NumSeq::DigitCount;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 12;
use Math::NumSeq;
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Base::Digits;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq::Base::Digits');

# uncomment this to run the ### lines
#use Smart::Comments;

use constant description => Math::NumSeq::__('How many of a given digit in each number, in a given radix, for example how many 1 bits in binary.');
use constant values_min => 0;
use constant characteristic_count => 1;
use constant characteristic_monotonic => 0;
use constant parameter_info_array =>
  [
   Math::NumSeq::Base::Digits->parameter_info_list(),
   {
    name        => 'digit',
    type        => 'integer',
    share_key   => 'digit-1',
    display     => Math::NumSeq::__('Digit'),
    default     => -1,
    minimum     => -1,
    width       => 2,
    description => Math::NumSeq::__('Digit to count, default -1 means radix-1.'),
   },
  ];

# cf A008687 - count 1s in twos-complement -n
#
my @oeis_anum;
BEGIN {
  $oeis_anum[2]->[0] = 'A080791'; # base 2 count 0s, start i=0
  # OEIS-Catalogue: A080791 radix=2 digit=0
  # cf A023416 treating "0" as a single digit zero

  $oeis_anum[2]->[1] = 'A000120'; # base 2 count 1s, start i=0
  # OEIS-Catalogue: A000120 radix=2 digit=1

  ## $oeis_anum[3]->[0] = 'A077267'; # base 3 count 0s, start i=1
  ## # OEIS-Catalogue: A077267 radix=3 digit=0

  $oeis_anum[3]->[1] = 'A062756'; # base 3 count 1s, start i=0
  # OEIS-Catalogue: A062756 radix=3 digit=1

  $oeis_anum[3]->[2] = 'A081603'; # base 3 count 2s, start i=0
  # OEIS-Catalogue: A081603 radix=3 digit=2

  $oeis_anum[10]->[9] = 'A102683'; # base 10 count 9s, start i=0
  # OEIS-Catalogue: A102683 radix=10 digit=9
}
sub oeis_anum {
  my ($self) = @_;
  my $radix = $self->{'radix'};
  my $digit = $self->{'digit'};
  if ($digit == -1) {
    $digit = $radix-1;
  }
  return $oeis_anum[$radix]->[$digit];
}

sub ith {
  my ($self, $i) = @_;
  $i = abs($i);
  if (_is_infinite ($i)) {
    return $i;
  }

  my $radix = $self->{'radix'};
  my $digit = $self->{'digit'};
  if ($digit == -1) { $digit = $radix - 1; }

  my $count = 0;
  if ($radix == 2) {
    while ($i) {
      if (($i & 1) == $digit) {
        $count++;
      }
      $i >>= 1;
    }
  } else {
    while ($i) {
      if (($i % $radix) == $digit) {
        $count++;
      }
      $i = int($i/$radix);
    }
  }
  return $count;
}

sub pred {
  my ($self, $value) = @_;
  return ($value >= 0 && $value==int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::DigitCount -- count of a given digit

=head1 SYNOPSIS

 use Math::NumSeq::DigitCount;
 my $seq = Math::NumSeq::DigitCount->new (radix => 10,
                                          digit => 9);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The count of how many of a given digit is in C<$i> when written out in a
given radix.  The default is to count how many 9s in decimal.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::DigitCount-E<gt>new (radix =E<gt> $r, digit =E<gt> $d)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return how many of the given C<digit> is in C<$i> written in C<radix>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> might occur as value in the sequence, which means
simply C<$value>=0>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitLength>,
L<Math::NumSeq::RadixWithoutDigit>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2010, 2011 Kevin Ryde

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
