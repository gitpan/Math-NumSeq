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

package Math::NumSeq::Pell;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 10;
use Math::NumSeq::Base::Sparse;
@ISA = ('Math::NumSeq::Base::Sparse');

use Math::NumSeq 7; # v.7 for _is_infinite()
*_is_infinite = \&Math::NumSeq::_is_infinite;


# use constant name => Math::NumSeq::__('Pell Numbers');
use constant description => Math::NumSeq::__('The Pell numbers 0, 1, 2, 5, 12, 29, 70, etc, being P(k)=2*P(k-1)+P(k-2) starting from 0,1.');
use constant values_min => 0;
use constant characteristic_monotonic => 2; # strictly
use constant oeis_anum => 'A000129'; # pell

# uncomment this to run the ### lines
#use Smart::Comments;

sub rewind {
  my ($self) = @_;
  ### Pell rewind() ...
  $self->{'i'} = 0;
  $self->{'f0'} = 0;
  $self->{'f1'} = 1;
}
sub next {
  my ($self) = @_;
  (my $ret,
   $self->{'f0'},
   $self->{'f1'})
   = ($self->{'f0'},
      $self->{'f1'},
      $self->{'f0'} + 2*$self->{'f1'});
  return ($self->{'i'}++, $ret);
}

sub ith {
  my ($self, $i) = @_;
  ### ith(): $i
  if (_is_infinite($i)) {
    return $i;
  }

  # ENHANCE-ME: use one of the powering algorithms
  my $f0 = ($i&0);  # inherit bignum 0
  my $f1 = $f0 + 1; # inherit bignum 1
  while ($i-- > 0) {
    ### at: "i=$i   $f0, $f1"
    ($f0,$f1) = ($f1, $f0 + 2*$f1);
  }
  return $f0;
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Pell -- Pell numbers

=head1 SYNOPSIS

 use Math::NumSeq::Pell;
 my $seq = Math::NumSeq::Pell->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Pell numbers 0,1,2,5,12,29,70,etc, where P(k)=2*P(k-1)+P(k-2), starting
from 0,1.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Pell-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th Pell number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Pell number.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>,
L<Math::NumSeq::LucasNumbers>

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
