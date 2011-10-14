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

package Math::NumSeq::Fibonacci;
use 5.004;
use strict;
use Math::NumSeq;

use vars '$VERSION','@ISA';
$VERSION = 11;
use Math::NumSeq::Base::Sparse;
@ISA = ('Math::NumSeq::Base::Sparse');
use Math::NumSeq;
*_is_infinite = \&Math::NumSeq::_is_infinite;

# use constant name => Math::NumSeq::__('Fibonacci Numbers');
use constant description => Math::NumSeq::__('The Fibonacci numbers 1,1,2,3,5,8,13,21, etc, each F(i) = F(i-1) + F(i-2), starting from 1,1.');
use constant values_min => 0;
use constant characteristic_monotonic => 2;
use constant oeis_anum => 'A000045'; # fibonacci starting at 1,1

# uncomment this to run the ### lines
#use Devel::Comments;

sub rewind {
  my ($self) = @_;
  ### Fibonacci rewind()
  $self->{'f0'} = 0;
  $self->{'f1'} = 1;
  $self->{'i'} = $self->i_start;
}
sub next {
  my ($self) = @_;
  ### Fibonacci next(): "f0=$self->{'f0'}, f1=$self->{'f1'}"
  (my $ret, $self->{'f0'}, $self->{'f1'})
   = ($self->{'f0'}, $self->{'f1'}, $self->{'f0'}+$self->{'f1'});
  ### $ret
  return ($self->{'i'}++, $ret);
}

# powering ...
# sub ith {
#   my ($self, $i) = @_;
#   ### Fibonacci ith(): $i
#   my $x = 0;
#   my $y = 1;
#   if (_is_infinite($i)) {
#     return $i;
#   }
#   while ($i--) {
#     $x += $y;
#     return $x unless ($i--);
#     $y += $x;
#   }
#   return $y;
# }

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Fibonacci -- Fibonacci numbers

=head1 SYNOPSIS

 use Math::NumSeq::Fibonacci;
 my $seq = Math::NumSeq::Fibonacci->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Fibonacci sequence 1,1,2,3,5,8,13,21, etc, where F(n) = F(n-1) + F(n-2), starting from 1,1.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Fibonacci-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th Fibonacci number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Fibonacci number.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::LucasNumbers>,
L<Math::NumSeq::Fibbinary>
L<Math::NumSeq::Tribonacci>

L<Math::Fibonacci>

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
