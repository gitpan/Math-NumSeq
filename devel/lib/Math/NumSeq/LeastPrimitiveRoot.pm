# Copyright 2012 Kevin Ryde

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

package Math::NumSeq::LeastPrimitiveRoot;
use 5.004;
use strict;
use Math::Factor::XS 0.39 'prime_factors'; # version 0.39 for prime_factors()

use vars '$VERSION', '@ISA';
$VERSION = 51;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Primes;
use Math::NumSeq::Squares;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
use constant description => Math::NumSeq::__('The first primitive root modulo i.');
use constant default_i_start => 3;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;

use constant parameter_info_array =>
  [ { name        => 'root_type',
      type        => 'enum',
      display     => Math::NumSeq::__('Negative'),
      default     => 'positive',
      choices     => ['positive','negative'],
      description => Math::NumSeq::__('Which primitive root to return, the least positive or the least negative.'),
    },
  ];


my %values_min = (positive => 2);
sub values_min {
  my ($self) = @_;
  return $values_min{$self->{'root_type'}};
}
my %values_max = (negative => -1);
sub values_max {
  my ($self) = @_;
  return $values_max{$self->{'root_type'}};
}


#------------------------------------------------------------------------------
# cf A001918 - least primitive root of prime
#    A002199 - least negative primitive root of a prime, as a positive
#    A071894 - largest primitive root of prime
#
#    A002230 - primes with new record least primitive root
#    A114885 - prime index of those primes
#    A002231 - the record root
#
#    A002233 - least primitive root of prime which is also a prime
#    A122028 - similar
#
#    A001122 - primes with 2 as primitive root
#    A001913 - primes with 10 as primitive root
#    A019374 - primes with 50 as primitive root
#    A060749 - list of primitive roots of each prime
#
#    A002371 - period of repeating part of 1/prime(n), 0 for 2,5
#    A048595 - period of repeating part of 1/prime(n), 1 for 2,5
#    A060283 - repeating part of 1/prime(n)
#    A060251 - repeating part of n/prime(n)
#    A006559 - primes 1/p has 0 < period < p-1, so not max length
#    A001914 - cyclic 10 is a quad residue mod p and mantissa class 2

# use constant oeis_anum => '';


#------------------------------------------------------------------------------

sub ith {
  my ($self, $i) = @_;
  ### LeastPrimitiveRoot ith(): $i

  if (_is_infinite($i)) {
    return undef;
  }
  if ($i < 0 || $i > 0xFFFF_FFFF) {
    return undef;
  }

  if ($self->{'root_type'} eq 'positive') {
    for (my $root = 2; $root < $i; $root++) {
      if (_is_primitive_root ($root, $i)) {
        return $root;
      }
    }
  } else {
    for (my $root = -1; $root > -$i; $root--) {
      ### try: $root
      if (_is_primitive_root ($root, $i)) {
        return $root;
      }
    }
  }
  return 1;
}

# sub pred {
#   my ($self, $value) = @_;
#   ### LeastPrimitiveRoot pred(): "$value"
#   return (Math::NumSeq::Primes->pred($value)
#           && _is_primitive_root ($self->{'radix'}, $value));
# }

sub _is_primitive_root {
  my ($base, $modulus) = @_;

  if (_is_infinite($modulus)) {
    return undef;
  }
  if ($modulus < 2) {
    return 0;
  }

  my $exponent = $modulus - 1;
  my @primes = prime_factors($exponent);
  my $prev_p = 0;
  while (defined (my $p = shift @primes)) {
    next if $p == $prev_p;
    $prev_p = $p;

    ### $p
    ### div: $exponent/$p
    ### powmod: _powmod($base, $exponent/$p, $modulus)

    if (_powmod($base, $exponent/$p, $modulus) <= 1) {
      return 0;
    }
  }

  # my $power = $base;
  # foreach (1 .. $value-2) {
  #   $power %= $value;
  #   if ($power == 1) {
  #     ### no, at: $_
  #     return 0;
  #   }
  #   $power *= $base;
  # }

  return 1;
}

sub _powmod {
  my ($base, $exponent, $modulus) = @_;

  my @exponent = _bits_high_to_low($exponent)
    or return 1;

  my $power = $base % $modulus;
  shift @exponent; # high 1 bit

  while (defined (my $bit = shift @exponent)) {  # high to low
    $power *= $power;
    $power %= $modulus;
    if ($bit) {
      $power *= $base;
      $power %= $modulus;
    }
  }
  return $power;
}

sub _bits_high_to_low {
  my ($n) = @_;
  # ### _bits_high_to_low(): "$n"

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

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::LeastPrimitiveRoot -- smallest primitive root

=head1 SYNOPSIS

 use Math::NumSeq::LeastPrimitiveRoot;
 my $seq = Math::NumSeq::LeastPrimitiveRoot->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

I<In progress ...>

This is ...

    starting i=1
    3, 3, 5, 4, 4, 3, 5, 5, 4, 3, 6, 6, 8, 8, 7, 7, 9, 8, 8, ...

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::LeastPrimitiveRoot-E<gt>new ()>

Create and return a new sequence object.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the first primitive root to modulus C<$i>.

=item C<$i = $seq-E<gt>i_start ()>

Return 1, the first term in the sequence being at i=1.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::LongFractionPrimes>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2012 Kevin Ryde

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
