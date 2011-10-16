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

package Math::NumSeq::DigitLength;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 12;
use Math::NumSeq::Base::Digits;
@ISA = ('Math::NumSeq::Base::Digits');

use Math::NumSeq;
*_is_infinite = \&Math::NumSeq::_is_infinite;


# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Digit Length');
use constant description => Math::NumSeq::__('How many digits the number requires in the given radix.  For example binary 1,1,2,2,3,3,3,3,4, etc.');
use constant values_min => 1;
use constant characteristic_count => 1;
use constant characteristic_monotonic => 1;

use Math::NumSeq::Base::Digits;
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;

# cf A000523 - floor(log2(n))
#    A036786 - roman numeral length <  decimal length
#    A036787 - roman numeral length == decimal length
#    A036788 - roman numeral length <= decimal length
#
my @oeis_anum;
BEGIN {
  $oeis_anum[2] = 'A070939';  # 2 binary
  # OEIS-Catalogue: A070939 radix=2

  $oeis_anum[3] = 'A081604';  # 3 ternary
  # OEIS-Catalogue: A081604 radix=3

  $oeis_anum[4] = 'A110591';  # 4
  # OEIS-Catalogue: A110591 radix=4

  $oeis_anum[5] = 'A110592';  # 5
  # OEIS-Catalogue: A110592 radix=5
}
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'radix'}];
}

sub rewind {
  my ($self) = @_;
  $self->{'i'} = 0;
  $self->{'length'} = 1;
  $self->{'limit'} = $self->{'radix'};
}
sub next {
  my ($self) = @_;
  ### DigitLength next(): $self
  ### count: $self->{'count'}
  ### bits: $self->{'bits'}

  my $i = $self->{'i'}++;
  if ($i >= $self->{'limit'}) {
    $self->{'limit'} *= $self->{'radix'};
    $self->{'length'}++;
    ### step to
    ### length: $self->{'length'}
    ### remaining: $self->{'limit'}
  }
  return ($i, $self->{'length'});
}

sub ith {
  my ($self, $i) = @_;
  if (_is_infinite($i)) {
    return $i;  # don't loop forever if $i is +infinity
  }
  my $length = 1;
  my $power = my $radix = $self->{'radix'};
  while ($i >= $power) {
    $length++;
    $power *= $radix;
  }
  return $length;
}

sub pred {
  my ($self, $value) = @_;
  return ($value >= 1 && $value == int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::DigitLength -- length in digits

=head1 SYNOPSIS

 use Math::NumSeq::DigitLength;
 my $seq = Math::NumSeq::DigitLength->new (radix => 10);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The length in digits of integers 0 upwards, so for example ternary
1,1,1,2,2,...,2,3,etc.  Zero is reckoned as length 1, a single digit 0.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::DigitLength-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return length in digits of C<$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value E<gt>= 1>, all lengths being 1 or more.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitLengthCumulative>,
L<Math::NumSeq::DigitCount>

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
