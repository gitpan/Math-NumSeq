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
$VERSION = 31;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

use Math::Factor::XS 'prime_factors';

# uncomment this to run the ### lines
#use Smart::Comments;



# cf. Untouchables, not sum of proper divisors of any other integer
# p*q sum S=1+p+q
# so sums up to hi need factorize to (hi^2)/4
#

use constant description => Math::NumSeq::__('Count of prime factors.');
use constant characteristic_increasing => 0;
use constant characteristic_count => 1;
use constant characteristic_integer => 1;
use constant values_min => 0;
use constant i_start => 1;

use constant parameter_info_array =>
  [
   { name    => 'prime_type',
     display => Math::NumSeq::__('Prime Type'),
     type    => 'enum',
     choices => ['all','odd','4k+1','4k+3'],
     default => 'all',
     # description => Math::NumSeq::__(''),
   },
   { name    => 'multiplicity',
     display => Math::NumSeq::__('Multiplicity'),
     type    => 'enum',
     choices => ['repeated','distinct'],
     default => 'repeated',
     # description => Math::NumSeq::__(''),
   },
  ];

# A156542 count S-G
my %oeis_anum = (distinct => { all    => 'A001221',
                               odd    => 'A005087',
                               '4k+1' => 'A005089',
                               '4k+3' => 'A005091',
                             },
                 repeated => { all    => 'A001222',
                               odd    => 'A087436',
                               '4k+1' => 'A083025',
                               '4k+3' => 'A065339',
                             },
                );
# OEIS-Catalogue: A001221 multiplicity=distinct
# OEIS-Catalogue: A005087 multiplicity=distinct prime_type=odd
# OEIS-Catalogue: A005089 multiplicity=distinct prime_type=4k+1
# OEIS-Catalogue: A005091 multiplicity=distinct prime_type=4k+3
# OEIS-Catalogue: A001222
# OEIS-Catalogue: A087436 prime_type=odd
# OEIS-Catalogue: A083025 prime_type=4k+1
# OEIS-Catalogue: A065339 prime_type=4k+3

sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'multiplicity'}}->{$self->{'prime_type'}};
}


sub rewind {
  my ($self) = @_;
  ### PrimeFactorCount rewind()
  $self->{'i'} = 1;
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
          || ($prime_type eq '4k+3' && ($i&3)==3)) {
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

    # } elsif ($prime_type eq 'twin_either') {
    #   next unless is_prime($p-2) || is_prime($p+2);
    # } elsif ($prime_type eq 'twin_first') {
    #   next unless is_prime($p+2);
    # } elsif ($prime_type eq 'twin_second') {
    #   next unless is_prime($p-2);
    # } elsif ($prime_type eq 'SG') {
    #   next unless is_prime(2*$p+1);
    # } elsif ($prime_type eq 'safe') {
    #   next unless ($p&1) && is_prime(($p-1)/2);

    }
    $count += $c;
  }

  return $count;
}


# if (0 && eval '; 1') {
#   ### use prime_factors() ...
#   eval "#line ".(__LINE__+1)." \"".__FILE__."\"\n" . <<'HERE' or die;
# 
# 1;
# 
# HERE
# } else {
#   ### $@
#   ### use plain perl ...
#   eval "#line ".(__LINE__+1)." \"".__FILE__."\"\n" . <<'HERE' or die;
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

This requires factorizing C<$i> and in the current code a hard limit of
2**32 is placed on C<$i>, in the interests of not going into a near-infinite
loop.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which means simply C<$value
E<gt>= 0>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Primes>,
L<Math::NumSeq::LiouvilleFunction>,
L<Math::NumSeq::MobiusFunction>

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
