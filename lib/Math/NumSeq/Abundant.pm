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

package Math::NumSeq::Abundant;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 29;
use Math::NumSeq 7; # v.7 for _is_infinite()
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Abundant Numbers');
use constant description => Math::NumSeq::__('Numbers N with sum of its divisors >= N, eg. 12 is divisible by 1,2,3,4,6 total 16 is >= 12.');

use constant parameter_info_array =>
  [
   { name    => 'abundant_type',
     type    => 'enum',
     default => 'abundant',
     choices => [ 'abundant','deficient','primitive' ],
     # description => Math::NumSeq::__(''),
   },
  ];

my %values_min = (abundant  => 12,
                  deficient => 1,
                  primitive => 12,
                 );
sub values_min {
  my ($self) = @_;
  return $values_min{$self->{'abundant_type'}};
}

# cf A000396 perfect sigma(n) == 2n
#    A005231 odd abundants, starting 945
#    A091191 primitive abundants (no abundant divisor)
#    A091192 non-primitiveabundants (at least one abundant divisor)
#    A103288 sigma(n) >= 2n-1, so abundant+perfect+least deficient
#            least deficient sigma(n)==2n-1 might be only 2^k
#
my %oeis_anum = (abundant  => 'A005101',
                 deficient => 'A005100',
                 primitive => 'A091191',
                 # OEIS-Catalogue: A005101
                 # OEIS-Catalogue: A005100 abundant_type=deficient
                 # OEIS-Catalogue: A091191 abundant_type=primitive
                );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'abundant_type'}};
}


sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'done'} = 0;
  _restart_sieve ($self, 20);
}
sub _restart_sieve {
  my ($self, $hi) = @_;
  ### _restart_sieve() ...
  $self->{'hi'} = $hi;
  my $array = $self->{'array'} = [];
  $#$array = $hi;  # pre-extend
  $array->[0] = 1;
  $array->[1] = 1;
  return $array;
}

sub next {
  my ($self) = @_;
  ### Abundant next(): $self->{'i'}

  my $v = $self->{'done'};
  my $primitive = ($self->{'abundant_type'} eq 'primitive');
  my $deficient = ($self->{'abundant_type'} eq 'deficient');
  my $hi = $self->{'hi'};
  my $array = $self->{'array'};

  for (;;) {
    ### consider: "v=".($v+1)."  cf done=$self->{'done'}"
    if (++$v > $hi) {
      $array = _restart_sieve ($self,
                               $hi = ($self->{'hi'} *= 2));
      $v = 2;
      ### restart to v: $v
    }

    my $sigma = $array->[$v];
    if (defined $sigma) {
      ### composite: $v, $sigma

      if ($primitive && $sigma>2*$v) {
        for (my $j = $v; $j <= $hi; $j += $v) {
          $array->[$j] = 0;  # zap multiples of this abundant
        }
      }
      if ($v > $self->{'done'}
          && ($deficient
              ? $sigma<2*$v   # deficient
              : $sigma>2*$v)  # abundant
         ) {
        return ($self->{'i'}++,
                $self->{'done'} = $v);
      }
      # if ($] >= 5.006) {
      #   delete $array->[$v];
      # } else {
      #   undef $array->[$v];
      # }

    } else {
      ### prime: $v
      my $prev = 1;
      for (my $step = $v; $step <= $hi; $step *= $v) {
        my $this = $prev + $step;
        ### $step
        ### $prev
        ### $this
        for (my $j = $step; $j <= $hi; $j += $step) {
          ### $j
          ### before: $array->[$j]
          $array->[$j] = ($array->[$j]||1) / $prev * $this;
          ### after: $array->[$j]
        }
        $prev = $this;
      }
      # print "applied: $v\n";
      # for (my $j = 0; $j < $hi; $j++) {
      #   printf "  %2d %2d\n", $j, ($array->[$j]||0);
      # }

      if ($v > $self->{'done'}
          && $deficient) {  # primes are always deficient
        return ($self->{'i'}++,
                $self->{'done'} = $v);
      }
    }
  }
}

sub pred {
  my ($self, $value) = @_;
  ### Abundant pred(): $value
  if ($value != int($value) || _is_infinite($value)) {
    return 0;
  }
  unless ($value >= 0 && $value <= 0xFFFF_FFFF) {
    return undef;
  }

  my $abundant_type = $self->{'abundant_type'};

  my $value2 = 2 * $value;
  my $short = 1;
  my $sigma = 1;
  my $limit = sqrt($value);
  for (my $p = 2; $p <= $limit; $p += 1+($p>2)) {
    next if $value % $p;
    my $count = 0;
    do {
      $value /= $p;
      $count++;
    } while (($value % $p) == 0);
    ### $p
    ### $count
    $short = $sigma * ($p ** $count - 1) / ($p - 1);
    $sigma *= ($p ** ($count+1) - 1) / ($p - 1);
    $limit = sqrt($value);
  }
  if ($value > 1) {
    ### final prime: $value
    $short = $sigma;
    $sigma *= ($value + 1);
  }
  ### $value2
  ### $sigma
  ### $short

  if ($abundant_type eq 'deficient') {
    return $sigma < $value2;
  }
  if ($abundant_type eq 'primitive' && $short > $value2) {
    return 0;
  }

  # my @factors = Math::Factor::XS::factors($value);
  # my $sigma = List::Util::sum(1,@factors);

  return $sigma > $value2;
}

1;
__END__

=for stopwords Ryde Math-NumSeq abundants

=head1 NAME

Math::NumSeq::Abundant -- abundant numbers, greater than sum of divisors

=head1 SYNOPSIS

 use Math::NumSeq::Abundant;
 my $seq = Math::NumSeq::Abundant->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The abundant numbers, being integers greater than the sum of their divisors,

    12, 18, 20, 24, 30, 36, ...

For example 12 is abundant because its divisors 1,2,3,4,6 add up to 16 which
is E<gt> 12.

This is often expressed as 2*nE<gt>sigma(n) where sigma(n) is the sum of
divisors including n itself.

The optional C<abundant_type> parameter can select some variations,

   "abundant"     n > sum divisors (the default)
   "deficient"    n < sum divisors
   "primitive"    abundant and not a multiple of an abundant

If a number N is abundant then so are multiples 2*N, 3*N, etc.  The
"primitive" abundants are those which are not such a multiple of a smaller
abundant.

=head2 Perfect Numbers

Numbers with n == sum divisors are the perfect numbers 6, 28, 496, 8128,
33550336, etc.  There's nothing here for them currently.  They're quite
sparse, with Euler proving the even ones are n=2^(k-1)*(2^k-1) for prime
2^k-1.  And the existence of any odd perfect numbers is a famous unsolved
problem -- if there are any then they're very big.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::Abundant-E<gt>new ()>

=item C<$seq = Math::NumSeq::Abundant-E<gt>new (abundant_type =E<gt> $str)>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is abundant, deficient or primitive abundant per
C<$seq>.

This check requires factorizing C<$value> and in the current code a hard
limit of 2**32 is placed on values to be checked, in the interests of not
going into a near-infinite loop.

=back

=head1 SEE ALSO

L<Math::NumSeq>

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
