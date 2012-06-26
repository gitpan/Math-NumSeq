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

package Math::NumSeq::PrimeFactorCount;
use 5.004;
use strict;
use List::Util 'min', 'max';

use vars '$VERSION','@ISA';
$VERSION = 46;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

use Math::Prime::XS 'is_prime';
use Math::Factor::XS 'prime_factors';

# uncomment this to run the ### lines
#use Smart::Comments;



# cf. Untouchables, not sum of proper divisors of any other integer
# p*q sum S=1+p+q
# so sums up to hi need factorize to (hi^2)/4
#

use constant characteristic_count => 1;
use constant characteristic_smaller => 1;
use constant characteristic_increasing => 0;
use constant values_min => 0;
use constant i_start => 1;

use constant parameter_info_array =>
  [
   { name    => 'prime_type',
     display => Math::NumSeq::__('Prime Type'),
     type    => 'enum',
     choices => ['all','odd','4k+1','4k+3',
                 'twin','SG','safe'],
     choices_display => [Math::NumSeq::__('All'),
                         Math::NumSeq::__('Odd'),
                         # TRANSLATORS: "4k+1" meaning numbers 1,5,9,13 etc, probably no need to translate except into another script if Latin letter "k" won't be recognised
                         Math::NumSeq::__('4k+1'),
                         Math::NumSeq::__('4k+3'),
                         Math::NumSeq::__('Twin'),
                         Math::NumSeq::__('SG'),
                         Math::NumSeq::__('Safe'),
                        ],
     default => 'all',
     description => Math::NumSeq::__('The type of primes to count.
twin=P where P+2 or P-2 also prime.
SG=Sophie Germain P where 2P+1 also prime.
safe=P where (P-1)/2 also prime (the "other" of the SGs).'),
   },
   { name    => 'multiplicity',
     display => Math::NumSeq::__('Multiplicity'),
     type    => 'enum',
     choices => ['repeated','distinct'],
     choices_display => [Math::NumSeq::__('Repeated'),
                         Math::NumSeq::__('Distinct'),
                        ],
     default => 'repeated',
     description => Math::NumSeq::__('Whether to include repeated prime factors, or only distinct prime factors.'),
   },
  ];

sub description {
  my ($self) = @_;
  if (ref $self) {
    return ($self->{'multiplicity'} eq 'repeated'
            ? Math::NumSeq::__('Count of prime factors, including repetitions.')
            : Math::NumSeq::__('Count of distinct prime factors.'))
      . ($self->{'prime_type'} eq 'odd' ? "\nOdd primes only."
         : $self->{'prime_type'} eq '4k+1' ? "\nPrimes of form 4k+1 only."
         : $self->{'prime_type'} eq '4k+3' ? "\nPrimes of form 4k+3 only."
         : $self->{'prime_type'} eq 'twin' ? "\nTwin primes only."
         : $self->{'prime_type'} eq 'SG' ? "\nSophie Germain primes only (2P+1 also prime)."
         : $self->{'prime_type'} eq 'SG' ? "\nSafe primes only ((P-1)/2 also prime)."
         : "");
  } else {
    # class method
    return Math::NumSeq::__('Count of prime factors.');
  }
}

#------------------------------------------------------------------------------

my %oeis_anum = (repeated => { all    => 'A001222',
                               odd    => 'A087436',
                               '4k+1' => 'A083025',
                               '4k+3' => 'A065339',
                             },
                 distinct => { all    => 'A001221',
                               odd    => 'A005087',
                               '4k+1' => 'A005089',
                               '4k+3' => 'A005091',
                               SG     => 'A156542',
                             },
                );
# OEIS-Catalogue: A001222
# OEIS-Catalogue: A087436 prime_type=odd
# OEIS-Catalogue: A083025 prime_type=4k+1
# OEIS-Catalogue: A065339 prime_type=4k+3

# OEIS-Catalogue: A001221 multiplicity=distinct
# OEIS-Catalogue: A005087 multiplicity=distinct prime_type=odd
# OEIS-Catalogue: A005089 multiplicity=distinct prime_type=4k+1
# OEIS-Catalogue: A005091 multiplicity=distinct prime_type=4k+3
# OEIS-Catalogue: A156542 multiplicity=distinct prime_type=SG

sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'multiplicity'}}->{$self->{'prime_type'}};
}

#------------------------------------------------------------------------------

sub rewind {
  my ($self) = @_;
  ### PrimeFactorCount rewind()
  $self->{'i'} = $self->i_start;
  _restart_sieve ($self, 500);
}
sub _restart_sieve {
  my ($self, $hi) = @_;

  $self->{'hi'} = $hi;
  $self->{'string'} = "\0" x ($self->{'hi'}+1);
}

# ENHANCE-ME: maybe _primes_list() applied to block array
#
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

  my $prime_type = $self->{'prime_type'};
  my $cref = \$self->{'string'};
  ### $i
  my $ret;
  foreach my $i ($start .. $i) {
    $ret = vec ($$cref, $i,8);
    ### at: "i=$i ret=$ret"

    if ($ret == 255) {
      ### composite with no matching factors: $i
      $ret = 0;

    } elsif ($ret == 0 && $i >= 2) {
      ### prime: $i
      if ($prime_type eq 'all'
          || ($prime_type eq 'odd' && ($i&1))
          || ($prime_type eq '4k+1' && ($i&3)==1)
          || ($prime_type eq '4k+3' && ($i&3)==3)
          || ($prime_type eq 'twin' && _is_twin_prime($i))
          || ($prime_type eq 'SG' && _is_SG_prime($i))
          || ($prime_type eq 'safe' && _is_safe_prime($i))) {
        ### increment ...
        $ret++;
        for (my $step = $i; $step <= $hi; $step *= $i) {
          for (my $j = $step; $j <= $hi; $j += $step) {
            my $c = vec($$cref,$j,8);
            if ($c == 255) { $c = 0; }
            vec($$cref, $j,8) = min (255, $c+1);
          }
          last if $self->{'multiplicity'} eq 'distinct';
        }
        # print "applied: $i\n";
        # for (my $j = 0; $j < $hi; $j++) {
        #   printf "  %2d %2d\n", $j, vec($$cref, $j,8));
        # }
      } else {
        ### flag composites ...
        for (my $j = 2*$i; $j <= $hi; $j += $i) {
          unless (vec($$cref, $j,8)) {
            vec($$cref, $j,8) = 255;
          }
        }
      }
    }
  }
  ### ret: "$i, $ret"
  return ($i, $ret);
}

# prime_factors() ends up about 5x faster
#
sub ith {
  my ($self, $i) = @_;
  $i = abs($i);
  unless ($i >= 0 && $i <= 0xFFFF_FFFF) {
    return undef;
  }

  my $multiplicity = ($self->{'multiplicity'} ne 'distinct');
  my $prime_type = $self->{'prime_type'};

  my @primes = prime_factors($i);
  my $count = 0;

  while (@primes) {
    my $p = shift @primes;
    my $c = 1;
    while (@primes && $primes[0] == $p) {
      shift @primes;
      $c += $multiplicity;
    }

    if ($prime_type eq 'odd') {
      next unless $p & 1;
    } elsif ($prime_type eq '4k+1') {
      next unless ($p&3)==1;
    } elsif ($prime_type eq '4k+3') {
      next unless ($p&3)==3;
    } elsif ($prime_type eq 'twin') {
      next unless _is_twin_prime($p);
    } elsif ($prime_type eq 'SG') {
      next unless _is_SG_prime($p);
    } elsif ($prime_type eq 'safe') {
      next unless _is_safe_prime($p);

    # } elsif ($prime_type eq 'twin_first') {
    #   next unless is_prime($p+2);
    # } elsif ($prime_type eq 'twin_second') {
    #   next unless is_prime($p-2);
    }
    $count += $c;
  }

  return $count;
}

sub _is_twin_prime {
  my ($n) = @_;
  ### assert: $n >= 2
  ### assert: is_prime($n)
  return (is_prime($n+2) || is_prime($n-2));
}
sub _is_SG_prime {
  my ($n) = @_;
  ### assert: is_prime($n)
  return is_prime(2*$n+1);
}
sub _is_safe_prime {
  my ($n) = @_;
  ### assert: is_prime($n)
  return (($n&1) && is_prime(($n-1)/2));
}


# if (0 && eval '; 1') {
#   ### use prime_factors() ...
#   eval "\n#line ".(__LINE__+1)." \"".__FILE__."\"\n" . <<'HERE' or die;
# 
# 1;
# 
# HERE
# } else {
#   ### $@
#   ### use plain perl ...
#   eval "\n#line ".(__LINE__+1)." \"".__FILE__."\"\n" . <<'HERE' or die;
# 
# sub ith {
#   my ($self, $i) = @_;
#   ### PrimeFactorCount ith(): $i
# 
#   $i = abs($i);
#   unless ($i >= 0 && $i <= 0xFFFF_FFFF) {
#     return undef;
#   }
# 
#   my $prime_type = $self->{'prime_type'};
#   my $count = 0;
# 
#   if (($i % 2) == 0) {
#     $i /= 2;
#     if ($self->{'prime_type'} eq 'all') {
#       $count++;
#     }
#     while (($i % 2) == 0) {
#       $i /= 2;
#       if ($prime_type eq 'all'
#           && $self->{'multiplicity'} ne 'distinct') {
#         $count++;
#       }
#     }
#   }
# 
#   my $limit = int(sqrt($i));
#   for (my $p = 3; $p <= $limit; $p += 2) {
#     next if ($i % $p);
# 
#     $i /= $p;
#     if ($prime_type eq 'all'
#        || ($prime_type eq 'odd' && ($p&1))
#        || ($prime_type eq '4k+1' && ($p&3)==1)
#        || ($prime_type eq '4k+3' && ($p&3)==3)
#        ) {
#       $count++;
#     }
# 
#     until ($i % $p) {
#       $i /= $p;
#       if ($self->{'multiplicity'} ne 'distinct') {
#         if ($prime_type eq 'all'
#            || ($prime_type eq 'odd' && ($p&1))
#            || ($prime_type eq '4k+1' && ($p&3)==1)
#            || ($prime_type eq '4k+3' && ($p&3)==3)
#           ) {
#           $count++;
#         }
#       }
#     }
#     $limit = int(sqrt($i));  # new smaller limit
#   }
# 
#   if ($i != 1) {
#     if ($prime_type eq 'all'
#        || ($prime_type eq 'odd' && ($i&1))
#        || ($prime_type eq '4k+1' && ($i&3)==1)
#        || ($prime_type eq '4k+3' && ($i&3)==3)
#        ) {
#       $count++;
#     }
#   }
# 
#   return $count;
# 
#   #   if ($self->{'i'} <= $i) {
#   #     ### extend from: $self->{'i'}
#   #     my $upto;
#   #     while ((($upto) = $self->next)
#   #            && $upto < $i) { }
#   #   }
#   #   return vec($self->{'string'}, $i,8);
# }
# 1;
# HERE
# }

sub pred {
  my ($self, $value) = @_;
  return ($value >= 0 && $value == int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::PrimeFactorCount -- how many prime factors

=head1 SYNOPSIS

 use Math::NumSeq::PrimeFactorCount;
 my $seq = Math::NumSeq::PrimeFactorCount->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of how many prime factors in i, being

    0, 1, 1, 2, 1, 2, ...

The sequence starts from i=1 and 1 is taken to have no prime factors.  Then
i=2 and i=3 are themselves primes, so 1 prime factor.  Then i=4 is 2*2 which
is 2 prime factors.

The C<multiplicity =E<gt> "distinct"> option can control whether repeats of
a prime factors are counted, or only distinct primes.  For example with
"distinct" i=4=2*2 is just 1 prime factor.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::PrimeFactorCount-E<gt>new ()>

=item C<$seq = Math::NumSeq::PrimeFactorCount-E<gt>new (multiplicity =E<gt> $str, prime_type =E<gt> $str)>

Create and return a new sequence object.

Option C<multiplicity> is a string either

    "repeated"      count repeats of primes (the default)
    "distinct"      count only distinct primes

Option C<prime_type> is a string either

    "all"           count all primes
    "odd"           count only odd primes (ie. not 2)
    "4k+1"          count only primes 4k+1
    "4k+3"          count only primes 4k+3
    "twin"          count only twin primes
                      (P for which P+2 or P-2 also prime)
    "SG"            count only Sophie Germain primes
                      (P for which 2P+1 also prime)
    "safe"          count only "safe" primes
                      (P for which (P-1)/2 also prime)

"twin" counts both primes of each twin prime pair, so all of 3,5,7, 11,13,
17,19, etc.

=item C<$value = $seq-E<gt>ith($i)>

Return the number of prime factors in C<$i>.

This requires factorizing C<$i> and the current code has a hard limit of
2**32 on C<$i>, in the interests of not going into a near-infinite loop.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which means simply integer
C<$value E<gt>= 0>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Primes>,
L<Math::NumSeq::TwinPrimes>,
L<Math::NumSeq::SophieGermainPrimes>,
L<Math::NumSeq::LiouvilleFunction>,
L<Math::NumSeq::MobiusFunction>,
L<Math::NumSeq::PowerFlip>

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
