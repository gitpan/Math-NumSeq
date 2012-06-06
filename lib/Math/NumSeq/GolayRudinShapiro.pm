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

package Math::NumSeq::GolayRudinShapiro;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 42;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


# cf A020985 - 1 and -1
#    A020987 - 0 and 1
#    A022155 - positions of -1
#    A014081 - count of 11 bit pairs
#    A020986 - cumulative 1,-1, always positive
#    A020990 - cumulative GRS(2n+1), flips sign at odd i
#    A020991 - highest occurrence of N in the partial sums
#
# use constant name => Math::NumSeq::__('Golay-Rudin-Shapiro');
use constant description => Math::NumSeq::__('Golay/Rudin/Shapiro (-1)^(count adjacent 11 bit pairs), so +1 if even count -1 if odd.');
use constant values_min => -1;
use constant values_max => 1;
use constant characteristic_integer => 1;
use constant default_i_start => 0;
use constant oeis_anum => 'A020985';  # 1,-1

# ENHANCE-ME: use as_bin() on BigInt when available
#
# ENHANCE-ME: use unpack() checksum 1-bit count as described by
# perlfunc.pod, if fit a UV or C "int" or whatever
#
#     # N & Nshift leaves bits with a 1 below them, then parity of bit count
#     $i &= ($i >> 1);
#     return (1 & unpack('%32b*', pack('I', $i)));
#
sub ith {
  my ($self, $i) = @_;
  if ($i < 0) {
    return undef;
  }
  if (_is_infinite($i)) {
    return $i;
  }

  my $prev = $i % 2; $i = int($i/2);
  my $xor = 0;
  while ($i) {
    my $bit = $i % 2; $i = int($i/2);
    $xor ^= ($prev & $bit);
    $prev = $bit;
  }
  return (1 - 2*$xor);
}

sub pred {
  my ($self, $value) = @_;
  return ($value == 1 || $value == -1);
}

# Jorg Arndt fxtbook next step by
# low 1s 0111 increment to become 1000
# if even number of 1s then that's a "11" parity change
# and if the 1000 has a 1 above it then that's a parity change too
# so flip if 10..00 is an odd bit position XOR the bit above it

1;
__END__



=for stopwords Ryde OEIS GRS dX dY NumSeq

=head1 NAME

Math::NumSeq::GolayRudinShapiro -- parity of adjacent 11 bit pairs

=head1 SYNOPSIS

 use Math::NumSeq::GolayRudinShapiro;
 my $seq = Math::NumSeq::GolayRudinShapiro->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is the Golay/Rudin/Shapiro sequence of +1 or -1 according to there
being an even or odd number of adjacent 11 bit pairs in i, starting from i=0

    1, 1, 1, -1, 1, 1, -1, 1, 1, 1, 1, -1, ...

    GRS(i) = (-1) ^ (count 11 bit pairs)

The first -1 is at i=3 which is binary 11 with a single 11 bit pair, then
i=6 binary 110 likewise -1.  Or for example i=14 is binary 1110 which has
two adjacent 11 pairs (overlaps count), so value=1.

The value is also the parity of the number of even-length runs of 1 bits
in i.  An even length run has an odd number of 11 pairs, so each is a -1 in
the calculation.  An odd-length run of 1 bits is an even number of 11 pairs
and so is +1 and has no effect on the result.

Such a parity of even-length 1-bit runs and hence the GRS sequence arises as
the "dX,dY" change for each segment of the alternate paper folding curve.
See L<Math::PlanePath::AlternatePaper/X,Y change>.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::GolayRudinShapiro-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th value from the sequence, being +1 or -1 according to the
number of adjacent 11 bit pairs in C<$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which simply means C<$value
== 1> or C<$value == -1>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::GolayRudinShapiroCumulative>,
L<Math::NumSeq::BaumSweet>,
L<Math::NumSeq::Fibbinary>

L<Math::PlanePath::AlternatePaper>

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
