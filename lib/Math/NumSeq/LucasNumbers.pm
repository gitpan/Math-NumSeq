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

package Math::NumSeq::LucasNumbers;
use 5.004;
use strict;
use Math::NumSeq;

use vars '$VERSION','@ISA';
$VERSION = 8;

use Math::NumSeq::Fibonacci;
@ISA = ('Math::NumSeq::Fibonacci');

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Lucas Numbers');
use constant description => Math::NumSeq::__('Lucas numbers 1, 3, 4, 7, 11, 18, 29, etc, being L(i) = L(i-1) + L(i-2) starting from 1,3.  This is the same recurrence as the Fibonacci numbers, but a different starting point.');
use constant values_min => 1;
use constant characteristic_monotonic => 2;
use constant oeis_anum => 'A000204'; # lucas starting at 1,3,...
use constant i_start => 1;

sub rewind {
  my ($self) = @_;
  ### Lucas rewind()
  $self->SUPER::rewind;
  $self->{'f0'} = 1;
  $self->{'f1'} = 3;
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::LucasNumbers -- Lucas numbers

=head1 SYNOPSIS

 use Math::NumSeq::LucasNumbers;
 my $seq = Math::NumSeq::LucasNumbers->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Lucas numbers 1, 3, 4, 7, 11, 18, 29, etc, being L(i) = L(i-1) + L(i-2)
starting from 1,3.  This is the same recurrence as the Fibonacci numbers,
but a different starting point.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::LucasNumbers-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th Lucas number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Lucas number.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>

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
