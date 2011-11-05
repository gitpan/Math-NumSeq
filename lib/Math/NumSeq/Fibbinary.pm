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
$VERSION = 15;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;


# uncomment this to run the ### lines
#use Smart::Comments;

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
  $self->{'i'} = 0;
  $self->{'value'} = 0;
}

sub next {
  my ($self) = @_;
  ### Fibbinary next() ...

  my $v = $self->{'value'};
  my $filled = ($v >> 1) | $v;
  my $mask = (($filled+1) ^ $filled) >> 1;
  $self->{'value'} = ($v | $mask) + 1;

  ### value : sprintf('0b %6b',$v)
  ### filled: sprintf('0b %6b',$filled)
  ### mask  : sprintf('0b %6b',$mask)
  ### bit   : sprintf('0b %6b',$mask+1)
  ### newv  : sprintf('0b %6b',$self->{'value'})

  return ($self->{'i'}++, $v);
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

  my $int;
  unless ($value >= 0
          && $value == ($int = int($value))) {
    return 0;
  }

  if ($int > ~0) {
    require Math::BigInt;
    $int = Math::BigInt->new(sprintf('%.0f',$int));
    ### use BigInt: $int
    ### str: sprintf('%.0f',$int)
  }

  ### and: ($int & ($int >> 1)).''
  return ! ($int & ($int >> 1));
}

1;
__END__


# old next():
#   @{$self->{'pos'}} = (-2);
#   @{$self->{'values'}} = (1);
# sub Xnext {
#   my ($self) = @_;
#   ### Fibbinary next() ...
# 
#   my $ret;
#   my $pa = $self->{'pos'};
#   my $va = $self->{'values'};
#   ### $pa
#   ### $va
# 
#   my $pos = $pa->[-1];
#   if ($pos <= -1) {
#     if ($pos < -1) {
#       $pa->[-1] = -1;
#       $ret = 0;
#     } else {
#       $pa->[-1] = 0;
#       $ret = 1;
#     }
#   } elsif ($pos >= 2) {
#     ### introduce low bit ...
#     push @$pa, 0;
#     push @$va, ($ret = $va->[-1] + 1);
#   } else {
#     # move bit up
#     while ($#$pa && $pos+2 >= $pa->[-2]) {
#       pop @$pa;
#       pop @$va;
#       $pos = $pa->[-1];
#     }
#     $ret = ($va->[-1] += 2**$pos);
#     (++$pa->[-1]);
#     ### move up to
#     ### added power: 2**$pos
#     ### $pa
#     ### $va
#     ### $pos
#   }
#   ### $ret
#   return ($self->{'i'}++, $ret);
# }




=for stopwords Ryde Math-NumSeq fibbinary Zeckendorf k's Ith i'th

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

Since the two highest bits must be "10..." and "11..." is all skipped
there's effectively a run of 2^k values (not all of them used of course)
followed by a 2^k gap.

=head2 Zeckendorf Base

The bits of the fibbinary numbers encode Fibonacci numbers used to represent
i in Zeckendorf style Fibonacci base.  In that system an integer i is a sum
of Fibonacci numbers,

    i = F(k1) + F(k2) + ... F(kn)         k1 > k2 > ... > kn

Each k is chosen as the highest Fibonacci less than the remainder at that
point.  For example, taking F(0)=1, F(1)=2, etc,

    20 = 13+5+1 = F(5)+F(3)+F(0)

The k's are then assembled as 1 bits in binary to encode the representation,

    fibbinary(20) = 2^5 + 2^3 + 2^0 = 41

The spacing between Fibonacci numbers means after subtracting F(k) the next
cannot be F(k-1), only F(k-2) or less, which means no adjacent 1 bits in the
fibbinary numbers.

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

For a given fibbinary number, the next number is simply +1 if the lowest bit
is 2^2=4 or more.  If the low bit is 2^1=2 or 2^0=1 then the run of trailing
...0101 or ...1010 must be cleared and the bit above incremented.  For
example 1001010 becomes 1010000.  This can be done with some bit twiddling

    filled  = (value >> 1) | value
    mask = ((filled+1) ^ filled) >> 1
    next value = (value | mask) + 1

For example

    value  = 1001010
    filled = 1001111
    mask   =    1111
    next   = 1010000

"filled" means any ...01010 ending has the zeros filled in to ...01111, then
those low ones can be picked out with +1 and XOR.  The +1 includes the bit
above that filled part so ...11111, but a shift drops back to a "mask" of
just 01111.  OR-ing and incrementing then clears those low bits and sets the
next higher to make ...10000.

This works for both a ...0101 and ...1010 ending.  In fact it also works
when the ending has no 01 or 10 run but all zeros ...0000.  In that case the
result is just a +1 for ...0001.

Note the calculation only works starting from an existing fibbinary value.
It won't go from an arbitrary starting value to the next fibbinary as it
acts only on the low bits (up to the lowest "00" pair), leaving the higher
bits perhaps still with adjacent 1s.

=head2 Ith Value

The i'th fibbinary number can be calculated by the Zeckendorf breakdown
described above.

    find the biggest F(k) <= i
    subtract i -= F(k)
    fibbinary result += 2^k
    repeat until i=0

To find each F(k) either just work downwards through the Fibonacci numbers,
or alternatively since the Fibonaccis grow as (phi^k)/sqrt(5) where
phi=(sqrt(5)+1)/2 is the golden ratio, an F(k) could be found by a log base
phi of i.  Or taking log(2) for the highest bit in i might give 2 or 3
candidates for k.  A log base phi is unlikely to be faster, but the log 2
high bit might jump to a nearly-correct place in a table.

=head2 Predicate

Testing for a fibbinary value can be done by a shift and AND,

    is_fibbinary = (value & (value >> 1)) == 0

Any adjacent 1 bits will overlap and come through the AND as non-zero.

In Perl C<&> converts float to int so to test a value bigger than an int
requires conversion to C<Math::BigInt> or similar.  (Floats which are
integers but bigger than an UV/IV might be of interest, or it might be
thought any float means rounded-off and therefore inaccurate and not of
interest.  The current code has some experimental BigInt which works, and
can accept BigFloat or BigRat integers, but don't rely on this yet.)

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>,
L<Math::NumSeq::FibonacciWord>

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
