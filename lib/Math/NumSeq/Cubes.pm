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

package Math::NumSeq::Cubes;
use 5.004;
use strict;
use Math::Libm 'cbrt';
use POSIX 'floor','ceil';
use List::Util 'max';

use vars '$VERSION', '@ISA';
$VERSION = 11;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Devel::Comments;

# use constant name => Math::NumSeq::__('Cubes');
use constant description => Math::NumSeq::__('The cubes 1, 8, 27, 64, 125, etc, k*k*k.');
use constant values_min => 0;
use constant characteristic_monotonic => 1;
use constant oeis_anum => 'A000578';

sub rewind {
  my ($self) = @_;
  $self->{'i'} = ceil (cbrt (max(0,$self->{'lo'})));
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, $i*$i*$i);
}
sub ith {
  my ($self, $i) = @_;
  return $i*$i*$i;
}

# This was a test for cbrt($n) being an integer, but found some amd64 glibc
# where cbrt(27) was not 3 but instead 3.00000000000000044.  Dunno if an
# exact integer can be expected from cbrt() on a cube, so instead try
# multiplying back the integer nearest cbrt().
#
# Multiplying back should also ensure that a floating point $n bigger than
# 2^53 won't look like a cube due to rounding.
#
sub pred {
  my ($self, $value) = @_;
  my $i = _cbrt_floor ($value);
  return ($i*$i*$i == $value);
}

sub _cbrt_floor {
  my ($x) = @_;
  if (ref $x) {
    if ($x->isa('Math::BigInt')) {
      return $x->copy->broot(3);
    }
    if ($x->isa('Math::BigRat') || $x->isa('Math::BigFloat')) {
      return $x->as_int->broot(3);
    }
  }
  return floor(cbrt($x));
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Cubes -- cubes i^3

=head1 SYNOPSIS

 use Math::NumSeq::Cubes;
 my $seq = Math::NumSeq::Cubes->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of cubes, 0, 1, 8, 27, 64, 125, etc, i**3.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Cubes-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i ** 3>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a cube.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Squares>

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
