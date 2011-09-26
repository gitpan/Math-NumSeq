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

package Math::NumSeq::StarNumbers;
use 5.004;
use strict;
use POSIX 'ceil';
use List::Util 'max';

use vars '$VERSION','@ISA';
$VERSION = 6;

use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Star Numbers');
use constant description =>  Math::NumSeq::__('The star numbers 1, 13, 37, 73, 121, etc, 6*n*(n-1)+1, also called the centred 12-gonals.');
use constant characteristic_monotonic => 2;
use constant values_min => 1;

# cf
# A006060 - which are also triangular numbers
#     A068774 - indices of the triangulars
#     A068775 - indices of the stars
# A006061 - which are also perfect squares
#     A054320 - indices of the squares
#     A068778 - indices of the stars
#

# centered polygonal numbers (k*n^2-k*n+2)/2, for k = 3 through 14 sides:
# A005448 , A001844 , A005891 , A003215 , A069099 , A016754 , A060544 ,
# A062786 , A069125 , A003154 , A069126 , A069127
#
# centered polygonal numbers (k*n^2-k*n+2)/2, for k = 15 through 20 sides:
# A069128 , A069129 , A069130 , A069131 , A069132 , A069133
#
use constant oeis_anum => 'A003154'; # star numbers

sub rewind {
  my ($self) = @_;
  $self->{'i'} = ceil(_inverse(max(1,$self->{'lo'})));
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, $self->ith($i));
}
sub ith {
  my ($class_or_self, $i) = @_;
  return 6*$i*($i-1)+1;
}
sub pred {
  my ($class_or_self, $value) = @_;
  if ($value < 0) { return 0; }
  # FIXME: the _inverse() +3 etc might be lost to rounding for very big $value
  my $i = _inverse($value);
  return ($i == int($i));
}

# i = 1/2 + sqrt(1/6 * $n + 1/12)
#   = (3 + sqrt(6 * $n + 3)) / 6

sub _inverse {
  my ($value) = @_;
  return (sqrt(6*$value + 3) + 3) / 6;
}

1;
__END__

=for stopwords Ryde Math-NumSeq 12-gonals

=head1 NAME

Math::NumSeq::StarNumbers -- star numbers 6*i*(i-1)+1

=head1 SYNOPSIS

 use Math::NumSeq::StarNumbers;
 my $seq = Math::NumSeq::Squares->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of star numbers 1, 13, 37, 73, 121, etc, 6*i*(i-1)+1, also
called the centred 12-gonals.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::StarNumbers-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<6*$i*($i-1)+1>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is of the form 6*i*(i-1)+1 for some i.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Polygonal>

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
