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

package Math::NumSeq::LucasNumbers;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 44;
use Math::NumSeq::Base::Sparse;
@ISA = ('Math::NumSeq::Base::Sparse');

use Math::NumSeq;
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Fibonacci;
*_blog2_estimate = \&Math::NumSeq::Fibonacci::_blog2_estimate;
*_bits_high_to_low = \&Math::NumSeq::Fibonacci::_bits_high_to_low;


# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Lucas Numbers');
use constant description => Math::NumSeq::__('Lucas numbers 1, 3, 4, 7, 11, 18, 29, etc, being L(i) = L(i-1) + L(i-2) starting from 1,3.  This is the same recurrence as the Fibonacci numbers, but a different starting point.');

use constant values_min => 1;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;
use constant i_start => 1;

#------------------------------------------------------------------------------
# cf A000285 starting 1,4
#    A022086 starting 0,3
#    A022087 starting 0,4
#    A022095 starting 1,5
#    A022130 starting 4,9
#    
use constant oeis_anum => 'A000204'; # lucas starting at 1,3,...

#------------------------------------------------------------------------------

sub rewind {
  my ($self) = @_;
  ### LucasNumbers rewind() ...
  $self->{'f0'} = 1;
  $self->{'f1'} = 3;
  $self->{'i'} = $self->i_start;
}
# sub _UNTESTED__seek_to_i {
#   my ($self, $i) = @_;
#   $self->{'i'} = $i;
#   if ($i >= $uv_i_limit) {
#     $i = Math::NumSeq::_to_bigint($i);
#   }
#   ($self->{'f0'}, $self->{'f1'}) = $self->ith_pair($i);
# }

# the biggest f0 for which both f0 and f1 fit into a UV, and which therefore
# for the next step will require BigInt
#
my $uv_limit = do {
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
  my $f1 = 3;
  my $prev_f0;
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

# ENHANCE-ME: powering ...
sub ith {
  my ($self, $i) = @_;
  ### LucasNumbers ith(): $i

  if ($i <= 1 || _is_infinite($i)) {
    return $i;
  }

  if ($i == 0) {
    return $i;
  }

  my @bits = _bits_high_to_low($i);
  ### @bits

  my $lowzeros = 0;
  until (pop @bits) {
    $lowzeros++;
  }

  # k=1, L[1]=1
  my $Lk = ($i * 0) + 1;  # inherit bignum 1
  my $add = -2; # 2*(-1)^k

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
    return $blog2 / (log(_PHI)/log(2));
  }
  # i ~= log(L(i)) / log(phi)
  return int(log($value) / log(_PHI));
}

1;
__END__

=for stopwords Ryde Math-NumSeq Ith ie doublings bignum Lestimate Festimate
MERCHANTABILITY

=head1 NAME

Math::NumSeq::LucasNumbers -- Lucas numbers

=head1 SYNOPSIS

 use Math::NumSeq::LucasNumbers;
 my $seq = Math::NumSeq::LucasNumbers->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Lucas numbers 1, 3, 4, 7, 11, 18, 29, etc, being L(i) = L(i-1) + L(i-2)
starting from 1,3.  This is the same recurrence as the Fibonacci numbers,
but a different starting point.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::LucasNumbers-E<gt>new ()>

Create and return a new sequence object.

=item C<($i, $value) = $seq-E<gt>next()>

Return the next index and value in the sequence.

When C<$value> exceeds the range of a Perl unsigned integer the return is a
C<Math::BigInt> to preserve precision.

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

At the last step, ie. the lowest bit of i, only L[2k] or L[2k+1] needs to be
calculated for the return, not the F[] too.

For any trailing zero bits of i, final doublings L[2k] can also be done with
just one square as

    L[2k] = L[k]^2 - 2*(-1)^k

The main double/step formulas can be applied until the lowest 1-bit of i is
reached, then the L[2k+1] formula for that bit, followed by the single
squaring for any trailing 0-bits.

=head2 Value to i Estimate

L[i] increases as a power of phi, the golden ratio,

    L[i] = phi^i + beta^i    # exactly

So taking a log (natural logarithm) to get i, and ignoring beta^i which
quickly becomes small,

    log(L[i]) ~= i*log(phi)
    i ~= log(L[i]) / log(phi)

Or the same using log base 2 which can be estimated from the highest bit
position of a bignum,

    log2(L[i]) ~= i*log2(phi)
    i ~= log2(L[i]) / log2(phi)

This is very close to the Fibonacci formula (see
L<Math::NumSeq::Fibonacci/Value to i Estimate>), being bigger by

    Lestimate(value) - Festimate(value)
      = log(value) / log(phi) - (log(value) + log(phi-beta)) / log(phi)
      = -log(phi-beta) / log(phi)
      = -1.67

On that basis, it could be close enough to take Lestimate = Festimate-1 (or
vice-versa) and share code between the two.

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Fibonacci>

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
