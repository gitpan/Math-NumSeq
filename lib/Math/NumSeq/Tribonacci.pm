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

package Math::NumSeq::Tribonacci;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 27;
use Math::NumSeq::Base::Sparse;
@ISA = ('Math::NumSeq::Base::Sparse');


# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Tribonacci Numbers');
use constant description => Math::NumSeq::__('Tribonacci numbers 0, 0, 1, 1, 2, 4, 7, 13, 24, being T(i) = T(i-1) + T(i-2) + T(i-3) starting from 0,0,1.');
use constant characteristic_non_decreasing => 1;
use constant characteristic_increasing_from_i => 3;
use constant characteristic_integer => 1;
use constant values_min => 0;
use constant i_start => 0;
use constant oeis_anum => 'A000073'; # tribonacci

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'f0'} = 0;
  $self->{'f1'} = 0;
  $self->{'f2'} = 1;
}
sub next {
  my ($self) = @_;
  ### Tribonacci next(): "$self->{'f0'} $self->{'f1'} $self->{'f2'}"
  (my $ret,
   $self->{'f0'},
   $self->{'f1'},
   $self->{'f2'})
   = ($self->{'f0'},
      $self->{'f1'},
      $self->{'f2'},
      $self->{'f0'}+$self->{'f1'}+$self->{'f2'});
  return ($self->{'i'}++, $ret);
}

1;
__END__

=for stopwords Ryde Math-NumSeq Tribonacci

=head1 NAME

Math::NumSeq::Tribonacci -- Tribonacci numbers

=head1 SYNOPSIS

 use Math::NumSeq::Tribonacci;
 my $seq = Math::NumSeq::Tribonacci->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Tribonacci sequence 0, 0, 1, 1, 2, 4, 7, 13, etc,

    T(i) = T(i-1) + T(i-2) + T(i-3)

starting from 0,0,1.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Tribonacci-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th Tribonacci number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Tribonacci number.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>

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
