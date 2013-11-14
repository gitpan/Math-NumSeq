# Copyright 2011, 2012, 2013 Kevin Ryde

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


# Edsgar Dijkstra
#    http://www.cs.utexas.edu/users/EWD/ewd05xx/EWD570.PDF
#    http://www.cs.utexas.edu/users/EWD/ewd05xx/EWD578.PDF
#
# from 1858
#
# cf A000119 fibonacci diatomic


package Math::NumSeq::SternDiatomic;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 67;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Stern Diatomic');
use constant description => Math::NumSeq::__('Stern\'s diatomic sequence.');
use constant default_i_start => 0;
use constant values_min => 0;
use constant characteristic_smaller => 1;
use constant characteristic_increasing => 0;
use constant characteristic_integer => 1;

#------------------------------------------------------------------------------
# cf A126606 - starting 0,2 gives 2*diatomic
#    A049455 - repeat 0..2^k
#    A049456 - extra 1 at end of each row
#    A174980 - type ([0,1],1), adding 1 extra at n=2^k
#    A049455,A049456 stern/farey tree
#    A070878 stern by rows
#    A070879 stern by rows
#
use constant oeis_anum => 'A002487';

#------------------------------------------------------------------------------

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'p'} = 0;
  $self->{'q'} = 1;
}
sub seek_to_i {
  my ($self, $i) = @_;
  $self->{'i'} = $i;
  $self->{'p'} = $self->ith($i);
  $self->{'q'} = $self->ith($i+1);
}

sub next {
  my ($self) = @_;
  my $p = $self->{'p'};
  my $q = $self->{'q'};
  $self->{'p'} = $q;
  $self->{'q'} = $p + $q - 2*($p % $q);
  return ($self->{'i'}++, $p);
}

sub ith {
  my ($self, $i) = @_;
  return ($self->_ith_pair($i))[0];
}

# Return ($value[i], $value[i+1]).
sub _ith_pair {
  my ($self, $i) = @_;
  ### SternDiatomic _ith_pair(): "$i"

  if ($i < 0) {
    if ($i < -1) {
      return (undef,undef);
    } else {
      return (undef,0);
    }
  }
  if (_is_infinite($i)) {  # don't loop forever if $value is +/-infinity
    return ($i,$i);
  }

  my $p = ($i * 0); # inherit bignum 0
  my $q = $p + 1;   # inherit bignum 1

  while ($i) {
    if ($i % 2) {
      $p += $q;
    } else {
      $q += $p;
    }
    $i = int($i/2);
  }

  ### result: "$p, $q"
  return ($p,$q);
}

sub pred {
  my ($self, $value) = @_;
  ### SternDiatomic pred(): $value
  return ($value >= 0 && $value == int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq radix Moritz

=head1 NAME

Math::NumSeq::SternDiatomic -- Stern's diatomic sequence

=head1 SYNOPSIS

 use Math::NumSeq::SternDiatomic;
 my $seq = Math::NumSeq::SternDiatomic->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is Moritz Stern's diatomic sequence

    0, 1, 1, 2, 1, 3, 2, 3, ...
    starting i=0

It's constructed by successive levels with a recurrence

    D(0)     = 0
    D(1)     = 1
    D(2*i)   = D(i)
    D(2*i+1) = D(i) + D(i+1)

So the sequence is extended by copying the previous level to the next spead
out to even indices, and at the odd indices fill in the sum of adjacent
terms,

   0,                    i=0
   1,                    i=1
   1,      2,            i=2 to 3
   1,  3,  2,  3,        i=4 to 7
   1,4,3,5,2,5,3,4,      i=8 to 15

For example the i=4to7 row is a copy of the preceding row values 1,2 with
sums 1+2 and 2+1 interleaved.  For the new value at the end of each row the
sum wraps around so as to take the copied value on the left and the first
value of the next row (which is always 1).

=head2 Odd and Even

The sequence makes a repeating pattern even,odd,odd,

    0, 1, 1, 2, 1, 3, 2, 3
    E  O  O  E  O  O  E ...

This can be seen from the copying in the recurrence above.  For example the
i=8 to 15 row copying to i=16 to 31,

    O . E . O . O . E . O . O . E .      spread
      O   O   E   O   O   E   O   O      sum adjacent

Adding adjacent terms odd+even and even+odd are both odd.  Adding adjacent
odd+odd gives even.  So the pattern E,O,O in the original row when spread
and added gives E,O,O again in the next row.

=cut

# OEOOEO
#  O O E O E

=pod

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::SternDiatomic-E<gt>new ()>

Create and return a new sequence object.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th value of the sequence.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which means simply integer
C<$valueE<gt>=0>.

=back

=head1 FORMULAS

=head2 Next

X<Newman, Moshe>The sequence is iterated using a method by Moshe Newman.

=over

"Recounting the Rationals, Continued", answers to problem 10906 posed by
Donald E. Knuth, C. P. Rupert, Alex Smith and Richard Stong, American
Mathematical Monthly, volume 110, number 7, Aug-Sep 2003, pages 642-643,
L<http://www.jstor.org/stable/3647762>

=back

Two successive sequence values are maintained and are advanced by a simple
operation.

    p = seq[i]      initially p=0 = seq[0]
    q = seq[i+1]              q=1 = seq[1]

    p_next = seq[i+1] = q
    q_next = seq[i+2] = p+q - 2*(p mod q)

    where the mod operation rounds towards zero
    0 <= (p mod q) <= q-1

The form by Newman uses a floor operation.  This suits expressing the
iteration in terms of a rational x[i]=p/q.

    p_next              1
    ------  =  ----------------------
    q_next     1 + 2*floor(p/q) - p/q

For separate p,q a little rearrangement gives it in terms of the remainder p
mod q.

    p = q*floor(p/q) + rem      where rem = (p mod q)

    so
    p_next/q_next = q / (2*q*floor(p/q) + q - p)
                  = q / (2*(p - rem) + q - p)  
                  = q / (p+q - 2*rem)

C<seek_to_i()> is implemented by calculating new p,q values with C<ith(i)>
per below.

=cut

# f*q + r = p
# f*q = p - r
# q-r = 1 - (-p % q)
# next = 1 / (2*floor(p/q) + 1 - p/q)
#      = q / (2*q*floor(p/q) + q - p)
#      = q / (2*q*f + q - p)
#      = q / (2*(p - r) + q - p)
#      = q / (2*p - 2*r + q - p)
#      = q / (p + q - 2*r)

=head2 Ith

The sequence at an arbitrary i can be calculated from the bits of i,

    p = 0
    q = 1
    for each bit of i from low to high
      if bit=1 then p += q
      if bit=0 then q += p
    return p

For example i=6 is binary "110" so p,q starts 0,1 then low bit=0 q+=p leaves
that unchanged as 0,1.  Next bit=1 p+=q gives 1,1 and high bit=1 gives 2,1
for result 2.

Any low zero bits can be ignored since initial p=0 means their steps q+=p do
nothing.  The current code doesn't use this since it's not expected i would
usually have many trailing zeros and the q+=p saved won't be particularly
slow.

=head1 SEE ALSO

L<Math::NumSeq>

=head1 HOME PAGE

L<http://user42.tuxfamily.org/math-numseq/index.html>

=head1 LICENSE

Copyright 2011, 2012, 2013 Kevin Ryde

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
