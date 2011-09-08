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

package Math::NumSeq::Beastly;
use 5.004;
use strict;
use List::Util 'max';

use vars '$VERSION', '@ISA';
$VERSION = 4;

use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Beastly Numbers');
use constant description => Math::NumSeq::__('Numbers which contain "666".  The default is decimal, or select a radix.');
use constant values_min => 666;
use constant characteristic_monotonic => 1;

use Math::NumSeq::Base::Digits;
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;


# cf A131645 the beastly primes
sub oeis_anum {
  my ($class_or_self) = @_;
  my $radix = (ref $class_or_self
               ? $class_or_self->{'radix'}
               : $class_or_self->parameter_default('radix'));
  return ($radix == 10
          ? 'A051003'
          : undef);
}
# OEIS-Catalogue: A051003 radix=10

sub rewind {
  my ($self) = @_;
  my $lo = $self->{'lo'};

  my $radix = $self->{'radix'};

  $self->{'i'}      = 0;
  $self->{'target'} = (6*$radix+6)*$radix+6;
  $self->{'cube'}   = $radix*$radix*$radix;
  $self->{'value'}  = max($lo,$self->{'target'}) - 1;
}
sub next {
  my ($self) = @_;
  if ($self->{'radix'} < 7) {
    return;
  }
  my $value = $self->{'value'};
  for (;;) {
    if ($self->pred(++$value)) {
      return ($self->{'i'}++, ($self->{'value'} = $value));
    }
  }
}

sub pred {
  my ($self, $value) = @_;
  my $radix = $self->{'radix'};
  if ($radix < 7) {
    return 0;
  }
  if ($radix == 10) {
    return ($value =~ /666/);
  }

  my $cube = $self->{'cube'};      # radix^3
  my $target = $self->{'target'};  # 666 in radix
  for (;;) {
    if (($value % $cube) == $target) {
      return 1;
    }
    if ($value < $cube) {
      return 0;
    }
    $value = int($value/$radix);
  }
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Beastly -- numbers containing digits "666" 

=head1 SYNOPSIS

 use Math::NumSeq::Beastly;
 my $seq = Math::NumSeq::Beastly->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This sequence is the beastly numbers, meaning those with "666" somewhere in
their digits.  The default is decimal digits, or a radix can be given.

    666, 1666, 2666, 3666, 4666, 5666,
    6660, 6661, 6662, ..., 6669,
    7666, 8666, 9666,
    etc

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Beastly-E<gt>new ()>

=item C<$seq = Math::NumSeq::Beastly-E<gt>new (radix =E<gt> 16)>

Create and return a new sequence object.

An optional C<radix> parameter selects a base other than decimal.  If
C<radix> is 6 or less then there's no "6" digits at all and the sequence has
no values.

=item C<$bool = $seq-E<gt>pred ($value)>

Return true if C<$value> has "666" in its digits.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Repdigits>

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
