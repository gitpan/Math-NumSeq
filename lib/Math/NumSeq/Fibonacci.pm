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
$VERSION = 21;
use Math::NumSeq::Base::Sparse;
@ISA = ('Math::NumSeq::Base::Sparse');

use Math::NumSeq;
*_bigint = \&Math::NumSeq::_bigint;
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Fibonacci Numbers');
use constant description => Math::NumSeq::__('The Fibonacci numbers 1,1,2,3,5,8,13,21, etc, each F(i) = F(i-1) + F(i-2), starting from 1,1.');

use constant values_min => 0;
use constant characteristic_monotonic => 2;
use constant oeis_anum => 'A000045'; # fibonacci starting at i=0 0,1,1,2,3

my $uv_limit = do {
  # f1+f0 > i
  # f0 > i-f1
  # check i-f1 as the stopping point, so that if i=UV_MAX then won't
  # overflow a UV trying to get to f1>=i
  #
  my $f0 = 1;
  my $f1 = 1;
  my $prev_f0;
  my $max = ~0;
  while ($f0 <= $max - $f1) {
    $prev_f0 = $f0;
    ($f1,$f0) = ($f1+$f0,$f1);
  }
  ### $prev_f0
  ### $f0
  ### $f1
  ### ~0 : ~0

  $prev_f0
};

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
  (my $ret,
   $self->{'f0'},
   $self->{'f1'})
    = ($self->{'f0'},
       $self->{'f1'},
       $self->{'f0'}+$self->{'f1'});
  ### $ret

  if ($ret == $uv_limit) {
    $self->{'f1'} = _bigint()->new("$self->{'f1'}");
  }

  return ($self->{'i'}++, $ret);
}

# ENHANCE-ME: powering ...
sub ith {
  my ($self, $i) = @_;
  ### Fibonacci ith(): $i
  if ($i == 0) {
    return $i;
  }
  my $f0 = ($i * 0);  # inherit bignum 0
  my $f1 = $f0 + 1;   # inherit bignum 1
  if (_is_infinite($i)) {
    return $i;
  }
  while (--$i > 0) {
    $f0 += $f1;

    unless (--$i > 0) {
      return $f0;
    }
    $f1 += $f0;
  }
  return $f1;
}

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

The Fibonacci sequence 0,1,1,2,3,5,8,13,21, etc.  The start is i=0 values
0,1 and from there F(i) = F(i-1) + F(i-2).

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
L<Math::NumSeq::Fibbinary>,
L<Math::NumSeq::FibonacciWord>,
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
