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

package Math::NumSeq::DivisorCount;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 33;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Devel::Comments;


use constant description => Math::NumSeq::__('Count of divisors of i (including 1 and i).');
use constant i_start => 1;
use constant characteristic_count => 1;
use constant characteristic_increasing => 0;


# "proper" divisors just means 1 less in each value, not sure much use for
# that.
#
# use constant parameter_info_array =>
#   [ { name    => 'divisor_type',
#       display => Math::NumSeq::__('Divisor Type'),
#       type    => 'enum',
#       choices => ['all','proper'],   # ,'propn1'
#       default => 'all',
#       # description => Math::NumSeq::__(''),
#     },
#   ];


my %values_min = (all    => 1,
                  proper => 0,
                  propn1 => 0);
sub values_min {
  my ($self) = @_;
  return 1;       # $values_min{$self->{'divisor_type'}};
}

# cf A032741 - 1 <= d < n starting n=0
#    A147588 - 1 < d < n starting n=1
#
#    A006218 - cumulative count of divisors
#    A002541 - cumulative proper divisors
#
#    A001227 - count odd divisors
#    A001826 - count 4k+1 divisors
#    A038548 - count divisors <= sqrt(n)
#    A070824 - proper divisors starting n=2
#    A002182 - number with new highest number of divisors
#    A002183 -    that count of divisors
#
sub oeis_anum {
  my ($self) = @_;
  # OEIS-Catalogue: A000005
  return 'A000005';

  # my %oeis_anum = (all    => 'A000005',  # all divisors starting n=1
  #                  # proper => 'A032741', # starts n=0 ...
  #                  # propn1 => 'A147588',
  #                 );
  # return $oeis_anum{$self->{'divisor_type'}};
}

sub rewind {
  my ($self) = @_;
  ### DivisorCount rewind()
  $self->{'i'} = 1;
  _restart_sieve ($self, 5);
}
sub _restart_sieve {
  my ($self, $hi) = @_;

  $self->{'hi'} = $hi;
  $self->{'array'} = [ 0, (1) x $self->{'hi'} ];
}

sub next {
  my ($self) = @_;
  ### DivisorCount next(): $self->{'i'}

  my $hi = $self->{'hi'};
  my $start = my $i = $self->{'i'}++;
  if ($i > $hi) {
    _restart_sieve ($self, $hi *= 2);
    $start = 2;
  }

  my $aref = $self->{'array'};
  if ($start <= $i) {
    if ($start < 2) {
      $start = 2;
    }
    foreach my $i ($start .. $i) {
      if ($aref->[$i] == 1) {
        ### apply prime: $i
        my $step = 1;
        for (my $pcount = 1; ; $pcount++) {
          $step *= $i;
          ### $step
          last if ($step > $hi);
          my $pmul = $pcount+1;
          for (my $j = $step; $j <= $hi; $j += $step) {
            ($aref->[$j] /= $pcount) *= $pmul;
          }
          # last if $self->{'divisor_type'} eq 'propn1';
        }
        # print "applied: $i\n";
        # for (my $j = 0; $j < $hi; $j++) {
        #   printf "  %2d %2d\n", $j, vec($$aref, $j,8));
        # }
      }
    }
  }
  ### ret: "$i, $aref->[$i]"
  return ($i, $aref->[$i]);
}

sub ith {
  my ($self, $i) = @_;

  $i = abs($i);
  if ($i <= 1) {
    return $i;
  }
  unless ($i <= 0xFFFF_FFFF) {
    return undef;
  }

  my $ret = 1;
  unless ($i % 2) {
    my $count = 1;
    do {
      $i /= 2;
      $count++;
    } until ($i % 2);
    $ret *= $count;
  }
  my $limit = sqrt($i);
  for (my $d = 3; $d <= $limit; $d+=2) {
    unless ($i % $d) {
      my $count = 1;
      do {
        $i /= $d;
        $count++;
      } until ($i % $d);
      $limit = sqrt($i);
      $ret *= $count;
    }
  }
  if ($i > 1) {
    $ret *= 2;
  }

  # if ($self->{'divisor_type'} eq 'propn1') {
  #   if ($ret <= 2) {
  #     return 0;
  #   }
  #   $ret -= 2;
  # }

  return $ret;
}

sub pred {
  my ($self, $value) = @_;
  return ($value >= 1 && $value == int($value));
}

1;
__END__

=for stopwords Ryde

=head1 NAME

Math::NumSeq::DivisorCount -- how many divisors

=head1 SYNOPSIS

 use Math::NumSeq::DivisorCount;
 my $seq = Math::NumSeq::DivisorCount->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The number of divisors of i, being 1,2,2,3,2,4,2, etc.

The sequence starts from i=1 and 1 is divisible only by itself.  Then i=2 is
divisible by 1 and 2.  Or for example i=6 is divisible by 4 numbers 1,2,3,6.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::DivisorCount-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the number of prime factors in C<$i>.

This calculation requires factorizing C<$i> and in the current code a hard
limit of 2**32 is placed on C<$i>, in the interests of not going into a
near-infinite loop.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs as a divisor count, which simply means
C<$value E<gt>= 1>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::PrimeFactorCount>

L<Math::Factor::XS>

=cut

# Local variables:
# compile-command: "math-image --values=DivisorCount"
# End:
