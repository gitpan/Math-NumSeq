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

package Math::NumSeq::Fibonacci;
use 5.004;
use strict;
use Math::NumSeq;

use vars '$VERSION','@ISA';
$VERSION = 48;
use Math::NumSeq::Base::Sparse;  # FIXME: implement pred() directly ...
@ISA = ('Math::NumSeq::Base::Sparse');

use Math::NumSeq;
*_is_infinite = \&Math::NumSeq::_is_infinite;
*_to_bigint = \&Math::NumSeq::_to_bigint;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Fibonacci Numbers');
use constant description => Math::NumSeq::__('The Fibonacci numbers 1,1,2,3,5,8,13,21, etc, each F(i) = F(i-1) + F(i-2), starting from 1,1.');

use constant values_min => 0;
use constant i_start => 0;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;

# cf A105527 - index when n-nacci exceeds Fibonacci
#
use constant oeis_anum => 'A000045'; # fibonacci starting at i=0 0,1,1,2,3

# the biggest f0 for which both f0 and f1 fit into a UV, and which therefore
# for the next step will require BigInt
#
my $uv_limit;
my $uv_i_limit = 0;
{
  # Float integers too in 32 bits ?
  # my $max = 1;
  # for (1 .. 256) {
  #   my $try = $max*2 + 1;
  #   ### $try
  #   if ($try == 2*$max || $try == 2*$max+2) {
  #     last;
  #   }
  #   $max = $try;
  # }
  my $max = ~0;

  # f1+f0 > i
  # f0 > i-f1
  # check i-f1 as the stopping point, so that if i=UV_MAX then won't
  # overflow a UV trying to get to f1>=i
  #
  my $f0 = 1;
  my $f1 = 1;
  my $prev_f0;
  while ($f0 <= $max - $f1) {
    $prev_f0 = $f0;
    ($f1,$f0) = ($f1+$f0,$f1);
    $uv_i_limit++;
  }

  ### Fibonacci UV limit ...
  ### $prev_f0
  ### $f0
  ### $f1
  ### ~0 : ~0

  $uv_limit = $prev_f0;

  ### $uv_limit
  ### $uv_i_limit

  __PACKAGE__->ith($uv_i_limit) == $uv_limit
    or die "Oops, wrong uv_i_limit";
}

sub rewind {
  my ($self) = @_;
  ### Fibonacci rewind()
  $self->{'f0'} = 0;
  $self->{'f1'} = 1;
  $self->{'i'} = $self->i_start;
}
sub seek_to_i {
  my ($self, $i) = @_;
  # ENHANCE-ME: $self->ith_pair($i) giving i and i+1, or i-1 and i
  $self->{'f0'} = $self->ith($i);
  $self->{'f1'} = $self->ith($i+1);
  $self->{'i'} = $i;
}
sub next {
  my ($self) = @_;
  ### Fibonacci next(): "f0=$self->{'f0'}, f1=$self->{'f1'}"
  (my $ret,
   $self->{'f0'},
   $self->{'f1'})
    = ($self->{'f0'},
       $self->{'f1'},
       $self->{'f0'} + $self->{'f1'});
  ### $ret

  if ($ret == $uv_limit) {
    ### go to bigint f1 ...
    $self->{'f1'} = _to_bigint($self->{'f1'});
  }

  return ($self->{'i'}++, $ret);
}

sub ith {
  my ($self, $i) = @_;
  ### Fibonacci ith(): $i

  if (_is_infinite($i)) {
    return $i;
  }
  if ($i == 0) {
    return $i;
  }

  my @bits = _bits_high_to_low($i);
  ### @bits

  # k=1, Fk1=F[k-1]=0, Fk=F[k]=1
  shift @bits; # high 1
  my $Fk1 = ($i * 0);  # inherit bignum 0
  if ($i > $uv_i_limit && ! ref $Fk1) {
    # automatic BigInt if not another bignum class
    $Fk1 = _to_bigint(0);
  }
  my $Fk = $Fk1 + 1;  # inherit bignum 1

  my $add = -2;
  while (@bits > 1) {
    ### remaining bits: @bits
    ### Fk1: "$Fk1"
    ### Fk: "$Fk"

    # two squares and some adds
    # F[2k+1] = 4*F[k]^2 - F[k-1]^2 + 2*(-1)^k
    # F[2k-1] =   F[k]^2 + F[k-1]^2
    # F[2k] = F[2k+1] - F[2k-1]
    #
    $Fk *= $Fk;
    $Fk1 *= $Fk1;
    my $F2kplus1 = 4*$Fk - $Fk1 + $add;
    $Fk1 += $Fk; # F[2k-1]
    my $F2k = $F2kplus1 - $Fk1;

    if (shift @bits) {  # high to low
      $Fk1 = $F2k;     # F[2k]
      $Fk = $F2kplus1; # F[2k+1]
      $add = -2;
    } else {
      # $Fk1 is F[2k-1] already
      $Fk = $F2k;  # F[2k]
      $add = 2;
    }
  }

  ### final ...
  ### Fk1: "$Fk1"
  ### Fk: "$Fk"
  ### @bits

  # last step needing just one of F[2k] or F[2k+1] by one multiply instead
  # of two squares in the loop
  # F[2k+1] = (2F[k]+F[k-1])*(2F[k]-F[k-1]) + 2*(-1)^k
  # F[2k]   = F[k]*(F[k]+2F[k-1])
  #
  if (shift @bits) {
    $Fk *= 2;
    return ($Fk + $Fk1)*($Fk - $Fk1) + $add;
  } else {
    return $Fk * ($Fk + 2*$Fk1);
  }
}

sub _bits_high_to_low {
  my ($n) = @_;
  ### _bits_high_to_low(): "$n"

  if (ref $n) {
    if ($n->isa('Math::BigInt')
        && $n->can('as_bin')) {
      ### BigInt: $n->as_bin
      return split //, substr($n->as_bin,2);
    }
  }
  my @bits;
  while ($n) {
    push @bits, $n % 2;
    $n = int($n/2);
  }
  return reverse @bits;
}

use constant 1.02 _PHI => (1 + sqrt(5)) / 2;
use constant 1.02 _BETA => -1/_PHI;

sub value_to_i_estimate {
  my ($self, $value) = @_;
  if (_is_infinite($value)) {
    return $value;
  }
  if ($value <= 0) {
    return 0;
  }

  if (defined (my $blog2 = _blog2_estimate($value))) {
    # i ~= (log2(F(i)) + log2(phi)) / log2(phi-beta)
    # with log2(x) = log(x)/log(2)
    return int( ($blog2 + (log(_PHI - _BETA)/log(2)))
                / (log(_PHI)/log(2)) );
  }

  # i ~= (log(F(i)) + log(phi)) / log(phi-beta)
  return int( (log($value) + log(_PHI - _BETA))
              / log(_PHI) );
}

#------------------------------------------------------------------------------
# generic, shared

# if $n is a BigInt, BigRat or BigFloat then return an estimate of log base 2
# otherwise return undef.
#
# For Math::BigInt 
#
# For BigRat the calculation is just a bit count of the numerator less the
# denominator so may be off by +/-1 or +/-2 or some such.  For 
#
sub _blog2_estimate {
  my ($n) = @_;

  if (ref $n) {
    ### _blog2_estimate(): "$n"

    if ($n->isa('Math::BigRat')) {
      return ($n->numerator->copy->blog(2) - $n->denominator->copy->blog(2))->numify;
    }
    if ($n->isa('Math::BigFloat')) {
      return $n->as_int->blog(2)->numify;
    }
    if ($n->isa('Math::BigInt')) {
      return $n->copy->blog(2)->numify;
    }
  }
  return undef;
}

1;
__END__

=for stopwords Ryde Math-NumSeq Ith bignum

=head1 NAME

Math::NumSeq::Fibonacci -- Fibonacci numbers

=head1 SYNOPSIS

 use Math::NumSeq::Fibonacci;
 my $seq = Math::NumSeq::Fibonacci->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Fibonacci numbers F(i) = F(i-1) + F(i-2) starting from 0,1,

     starting i=0
     0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::Fibonacci-E<gt>new ()>

Create and return a new sequence object.

=item C<($i, $value) = $seq-E<gt>next()>

Return the next index and value in the sequence.

When C<$value> exceeds the range of a Perl unsigned integer the return is a
C<Math::BigInt> to preserve precision.

=item C<$seq-E<gt>seek_to_i($i)>

Move the current sequence position to C<$i>.  The next call to C<next()>
will return C<$i> and corresponding value.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th Fibonacci number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Fibonacci number.

=item C<$i = $seq-E<gt>value_to_i_estimate($value)>

Return an estimate of the i corresponding to C<$value>.  See L</Value to i
Estimate> below.

=back

=head1 FORMULAS

=head2 Ith

Fibonacci F[i] can be calculated by a powering procedure with two squares
per step.  A pair of values F[k] and F[k-1] are maintained and advanced
according to bits of i from high to low

    start k=1, F[k]=1, F[k-1]=0
    add = -2       # 2*(-1)^k
    
    loop
      F[2k+1] = 4*F[k]^2 - F[k-1]^2 + add
      F[2k-1] =   F[k]^2 + F[k-1]^2

      F[2k] = F[2k+1] - F[2k-1]

      bit = next bit of i, high to low, skip high 1 bit
      if bit == 1
         take F[2k+1], F[2k] as new F[k],F[k-1]
         add = -2
      else bit == 0
         take F[2k], F[2k-1] as new F[k],F[k-1]
         add = 2

For the last (least significant) bit of i an optimization can be made with a
single multiple for that last step (instead of two squares).

    bit = least significant bit of i
    if bit == 1
       F[2k+1] = (2F[k]+F[k-1])*(2F[k]-F[k-1]) + add
    else
       F[2k]   = F[k]*(F[k]+2F[k-1])

The "add" amount is 2*(-1)^k and is +2 or -2 according to k odd or even,
which means whether the previous bit taken from i was 1 or 0.  That can be
easily noted from each bit, to be used in the following loop iteration or
the final step F[2k+1] formula.

For small i it's usually faster to just successively add F[k+1]=F[k]+F[k-1],
but when in bignum range the doubling k-E<gt>2k by two squares becomes
faster than k many individual additions for the same thing.

=head2 Value to i Estimate

F[i] increases as a power of phi, the golden ratio,

    F[i] = (phi^i - beta^i) / (phi - beta)    # exactly

    phi = (1+sqrt(5))/2
    beta = -1/phi =-0.618

So taking a log (natural logarithm) to get i and ignoring beta^i which
quickly becomes small

    log(F[i]) ~= i*log(phi) - log(phi-beta)
    i ~= (log(F[i]) + log(phi-beta)) / log(phi)

Or the same using log base 2 which can be estimated from the highest bit
position of a bignum,

    log2(F[i]) ~= i*log2(phi) - log2(phi-beta)
    i ~= (log2(F[i]) + log2(phi-beta)) / log2(phi)

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::LucasNumbers>,
L<Math::NumSeq::Fibbinary>,
L<Math::NumSeq::FibonacciWord>,
L<Math::NumSeq::Tribonacci>

L<Math::Fibonacci>,
L<Math::Fibonacci::Phi>

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
