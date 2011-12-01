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

package Math::NumSeq::Primes;
use 5.004;
use strict;
use POSIX ();
use Math::Prime::XS 0.23; # version 0.23 fix for 1928099

use vars '$VERSION', '@ISA';
$VERSION = 20;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Prime Numbers');
use constant description => Math::NumSeq::__('The prime numbers 2, 3, 5, 7, 11, 13, 17, etc.');
use constant characteristic_monotonic => 2;
use constant values_min => 2;

# cf A010051 - boolean 0 or 1 according as N is prime
#                      A051006 binary fraction, in decimal
#                      A051007 binary fraction, continued fraction
#    A000720 - pi(n) num primes <= n
#
use constant oeis_anum => 'A000040'; # primes


use constant 1.02;  # for leading underscore
use constant _MAX_PRIME_XS => do {
  my $umax = POSIX::UINT_MAX() / 2;
  # if ($umax > 0x8000_0000) {
  #   $umax = 0x8000_0000;
  # }
  $umax;
};

sub rewind {
  my ($self) = @_;
  $self->{'i'} = 1;
  $self->{'array_lo'} = 1;
  $self->{'array_hi'} = 1;
  @{$self->{'array'}} = ();
}

sub next {
  my ($self) = @_;

  while (! @{$self->{'array'}}) {
    # fill array
    my $lo = $self->{'array_lo'};
    my $hi = $self->{'array_hi'};

    $lo = $self->{'array_lo'} = $hi+1;
    if ($lo > _MAX_PRIME_XS) {
      return;
    }

    my $len = int ($lo / 2);
    if ($len > 100_000) {
      $len = 100_000;
    }

    $hi = $lo + $len;
    if ($hi < 500) {
      $hi = 500;
    }
    if ($hi > _MAX_PRIME_XS) {
      $hi = _MAX_PRIME_XS;
    }
    $self->{'array_hi'} = $hi;

    @{$self->{'array'}} = _primes_list ($lo, $hi);
  }
  return ($self->{'i'}++, shift @{$self->{'array'}});
}

sub _primes_list {
  my ($lo, $hi) = @_;
  ### _my_primes_list: "$lo to $hi"
  if ($lo < 0) {
    $lo = 0;
  }
  if ($hi > _MAX_PRIME_XS) {
    $hi = _MAX_PRIME_XS;
  }

  if ($hi < $lo) {
    # Math::Prime::XS errors out if hi<lo
    return;
  }
  return Math::Prime::XS::sieve_primes ($lo, $hi);
}

sub pred {
  my ($self, $value) = @_;
  return ($value == int($value)
          && ! _is_infinite($value)
          && $value <= 0xFFFF_FFFF
          && ($value == 2 || ($value % 2))
          && ($value == 3 || ($value % 3))
          && ($value == 5 || ($value % 5))
          && Math::Prime::XS::is_prime($value));
}

# sub ith {
#   my ($self, $i) = @_;
#   my $array = $self->{'array'};
#   if ($i > $#$array) {
#     my $hi = int ($i/log($i) * 2 + 5);
#     do {
#       $array = $self->{'array'} = [ undef, _my_primes_list (0, $hi) ];
#       $hi *= 2;
#     } while ($i > $#$array);
#   }
#   return $array->[$i];
# }

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Primes -- prime numbers

=head1 SYNOPSIS

 use Math::NumSeq::Primes;
 my $seq = Math::NumSeq::Primes->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The prime numbers, 2, 3, 5, 7, 11, 13, etc, not divisible by anything except
themselves and 1.

Currently this is implemented with C<Math::Prime::XS> generating blocks of
primes for the iteration with a sieve of Eratosthenes.  The result is
reasonably progressive.  On a 32-bit system there's a hard limit at 2^31
(though even approaching that takes a long time to calculate).

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Primes-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a prime.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::TwinPrimes>,
L<Math::NumSeq::SophieGermainPrimes>,
L<Math::NumSeq::Emirps>

L<Math::Prime::XS>,
L<Math::Prime::TiedArray>

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
