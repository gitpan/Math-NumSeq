# Copyright 2010, 2011, 2012, 2013 Kevin Ryde

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

package Math::NumSeq::LucasNumbers;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 60;
use Math::NumSeq::Base::Sparse;
@ISA = ('Math::NumSeq::Base::Sparse');

use Math::NumSeq;
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Fibonacci;
*_blog2_estimate = \&Math::NumSeq::Fibonacci::_blog2_estimate;
*_bits_high_to_low = \&Math::NumSeq::Fibonacci::_bits_high_to_low;


# uncomment this to run the ### lines
# use Smart::Comments;


# use constant name => Math::NumSeq::__('Lucas Numbers');
sub description {
  my ($self) = @_;
  if (ref $self && $self->i_start == 0) {
    return Math::NumSeq::__('Lucas numbers 2, 1, 3, 4, 7, 11, 18, 29, etc, being L(i+1) = L(i) + L(i-1) starting from 2,1.  This is the same recurrence as the Fibonacci numbers, but a different starting point.');
  } else {
    return Math::NumSeq::__('Lucas numbers 1, 3, 4, 7, 11, 18, 29, etc, being L(i+1) = L(i) + L(i-1) starting from 1,3.  This is the same recurrence as the Fibonacci numbers, but a different starting point.');
  }
}

# negatives at i odd negative, otherwise minimum 1 at i=1
sub values_min {
  my ($self) = @_;
  my $i = $self->i_start;
  if ($i <= 0 && $i % 2 == 0) {
    # i even, increase to make i odd and i<=1
    $i += 1;
  }
  return $self->ith($i);
}

sub characteristic_increasing {
  my ($self) = @_;
  # not increasing at i=0 value=2 then i=1 value=1
  return ($self->i_start >= 1);
}
sub characteristic_increasing_from_i {
  my ($self) = @_;
  return _max($self->i_start,1);
}
use constant characteristic_integer => 1;
use constant default_i_start => 1;

sub _max {
  my $ret = shift;
  while (@_) {
    my $next = shift;
    if ($next > $ret) {
      $ret = $next;
    }
  }
  return $ret;
}

#------------------------------------------------------------------------------
# cf A000285 starting 1,4
#    A022086 starting 0,3
#    A022087 starting 0,4
#    A022095 starting 1,5
#    A022130 starting 4,9
#    A080023 closest to log(phi), 2,3,4,7,11
#    A169985 nearestint(phi^n) 1,2,3,4,7,11,18
{
  my %oeis_anum = (0 => 'A000032',  # Lucas starting at 2,1,3,...
                   1 => 'A000204'); # Lucas starting at   1,3,...
  sub oeis_anum {
    my ($self) = @_;
    return $oeis_anum{$self->i_start};
  }
  # OEIS-Catalogue: A000204
  # OEIS-Catalogue: A000032 i_start=0
}

#------------------------------------------------------------------------------

# the biggest f0 for which both f0 and f1 fit into a UV, and which therefore
# for the next step will require BigInt
#
my $uv_limit;
my $uv_i_limit;
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
  my $i = 0;
  my $f0 = 1;
  my $f1 = 3;
  my $prev_f0;
  while ($f0 <= $max - $f1) {
    $prev_f0 = $f0;
    ($f1,$f0) = ($f1+$f0,$f1);
    $i++;
  }
  ### $prev_f0
  ### $f0
  ### $f1
  ### ~0 : ~0

  $uv_limit = $prev_f0;
  $uv_i_limit = $i;
  ### $uv_limit
  ### $uv_i_limit
  ### assert: __PACKAGE__->ith($uv_i_limit) == $uv_limit
};

#------------------------------------------------------------------------------

sub rewind {
  my ($self) = @_;
  $self->seek_to_i($self->i_start);
}
sub seek_to_i {
  my ($self, $i) = @_;
  $self->{'i'} = $i;
  if (abs($i) >= $uv_i_limit) {
    $i = Math::NumSeq::_to_bigint($i);
  }
  $self->{'f0'} = $self->ith($i);
  $self->{'f1'} = $self->ith($i+1);

  # or perhaps
  # ($self->{'f0'}, $self->{'f1'}) = $self->ith_pair($i);
}

sub next {
  my ($self) = @_;
  ### LucasNumbers next(): "f0=$self->{'f0'}, f1=$self->{'f1'}"

  (my $ret,
   $self->{'f0'},
   $self->{'f1'})
    = ($self->{'f0'},
       $self->{'f1'},
       $self->{'f0'}+$self->{'f1'});
  ### $ret

  if ($ret == $uv_limit) {
    $self->{'f0'} = Math::NumSeq::_to_bigint($self->{'f0'});
    $self->{'f1'} = Math::NumSeq::_to_bigint($self->{'f1'});
  }

  return ($self->{'i'}++, $ret);
}

# F[4] = (F[2]+L[2])^2/2 - 3*F[2]^2 - 2*(-1)^2
#      = (1+3)^2/4 - 3*1^2 - 2
#      = 16/4 - 3 - 2


# F[3] = ((F[1]+L[1])^2 - 2*(-1)^1)/4 + F[1]^2
#      = ((1+3)^2 - -2)/4 + 1^2
#      = (16 + 2)/4 + 1
#      = (16 + 2)/4 + 1

# F[3] = (F[1]+L[1])^2/4 + F[1]^2
#      = (1+3)^2/4 + 1^2
#      = 16/4 + 1
#      = 5

# -8,5,-3,2,-1,1, 0, 1,1,2,3,5,8,13,21
# -11,7,-4,3,-1, 2, 1,3,4,7,11,18,29
# 

sub ith {
  my ($self, $i) = @_;
  ### LucasNumbers ith(): $i

  if (_is_infinite($i)) {
    return $i;
  }
  $i = int($i);
  if ($i == 0) {
    return 2;
  }

  my $neg;
  if ($i < 0) {
    $i = -$i;
    $neg = $i % 2;
  }

  # k=1, L[1]=1
  my $Lk = ($i * 0) + 1;  # inherit bignum 1
  my $add = -2; # 2*(-1)^k

  my @bits = _bits_high_to_low($i);
  ### @bits

  my $lowzeros = 0;
  until (pop @bits) {
    $lowzeros++;
  }

  if (shift @bits) {
    ### high bit not the only 1-bit in i ...

    my $Fk = $Lk; # k=1, F[1]=1

    while (@bits) {
      ### remaining bits: @bits
      ### Lk: "$Lk"
      ### Fk: "$Fk"

      # two squares and some adds
      # F[2k] = (F[k]+L[k])^2/2 - 3*F[k]^2 - 2*(-1)^k
      # L[2k] = 5*F[k]^2 + 2*(-1)^k
      #
      # F[2k+1] = ((F[k]+L[k])^2 - 2*(-1)^k)/4 + F[k]^2
      # L[2k+1] = (5*(F[k]+L[k])^2 - 2*(-1)^k))/4 + F[k]^2
      #
      $Lk += $Fk;
      $Lk *= $Lk;  # (F[k]+L[k])^2
      $Fk *= $Fk;  # F[k]^2

      if (shift @bits) {
        ### double,shift to 2k+1 ...
        $Lk /= 4;
        ($Fk,$Lk) = ($Lk + $Fk,
                     5*($Lk - $Fk) - 2*$add);
        $add = -2;
      } else {
        ### double to 2k ...
        ($Fk,$Lk) = ($Lk/2 - 3*$Fk - $add,
                     5*$Fk + $add);
        $add = 2;
      }
    }

    ### final double,shift to 2k+1 ...
    ### Lk: "$Lk"
    ### Fk: "$Fk"

    $Lk += $Fk;
    $Lk *= $Lk;  # (F[k]+L[k])^2
    $Fk *= $Fk;  # F[k]^2
    $Lk = 5*($Lk/4 - $Fk) - 2*$add;
    $add = -2;
    ### Lk: "$Lk"
  }

  ### apply lowzeros: $lowzeros
  while ($lowzeros--) {
    $Lk *= $Lk;
    $Lk -= $add;
    $add = 2;
    ### lowzeros Lk: "$Lk"
  }

  ### final ...
  ### Lk: "$Lk"

  if ($neg) { $Lk = -$Lk; }
  return $Lk;





  # $i--;
  # my $f0 = ($i * 0) + 1;  # inherit bignum 1
  # my $f1 = $f0 + 2;       # inherit bignum 3
  # while (--$i > 0) {
  #   $f0 += $f1;
  #
  #   unless (--$i > 0) {
  #     return $f0;
  #   }
  #   $f1 += $f0;
  # }
  # return $f1;
}

use constant 1.02 _PHI => (1 + sqrt(5)) / 2;

sub value_to_i_estimate {
  my ($self, $value) = @_;
  if (_is_infinite($value)) {
    return $value;
  }
  if ($value <= 0) {
    return 0;
  }
  if (defined (my $blog2 = _blog2_estimate($value))) {
    # i ~= log2(L(i)) / log2(phi)
    # with log2(x) = log(x)/log(2)
    return int($blog2 * (1 / (log(_PHI)/log(2))));
  }

  # i ~= log(L(i)) / log(phi)
  return int(log($value) * (1/log(_PHI)));
}

1;
__END__

=for stopwords Ryde Math-NumSeq Ith ie doublings bignum Lestimate Festimate-1 vice-versa

=head1 NAME

Math::NumSeq::LucasNumbers -- Lucas numbers

=head1 SYNOPSIS

 use Math::NumSeq::LucasNumbers;
 my $seq = Math::NumSeq::LucasNumbers->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Lucas numbers, L(i) = L(i-1) + L(i-2) starting from values 1,3.

    1, 3, 4, 7, 11, 18, 29, 47, 76, 123, 199, 322, 521, 843, 1364,...
    starting i=1

This is the same recurrence as the Fibonacci numbers
(L<Math::NumSeq::Fibonacci>), but a different starting point.

    L[i+1] = L[i] + L[i-1]

Each Lucas number falls in between successive Fibonaccis, and in fact the
distance is a further Fibonacci,

    F[i+1] < L[i] < F[i+2]

    L[i] = F[i+1] + F[i-1]      # above F[i+1]
    L[i] = F[i+2] - F[i-2]      # below F[i+2]

=head2 Start

Optional C<i_start =E<gt> $i> can start the sequence from somewhere other
than the default i=1.  For example starting at i=0 gives value 2 at i=0,

    i_start => 0
    2, 1, 3, 4, 7, 11, 18, ...

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::LucasNumbers-E<gt>new ()>

=item C<$seq = Math::NumSeq::LucasNumbers-E<gt>new (i_start =E<gt> $i)>

Create and return a new sequence object.

=back

=head2 Iterating

=over

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

Return the C<$i>'th Lucas number.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Lucas number.

=item C<$i = $seq-E<gt>value_to_i_estimate($value)>

Return an estimate of the i corresponding to C<$value>.  See L</Value to i
Estimate> below.

=back

=head1 FORMULAS

=head2 Ith

Fibonacci F[k] and Lucas L[k] can be calculated together by a powering
algorithm with two squares per doubling,

    F[2k] = (F[k]+L[k])^2/2 - 3*F[k]^2 - 2*(-1)^k
    L[2k] =                   5*F[k]^2 + 2*(-1)^k
    
    F[2k+1] =    ((F[k]+L[k])/2)^2 + F[k]^2
    L[2k+1] = 5*(((F[k]+L[k])/2)^2 - F[k]^2) - 4*(-1)^k

The 2*(-1)^k terms mean adding or subtracting 2 according to k odd or even.
This means add or subtract according to the previous bit handled.

At the last step, which is the lowest bit of i, only L[2k] or L[2k+1] is
needed for the return, not the F[] too.

For any trailing zero bits of i the final doublings L[2k] can be done
without the F[] and with just one square as

    L[2k] = L[k]^2 - 2*(-1)^k

So

    main double/step L[],F[] until the lowest 1-bit of i is reached
    then L[2k+1] formula for that bit
    then L[2k] single squarings for any low 0-bits

=head2 Value to i Estimate

L[i] increases as a power of phi, the golden ratio,

    L[i] = phi^i + beta^i    # exactly

    phi = (1+sqrt(5))/2 = 1.618
    beta = -1/phi = -0.618

So taking a log (natural logarithm) to get i, and ignoring beta^i which
quickly becomes small since abs(beta)E<lt>1,

    log(L[i]) ~= i*log(phi)
    i ~= log(L[i]) * 1/log(phi)

Or the same using log base 2 which can be estimated from the highest bit
position of a bignum,

    log2(L[i]) ~= i*log2(phi)
    i ~= log2(L[i]) * 1/log2(phi)

This is very close to the Fibonacci formula (see
L<Math::NumSeq::Fibonacci/Value to i Estimate>), being bigger by

    Lestimate(value) - Festimate(value)
      = log(value) / log(phi) - (log(value) + log(phi-beta)) / log(phi)
      = -log(phi-beta) / log(phi)
      = -1.67

On that basis it could even be close enough to take Lestimate = Festimate-1
(or vice-versa).

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>,
L<Math::NumSeq::Pell>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2010, 2011, 2012, 2013 Kevin Ryde

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
