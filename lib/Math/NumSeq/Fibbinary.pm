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


# ZOrderCurve, ImaginaryBase tree shape
# DragonCurve repeating runs
#
# cf fxtbook ch38 p756


package Math::NumSeq::Fibbinary;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 20;
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
#    A014417 - n in fibonacci base, the fibbinaries written out in binary
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

  # f1+f0 > i
  # f0 > i-f1
  # check i-f1 as the stopping point, so that if i=UV_MAX then won't
  # overflow a UV trying to get to f1>=i
  #
  my @fibs;
  {
    my $f0 = ($i * 0);  # inherit bignum 0
    my $f1 = $f0 + 1;   # inherit bignum 1
    @fibs = ($f0);
    while ($f0 <= $i-$f1) {
      ($f1,$f0) = ($f1+$f0,$f1);
      push @fibs, $f1;
    }
  }
  ### @fibs

  my $value = 0;
  while (my $f = pop @fibs) {
    ### at: "$f i=$i  value=$value"
    $value *= 2;
    if ($i >= $f) {
      $value += 1;
      $i -= $f;
      ### sub: "$f to i=$i value=$value"

      # never consecutive fibs, so pop without comparing to i
      pop @fibs || last;
      $value *= 2;
    }
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

  # go to BigInt if floating point integer bigger than UV, since "&"
  # operator will cast to a UV and lose bits
  if ($int > ~0 && ! ref $int) {
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




=for stopwords Ryde Math-NumSeq fibbinary Zeckendorf k's Ith i'th OR-ing incrementing Fibonaccis BigInt BigFloat BigRat eg ie

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

Since the two highest bits must be "10...", skipping any high "11...",
there's effectively a block of 2^k values (though not all of them used)
followed by a gap of 2^k values, etc.

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

The spacing between Fibonacci numbers means that after subtracting F(k) the
next cannot be F(k-1), only F(k-2) or less.  For that reason there's no
adjacent 1 bits in the fibbinary numbers.

The connection between no adjacent 1s and the Fibonacci sequence can be seen
from the values that have a high bit 2^k.  New values with that high bit not
with high 2^(k-1) but only 2^(k-2), so effectively the new values are not
the previous k-1 but the second previous k-2, the same way as the Fibonacci
sequence adds not the previous term but the one before.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Fibbinary-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th fibbinary number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a fibbinary number, which means that in binary
it doesn't have any consecutive 1 bits.

=back

=head1 FORMULAS

=head2 Next Value

For a given fibbinary number, the next number is simply +1 if the lowest bit
is 2^2=4 or more.  If the low bit is 2^1=2 or 2^0=1 then the run of low
alternating ...101 or ...1010 must be cleared and the bit above set.  For
example 1001010 becomes 1010000.  All cases can be handled quite easily with
some bit twiddling

    filled = (value >> 1) | value
    mask = ((filled+1) ^ filled) >> 1
    next value = (value | mask) + 1

For example

    value  = 1001010
    filled = 1101111
    mask   =    1111
    next   = 1010000

"filled" means any ...01010 ending has the zeros filled in to ...01111, then
those low ones can be extracted with +1 and XOR (the usual trick for getting
low ones).  +1 means the bit above the filled part is included ...11111, but
a shift drops back to "mask" of just 01111.  OR-ing and incrementing then
clears those low bits and sets the next higher to make ...10000.

This works for any fibbinary value inputs, both "...10101" and "...1010"
endings and also zeros "...0000" ending.  In the zeros case the result is
just a +1 for "...0001", including input=0 giving next=1.

=head2 Ith Value

The i'th fibbinary number can be calculated by the Zeckendorf breakdown
described above.  Reckoning the Fibonacci numbers as F(0)=1, F(1)=2, F(2)=3,
F(3)=5, etc,

    find the biggest F(k) <= i
    subtract i -= F(k)
    fibbinary result += 2^k
    repeat until i=0

To find each F(k)E<lt>=i either just work downwards through the Fibonacci
numbers, or perhaps alternatively the Fibonaccis grow as (phi^k)/sqrt(5)
with phi=(sqrt(5)+1)/2 the golden ratio, so an F(k) could be found by a log
base phi of i.  Or taking log2 of i (the highest bit in i) might give 2 or 3
candidates for k.  Log base phi is unlikely to be faster, but log 2 high bit
might quickly go to a nearly-correct place in a table.

=head2 Predicate

Testing for a fibbinary value can be done by a shift and AND,

    is_fibbinary = ((value & (value >> 1)) == 0)

Any adjacent 1 bits overlap in the shift+AND and come through as non-zero.

In Perl C<&> converts NV float to UV/IV integer.  If a value in an NV
mantissa is an integer but bigger than a UV then bits will be lost in an
C<&>.  Conversion to C<Math::BigInt> or similar is necessary to preserve the
full value.  Floats which are integers but bigger than an UV/IV might be of
interest, or it might be thought any float means rounded-off and therefore
inaccurate and not of interest.  The current code has some experimental
automatic BigInt conversion which works and which accepts BigFloat or BigRat
integers too, but don't rely on this quite yet.  (A BigInt input directly is
fine of course.)

=head2 Value Below

If a number is not a fibbinary, eg. 11000110, then the next lower fibbinary
can be had by finding the highest 11 pair and changing it and all the bits
below to 101010...etc.  There's nothing in the code here doing this though.

Offending 11 pairs can be picked out by an AND per the predicate above.
After a shift and AND the highest 1 bit is from the highest 11 pair and is
the lower of the two bits in that pair.  That position should then become a
0 etc, ie. "01010...".  The higher 1 in the highest 11 pair is unchanged.

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

# Local variables:
# compile-command: "math-image --values=Fibbinary"
# End:
