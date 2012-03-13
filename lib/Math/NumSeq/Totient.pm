# Copyright 2011, 2012 Kevin Ryde

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


package Math::NumSeq::Totient;
use 5.004;
use strict;
use Math::Factor::XS 0.39 'prime_factors'; # version 0.39 for prime_factors()

use vars '$VERSION', '@ISA';
$VERSION = 36;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


use constant description => Math::NumSeq::__('Totient function, the count of how many numbers coprime to N.');
use constant characteristic_count => 1;
use constant characteristic_smaller => 1;
use constant characteristic_increasing => 0;
use constant values_min => 1;
use constant i_start => 1;

# cf A007617 non-totients, all odds, plus evens per A005277
#    A005277 even non-totients, n s.t. n==phi(something) no solution
#    A058980 non-totients 0mod4

# Dressler (1970) N(x) = num phi(n)<=x, then N(x)/x -> A
# A = zeta(2)*zeta(3)/zeta(6) = product primes 1+1/(p*(p-1))
#
# 2p is a non-totient if 2p+1 composite (p not an S-G prime)
# 4p is a non-totient iff 2p+1 and 4p+1 both composite
# if n non-totient and 2n+1 composite then 2n also non-totient
#
use constant oeis_anum => 'A000010';

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, _totient_by_sieve($self,$i));
}

sub _totient_by_sieve {
  my ($self, $i) = @_;
  ### _totient_by_sieve(): $i

  if ($i < 2) {
    return $i;
  }

  my $array = $self->{'array'};
  if (! $array || $i > $#$array) {
    $array = $self->{'array'} = [ 0 .. 2*$i ];
    $self->{'sieve_done'} = 1;
  }
  if ($self->{'sieve_done'} < $i) {
    ### extend past done: $self->{'sieve_done'}

    my $done = $self->{'sieve_done'};
    do {
      $done++;
      if ($array->[$done] == $done) {
        ### prime: $done
        for (my $m = $done; $m <= $#$array; $m += $done) {
          ### array change: $m.' from '.$array->[$m].' to '.($array->[$m] / $done) * ($done-1)
          ($array->[$m] /= $done) *= $done-1;
        }
      }
    } while ($done < $i);
    $self->{'sieve_done'} = $done;
    ### done now: $done
    ### array now: $array
  }
  my $ret = $self->{'array'}->[$i];
  return $ret - ($ret == $i);  # 1 less if a prime
}

sub ith {
  my ($self, $i) = @_;
  ### Totient ith(): $i

  if (_is_infinite($i)) {
    return $i;
  }
  if ($i < 0 || $i > 0xFFFF_FFFF) {
    return undef;
  }

  my $prev = 0;
  my $ret = 1;
  foreach my $p (prime_factors($i)) {
    if ($p == $prev) {
      $ret *= $p;
    } else {
      $ret *= $p - 1;
      $prev = $p;
    }
  }
  return $ret;
}

# ENHANCE-ME: identify totients/non-totients
# sub pred {
#   my ($self, $value) = @_;
#   ### Totient pred(): $value
# }

# sub _totient {
#   my ($x) = @_;
#   my $count = (($x >= 1)                    # y=1 always
#                + ($x > 2 && ($x&1))         # y=2 if $x odd
#                + ($x > 3 && ($x % 3) != 0)  # y=3
#                + ($x > 4 && ($x&1))         # y=4 if $x odd
#               );
#   for (my $y = 5; $y < $x; $y++) {
#     $count += _coprime($x,$y);
#   }
#   return $count;
# }
# sub _coprime {
#   my ($x, $y) = @_;
#   #### _coprime(): "$x,$y"
#   if ($y > $x) {
#     return 0;
#   }
#   for (;;) {
#     if ($y <= 1) {
#       return ($y == 1);
#     }
#     ($x,$y) = ($y, $x % $y);
#   }
# }

1;
__END__

=for stopwords Ryde Math-NumSeq Euler's totient coprime coprimes

=head1 NAME

Math::NumSeq::Totient -- Euler's totient function, count of coprimes

=head1 SYNOPSIS

 use Math::NumSeq::Totient;
 my $seq = Math::NumSeq::Totient->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

Euler's totient function, being the count of integers coprime to i, starting
i=1,

    1, 1, 2, 2, 4, 2, 6, 4, etc

For example i=6 has no common factor with 1 or 5, so the totient is 2.

The totient can be calculated from the prime factorization by changing one
copy of each distinct prime p to p-1.

    totient(n) =        product          (p-1) * p^(e-1)
                  prime factors p^e in n

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::Totient-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return totient(i).

This requires factorizing C<$i> and in the current code a hard limit of
2**32 is placed on C<$i>, in the interests of not going into a near-infinite
loop.  Above that the return is C<undef>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::TotientCumulative>,
L<Math::NumSeq::TotientPerfect>,
L<Math::NumSeq::TotientSteps>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011, 2012 Kevin Ryde

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
