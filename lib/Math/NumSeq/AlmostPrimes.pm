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

package Math::NumSeq::AlmostPrimes;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 14;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

use Math::NumSeq::Primes;
use Math::NumSeq::Primorials;

# uncomment this to run the ### lines
#use Devel::Comments;

use constant description => Math::NumSeq::__('Products of a fixed number of primes, default the semi-primes, 4, 6, 9, 10, 14 15, etc with just two prime factors P*Q.');
use constant characteristic_monotonic => 2;

use constant parameter_info_array =>
  [
   { name    => 'factor_count',
     display => Math::NumSeq::__('Factor Count'),
     type    => 'integer',
     default => 2,
     minimum => 2,
     width   => 2,
     description => Math::NumSeq::__('How many prime factors to include.'),
   },
   { name    => 'multiplicity',
     display => Math::NumSeq::__('Multiplicity'),
     type    => 'enum',
     choices => ['repeated','distinct'],
     default => 'repeated',
     # description => Math::NumSeq::__(''),
   }
  ];

# cf A068318 - sum of the prime factors of the nth semiprime
#
my %oeis_anum = (repeated => [ undef,
                               undef,
                               'A001358',  # 2 with repeats
                               'A014612',  # 3 with repeats
                               'A014613',  # 4 with repeats
                               'A014614',  # 5 with repeats
                               # OEIS-Catalogue: A001358
                               # OEIS-Catalogue: A014612 factor_count=3
                               # OEIS-Catalogue: A014613 factor_count=4
                               # OEIS-Catalogue: A014614 factor_count=5
                             ],
                 distinct => [ undef,
                               undef,
                               'A006881', # 2 distinct primes
                               # OEIS-Catalogue: A006881 multiplicity=distinct
                             ],
                );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'multiplicity'}}->[$self->{'factor_count'}];
}

sub values_min {
  my ($self) = @_;
  my $factor_count = $self->{'factor_count'};
  if ($self->{'multiplicity'} eq 'distinct') {
    return Math::NumSeq::Primorials->ith($factor_count);
  } else {
    return 2 ** $factor_count;
  }
}

sub rewind {
  my ($self) = @_;
  $self->{'i'} = 1;
  $self->{'done'} = 1;
  $self->{'hi'} = 0;
  $self->{'pending'} = [];
}

sub next {
  my ($self) = @_;

  my $done = $self->{'done'};
  my $pending = $self->{'pending'};

  for (;;) {
    ### $done
    if (@$pending) {
      ### ret: $self->{'i'}, $pending->[0]
      return ($self->{'i'}++,
              ($self->{'done'} = shift @$pending));
    }

    ### refill pending ...

    my $factor_count = $self->{'factor_count'};
    my $distinct = ($self->{'multiplicity'} eq 'distinct');
    ### $factor_count
    ### $distinct

    my $hi = $self->{'hi'} = ($self->{'hi'} == 0
                              ? 500 + $self->values_min
                              : $self->{'hi'} * 2);
    my $primes_hi = int ($hi / ($distinct
                                ? Math::NumSeq::Primorials->ith($factor_count-1)
                                : 2 ** ($factor_count-1)));
    ### $hi
    ### $primes_hi

    require Math::NumSeq::Primes;
    my @primes = Math::NumSeq::Primes::_primes_list (0, $primes_hi);
    if (@primes < ($distinct ? $factor_count : 1)) {
      ### not enough primes, go bigger ...
      next;
    }

    my @prev_pos = ($distinct
                    ? (0 .. $factor_count-2)
                    : ((0) x ($factor_count-1)));
    my @prev_prod;
    my $prod = 1;
    foreach my $k (0 .. $#prev_pos) {
      $prev_prod[$k] = ($prod *= $primes[$prev_pos[$k]]);
    }
    ### @prev_pos
    ### @prev_prod

    my $pos = $prev_pos[-1] + $distinct;
    if ($prod * $primes[$pos] > $hi) {
      ### minimum product past hi, go bigger ...
      next;
    }

    @$pending = ();

  OUTER: for (;;) {
      ### outer ...
      ### $pos
      ### pos prime: $primes[$pos]
      ### prev_prod: $prev_prod[-1]
      ### this prod: $prev_prod[-1] * ($primes[$pos]||0)

      if ($pos <= $#primes
          && (($prod = $prev_prod[-1] * $primes[$pos]) <= $hi)) {
        ### found: $prod
        if ($prod > $done) {
          push @$pending, $prod;
        }
        if (++$pos < @primes) {
          next;
        }
      }

      ### backtrack ...
      ### $prod
      ### @prev_pos
      ### @prev_prod

      my $k = $#prev_pos;
      for (;;) {
        $pos = ++$prev_pos[$k];
        ### $k
        ### increment to pos: $pos

        if ($pos > $#primes) {
          ### pos past primes list ...
          if (--$k < 0) { last OUTER; }
          next;
        }
        $prod = $primes[$pos];
        if ($k > 0) {
          $prod *= $prev_prod[$k-1];
          if ($prod > $hi) {
            ### prod bigger than hi ...
            if (--$k < 0) { last OUTER; }
            next;
          }
        }

        ### forward ...
        ### set prev_prod: $prod

        $prev_prod[$k] = $prod;
        $pos += $distinct;
        if (++$k >= @prev_prod) {
          ### outer with prod: $prod
          next OUTER;
        }
        $prev_pos[$k] = $pos - 1;
        ### new prev_pos: $prev_pos[$k]
        ### which is prime: $primes[$prev_pos[$k]]
      }
    }
    @$pending = sort {$a<=>$b} @$pending;
  }
}

sub pred {
  my ($self, $value) = @_;
  ### AlmostPrimes pred(): $value

  if ($value < 0 || $value > 0xFFFF_FFFF) {
    return undef;
  }
  if ($value < 1 || $value != int($value)) {
    return 0;
  }
  my $factor_count = $self->{'factor_count'};
  my $distinct = ($self->{'multiplicity'} eq 'distinct');

  my $seen_count = 0;

  unless ($value % 2) {
    ### even ...
    $value /= 2;
    $seen_count = 1;
    until ($value % 2) {
      $value /= 2;
      if ($seen_count++ > $factor_count || $distinct) {
        return 0;
      }
      ### $seen_count
    }
  }

  my $limit = int(sqrt($value));
  for (my $p = 3; $p <= $limit; $p += 2) {
    unless ($value % $p) {
      $value /= $p;
      if ($seen_count++ > $factor_count) {
        return 0;
      }
      until ($value % $p) {
        $value /= $p;
        if ($seen_count++ > $factor_count || $distinct) {
          return 0;
        }
      }

      $limit = int(sqrt($value));  # new smaller limit
    }
  }
  if ($value != 1) {
    $seen_count++
  }
  ### final seen_count: $seen_count
  return ($seen_count == $factor_count);
}

1;
__END__


=for stopwords Ryde Math-NumSeq semiprimes

=head1 NAME

Math::NumSeq::AlmostPrimes -- semiprimes and other fixed number of prime factors

=head1 SYNOPSIS

 use Math::NumSeq::AlmostPrimes;
 my $seq = Math::NumSeq::AlmostPrimes->new (factor_count => 2);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of numbers having a given number of prime factors.  The default
is the semiprimes C<factor_count =E<gt> 2> giving products of two primes
P*Q, which is 4,6,9,10,14,15,etc.  For example 15 because 15=3*5.

C<factor_count =E<gt> $c> controls how many prime factors are to be used.
1 is the primes themselves (the same as L<Math::NumSeq::Primes>).  Or for
example factor count 4 the sequence is 16,24,36,40,54,60,etc,
eg. 60=2*2*3*5.

C<multiplicity =E<gt> 'distinct'> asks for products of distinct primes.  For
the default 2 factors this means no squares like 4=2*2, leaving
6,10,14,15,21,etc.  For other factor count it eliminates any repeated
factors, so for example factor count 4 becomes 210,330,390,462,510,546,etc.
The first in the sequence is the primorial 2*3*5*7=210.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::AlmostPrimes-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is an almost-prime, ie. it has exactly
C<factor_count> many prime factors, and if C<distinct> is true then all
those factors different..

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Primes>,
L<Math::NumSeq::PrimeFactorCount>

L<Math::NumSeq::Primorials>

=cut

# Local variables:
# compile-command: "math-image --values=AlmostPrimes"
# End:
