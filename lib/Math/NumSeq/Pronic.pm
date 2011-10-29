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

package Math::NumSeq::Pronic;
use 5.004;
use strict;
use POSIX 'ceil';
use List::Util 'max';

use vars '$VERSION','@ISA';
$VERSION = 14;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Pronic Numbers');
use constant description => Math::NumSeq::__('The pronic numbers 0, 2, 6, 12, 20, 30, etc, etc, i*(i+1).  These are twice the triangular numbers, and half way between perfect squares.');
use constant characteristic_monotonic => 2;
use constant values_min => 0; # at i=0
use constant oeis_anum => 'A002378'; # pronic, starting from 0

sub rewind {
  my ($self) = @_;
  $self->{'i'} = ceil(_inverse(max(0,$self->{'lo'})));
}
sub pred {
  my ($self, $value) = @_;
  if ($value < 0) { return 0; }
  my $i = _inverse($value);
  return ($i == int($i));
}
sub ith {
  my ($self, $i) = @_;
  return $i*($i+1);
}

sub _inverse {
  my ($value) = @_;
  return sqrt($value + .25) - .5;
}

1;
__END__

=for stopwords Ryde Math-NumSeq pronic ie

=head1 NAME

Math::NumSeq::Pronic -- pronic numbers

=head1 SYNOPSIS

 use Math::NumSeq::Pronic;
 my $seq = Math::NumSeq::Pronic->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of pronic numbers 2, 6, 12, 20, 30, etc, i*(i+1).  These are
twice the triangular numbers, and half way between perfect squares.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Pronic-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i*($i+1)>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a pronic number, ie. i*(i+1) for some i.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Squares>,
L<Math::NumSeq::Triangular>

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
