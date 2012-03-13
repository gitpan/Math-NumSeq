# Copyright 2010, 2011, 2012 Kevin Ryde

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

package Math::NumSeq::Squares;
use 5.004;
use strict;
use POSIX 'ceil';
use List::Util 'max';

use vars '$VERSION','@ISA';
$VERSION = 36;

use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name =>  Math::NumSeq::__('Perfect Squares');
use constant description => Math::NumSeq::__('The squares 1,4,9,16,25, etc k*k.');
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;
use constant i_start => 0;
use constant values_min => 0;
use constant oeis_anum => 'A000290'; # squares

sub rewind {
  my ($self) = @_;
  $self->{'i'} = ceil (sqrt (max(0,$self->{'lo'})));
}
sub next {
  my ($self) = @_;
  ### Squares next(): $self->{'i'}
  my $i = $self->{'i'}++;
  return ($i, $i*$i);
}
sub pred {
  my ($self, $value) = @_;
  ### Squares pred(): $value

  if ($value < 0) { return 0; }

  my $int = int($value);
  if ($value != $int) { return 0; }

  my $sqrt = int(sqrt($int));
  return ($int == $sqrt*$sqrt);
}
sub ith {
  my ($self, $i) = @_;
  return $i*$i;
}

sub value_to_i_floor {
  my ($self, $value) = @_;
  if ($value < 0) { $value = 0; }
  return int(sqrt(int($value)));
}
*value_to_i_estimate = \&value_to_i_floor;

1;
__END__

=for stopwords Ryde Math-NumSeq ie

=head1 NAME

Math::NumSeq::Squares -- perfect squares

=head1 SYNOPSIS

 use Math::NumSeq::Squares;
 my $seq = Math::NumSeq::Squares->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of squares, 0, 1, 4, 9, 16, 25, etc.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::Squares-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i * $i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a square, ie. k*k for some integer k.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Cubes>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2010, 2011, 2012 Kevin Ryde

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
