# Copyright 2011 Kevin Ryde

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


# math-image --values=Fibbinary
#
# ZOrderCurve, ImaginaryBase tree shape
# DragonCurve repeating runs
#
# cf fxtbook ch38 p756


package Math::NumSeq::Fibbinary;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 10;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;


# uncomment this to run the ### lines
#use Devel::Comments;

use constant values_min => 0;
use constant characteristic_monotonic => 2;
use constant description => Math::NumSeq::__('Fibbinary numbers 0,1,2,4,5,8,9,etc, without adjacent 1 bits.');

# cf A000119 - number of fibonacci sums forms
#    A003622 - n with odd Zeckendorf,  cf golden seq
#    A037011 - baum-sweet cubic, might be 1 iff i is in the fibbinary seq
#
use constant oeis_anum => 'A003714';  # Fibbinary


sub rewind {
  my ($self) = @_;
  @{$self->{'pos'}} = (-2);
  @{$self->{'values'}} = (1);
  $self->{'i'} = 0;
}

sub next {
  my ($self) = @_;
  ### Fibbinary next() ...

  my $ret;
  my $pa = $self->{'pos'};
  my $va = $self->{'values'};
  ### $pa
  ### $va

  my $pos = $pa->[-1];
  if ($pos <= -1) {
    if ($pos < -1) {
      $pa->[-1] = -1;
      $ret = 0;
    } else {
      $pa->[-1] = 0;
      $ret = 1;
    }
  } elsif ($pos >= 2) {
    ### introduce low bit ...
    push @$pa, 0;
    push @$va, ($ret = $va->[-1] + 1);
  } else {
    # move bit up
    while ($#$pa && $pos+2 >= $pa->[-2]) {
      pop @$pa;
      pop @$va;
      $pos = $pa->[-1];
    }
    $ret = ($va->[-1] += 2**$pos);
    (++$pa->[-1]);
    ### move up to
    ### added power: 2**$pos
    ### $pa
    ### $va
    ### $pos
  }
  ### $ret
  return ($self->{'i'}++, $ret);
}

sub ith {
  my ($self, $i) = @_;
  ### Fibbinary ith(): $i

  if (_is_infinite($i)) {
    return $i;
  }

  my $f0 = 1;
  my $f1 = 1;
  ### above: "$f1,$f0"
  while ($i >= $f1) {
    ($f1,$f0) = ($f1+$f0,$f1);
  }
  ### above: "$f1,$f0"

  my $value = 0;
  while ($f0 > 0) {
    ### at: "$f1,$f0  value=$value"
    $value *= 2;
    if ($i >= $f1) {
      $i -= $f1;
      $value += 1;
      ### sub: "$f1 to i=$i value=$value"

      ($f1,$f0) = ($f0,$f1-$f0);
      last unless $f0 > 0;
      $value *= 2;
    }
    ($f1,$f0) = ($f0,$f1-$f0);
  }
  return $value;
}

sub pred {
  my ($self, $value) = @_;
   ### Fibbinary pred(): $value
  return ($value >= 0
          && ($value & (2*$value)) == 0
          && $value == int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Fibbinary -- without consecutive 1 bits

=head1 SYNOPSIS

 use Math::NumSeq::Fibbinary;
 my $seq = Math::NumSeq::Fibbinary->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The fibbinary numbers 0, 1, 2, 4, 5, 8, 9, 10, etc, being integers which
have no adjacent 1 bits in binary.

    i    fibbinary, and in binary
   ---   ------------------------
    0        0           0
    1        1           1
    2        2          10
    3        4         100
    4        5         101
    5        8        1000
    6        9        1001
    7       10        1010
    8       16       10000
    9       17       10001

For example at i=4 fibbinary 5 the next fibbinary is not 6 or 7 because they
have adjacent 1 bits (110 and 111), the next is 8 (100).

=head2 Zeckendorf Base

The bits of the fibbinary numbers encode Fibonacci numbers used to represent
i in Zeckendorf style Fibonacci base.  In this system an integer i is
represented as a sum of Fibonacci numbers,

    i = F(k1) + F(k2) + ... F(kn)

For example, counting F(0)=1, F(1)=2, etc,

    20 = 13+5+1 = F(5)+F(3)+F(0)

The k's are then assembled as 1 bits in binary to encode the representation,

    fibbinary(20) = 2^5 + 2^3 + 2^0 = 41

The Zeckendorf form takes the highest Fibonacci F(k) E<lt>= i, subtracts
that from i, and repeats.  The spacing between Fibonacci numbers means after
subtracting F(k) the next cannot be F(k-1), only F(k-2) or less, giving no
adjacent 1 bits in the fibbinary numbers.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::All-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th fibbinary number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a fibbinary number, which means that in binary
it doesn't have any consecutive 1 bits.  Meaning simply a positive integer
with

    ($value & ($value<<1)) == 0

=back

=head1 FORMULAS

=head2 Next Value

For a given set of bits in a fibbinary number, the next number is simply +1
if the lowest bit is 2^2 or more.  If the low bit is 2^1 or 2^0 then it must
be shifted up 1 place.  If doing so makes it adjacent to a bit above it then
drop the low bit and that higher bit must be shifted up.  Repeat until the
shifting doesn't produce an adjacent bit.  For binary 1010...10 or
1010...101 this will mean going all the way to the most significant 1 bit
and dropping all the lower ones, giving the next fib=2^(k+1).

=head2 Ith Value

The i'th fibbinary number can be calculated by the Zeckendorf breakdown
described above.  Simply find the biggest F(k) E<lt>= i, subtract the F(k)
from i, put 2^k to the fibbinary, and repeat.

Since the Fibonacci numbers grow as (phi^k)/sqrt(5), where phi=(sqrt(5)+1)/2
is the golden ratio, the highest F(k) could be found by a logarithm.  Or a
log(2) highest bit in i could give 2 or 3 candidates.

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011 Kevin Ryde

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
