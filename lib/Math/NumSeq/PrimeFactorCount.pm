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

package Math::NumSeq::PrimeFactorCount;
use 5.004;
use strict;
use List::Util 'min', 'max';

use vars '$VERSION','@ISA';
$VERSION = 10;
use Math::NumSeq;
@ISA = ('Math::NumSeq');


# uncomment this to run the ### lines
#use Devel::Comments;



# cf. Untouchables, not sum of proper divisors of any other integer
# p*q sum S=1+p+q
# so sums up to hi need factorize to (hi^2)/4
# 


use constant name => Math::NumSeq::__('Count Prime Factors');
use constant description => Math::NumSeq::__('Count of prime factors.');
use constant characteristic_count => 1;
use constant characteristic_monotonic => 0;
use constant values_min => 1;
use constant i_start => 1;

use constant parameter_info_array =>
  [ { name    => 'multiplicity',
      display => Math::NumSeq::__('Multiplicity'),
      type    => 'enum',
      choices => ['repeated','distinct'],
      default => 'repeated',
      # description => Math::NumSeq::__(''),
    },
  ];

my %oeis_anum = (distinct => 'A001221',
                 repeated => 'A001222');
# OEIS-Catalogue: A001221 multiplicity=distinct
# OEIS-Catalogue: A001222 multiplicity=repeated
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'multiplicity'}};
}


sub rewind {
  my ($self) = @_;
  ### PrimeFactorCount rewind()
  $self->{'i'} = 1;
  _restart_sieve ($self, 500);

  # while ($self->{'i'} < $self->{'lo'}-1) {
  #   ### rewind advance
  #   $self->next;
  # }
}
sub _restart_sieve {
  my ($self, $hi) = @_;

  $self->{'hi'} = $hi;
  $self->{'string'} = "\0" x ($self->{'hi'}+1);
}

sub next {
  my ($self) = @_;
  ### PrimeFactorCount next() ...

  my $i = $self->{'i'}++;
  my $hi = $self->{'hi'};
  my $start = $i;
  if ($i > $hi) {
    _restart_sieve ($self, $hi *= 2);
    $start = 2;
  }

  my $cref = \$self->{'string'};
  ### $i
  my $ret;
  foreach my $i ($start .. $i) {
    $ret = vec ($$cref, $i,8);
    if ($ret == 0 && $i >= 2) {
      $ret++;
      # a prime
      for (my $power = 1; ; $power++) {
        my $step = $i ** $power;
        last if ($step > $hi);
        for (my $j = $step; $j <= $hi; $j += $step) {
          vec($$cref, $j,8) = min (255, vec($$cref,$j,8)+1);
        }
        last if $self->{'multiplicity'} eq 'distinct';
      }
      # print "applied: $i\n";
      # for (my $j = 0; $j < $hi; $j++) {
      #   printf "  %2d %2d\n", $j, vec($$cref, $j,8));
      # }
    }
  }
  ### ret: "$i, $ret"
  return ($i, $ret);
}

sub ith {
  my ($self, $i) = @_;
  ### PrimeFactorCount ith(): $i

  if ($i < 0 || $i > 0xFFFF_FFFF) {
    return undef;
  }
  my $count = 0;

  if (($i % 2) == 0) {
    $i /= 2;
    $count++;
    while (($i % 2) == 0) {
      $i /= 2;
      if ($self->{'multiplicity'} ne 'distinct') {
        $count++;
      }
    }
  }

  my $limit = int(sqrt($i));
  my $p = 3;
  while ($p <= $limit) {
    if (($i % $p) == 0) {
      $i /= $p;
      $count++;
      while (($i % $p) == 0) {
        $i /= $p;
        if ($self->{'multiplicity'} ne 'distinct') {
          $count++;
        }
      }
      $limit = int(sqrt($i));  # new smaller limit
    }
    $p += 2;
  }
  if ($i != 1) {
    $count++;
  }
  return $count;


  #   if ($self->{'i'} <= $i) {
  #     ### extend from: $self->{'i'}
  #     my $upto;
  #     while ((($upto) = $self->next)
  #            && $upto < $i) { }
  #   }
  #   return vec($self->{'string'}, $i,8);
}

sub pred {
  my ($self, $value) = @_;
  return ($value >= 0 && $value == int($value));
}

1;
__END__

=for stopwords Ryde

=head1 NAME

Math::NumSeq::PrimeFactorCount -- how many prime factors

=head1 SYNOPSIS

 use Math::NumSeq::PrimeFactorCount;
 my $seq = Math::NumSeq::PrimeFactorCount->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of how many prime factors in i, being 0, 1, 1, 2, 1, 2, etc.

The sequence starts from i=1 and that 1 is taken to have 0 prime factors.
Then i=2 and i=3 are themselves primes, so 1 prime factor.  Then i=4 is 2*2
which is 2 prime factors.

The C<multiplicity =E<gt> "distinct"> option can control whether repeats of
a prime factors are counted, or only distinct primes.  For example with
"distinct" i=4=2*2 is just 1 prime factor.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::PrimeFactorCount-E<gt>new ()>

=item C<$seq = Math::NumSeq::PrimeFactorCount-E<gt>new (multiplicity =E<gt> 'distinct')>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the number of prime factors in C<$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value E<gt>= 0>, being possible counts of prime factors
which can occur in the sequence.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Primes>,
L<Math::NumSeq::MobiusFunction>

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
