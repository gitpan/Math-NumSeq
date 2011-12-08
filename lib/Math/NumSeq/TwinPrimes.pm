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

package Math::NumSeq::TwinPrimes;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 21;

use Math::NumSeq::Primes;
@ISA = ('Math::NumSeq::Primes');

# uncomment this to run the ### lines
#use Devel::Comments;


# use constant name => Math::NumSeq::__('Twin Primes');
use constant description => Math::NumSeq::__('The twin primes, 3, 5, 7, 11, 13, being numbers where both K and K+2 are primes.');
use constant characteristic_monotonic => 2;
use constant parameter_info_array =>
  [
   { name    => 'pairs',
     display => Math::NumSeq::__('Pairs'),
     type    => 'enum',
     default => 'first',
     choices => ['first','second','both','average'],
     choices_display => [Math::NumSeq::__('First'),
                         Math::NumSeq::__('Second'),
                         Math::NumSeq::__('Both'),
                         Math::NumSeq::__('Average')],
     description => Math::NumSeq::__('Which of a pair of values to show.'),
   },
  ];

my %values_min = (first   => 3,
                  second  => 5,
                  both    => 3,
                  average => 4);
sub values_min {
  my ($self) = @_;
  return $values_min{$self->{'pairs'}};
}

# cf A077800 both, with repetition, so 3,5, 5,7, 11,13, ...
#
my %oeis_anum = (
                 first  => 'A001359',
                 # OEIS-Catalogue: A001359 pairs=first

                 second => 'A006512',
                 # OEIS-Catalogue: A006512 pairs=second

                 both   => 'A001097', # both, without repetition
                 # OEIS-Catalogue: A001097 pairs=both

                 average => 'A014574', # average
                 # OEIS-Catalogue: A014574 pairs=average
                );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'pairs'}};
}

my %pairs_add = (first => 0,
                 average => 1,
                 second => 2,
                 both => 0);

sub rewind {
  my ($self) = @_;
  ### TwinPrimes rewind() ...

  $self->SUPER::rewind;
  $self->{'twin_i'} = 0;
  $self->{'twin_both'} = 0;
  (undef, $self->{'twin_prev'}) = $self->SUPER::next;
  ### $self
}

sub next {
  my ($self) = @_;
  ### TwinPrimes next(): "twin_i=$self->{'twin_i'} prev=$self->{'twin_prev'}"
  my $prev = $self->{'twin_prev'};

  for (;;) {
    (undef, my $prime) = $self->SUPER::next
      or return;

    if ($prime == $prev + 2) {
      my $pairs = $self->{'pairs'};
      $self->{'twin_prev'} = $prime;
      $self->{'twin_both'} = ($pairs eq 'both');
      return (++$self->{'twin_i'}, $prev + $pairs_add{$pairs})

    } elsif ($self->{'twin_both'}) {
      $self->{'twin_prev'} = $prime;
      $self->{'twin_both'} = 0;
      return (++$self->{'twin_i'}, $prev);
    }
    $prev = $prime;
  }
}

my %pairs_other = (first => 2,
                   average => 1,
                   second => 0);
sub pred {
  my ($self, $value) = @_;
  if ((my $pairs = $self->{'pairs'}) eq 'both') {
    return ($self->SUPER::pred ($value)
            && ($self->SUPER::pred ($value + 2)
                || $self->SUPER::pred ($value - 2)));
  } else {
    return ($self->SUPER::pred ($value - $pairs_add{$pairs})
            && $self->SUPER::pred ($value + $pairs_other{$pairs}));
  }
}

1;
__END__


# use List::Util 'min', 'max';

# sub new {
#   my ($class, %options) = @_;
#   my $lo = $options{'lo'} || 0;
#   my $hi = $options{'hi'};
#   $lo = max ($lo, 3);  # start from 3
#   my $pairs = $options{'pairs'} || $class->parameter_default('pairs');
#
#   my $primes_lo = $lo - ($pairs eq 'second' ? 2 : 0);
#   require Math::NumSeq::Primes;
#   my @array = Math::NumSeq::Primes::_primes_list
#     ($primes_lo, $hi+2);
#
#   my $to = 0;
#   my $offset = ($pairs eq 'second');
#   my $inc = ($pairs eq 'average');
#   ### $pairs
#   ### $offset
#
#   for (my $i = 0; $i < $#array; $i++) {
#     if ($array[$i]+2 == $array[$i+1]) {
#       if ($pairs eq 'both') {
#         $array[$to++] = $array[$i];  # first of pair
#         do {
#           $array[$to++] = $array[++$i];
#         } while ($i < $#array && $array[$i]+2 == $array[$i+1]);
#       } else {
#         $array[$to++] = $array[$i+$offset] + $inc;
#       }
#     }
#   }
#   while ($to > 0 && $array[$to-1] > $hi) {
#     $to--;
#   }
#   $#array = $to - 1;
#
#   return $class->SUPER::new (%options,
#                              array => \@array);
# }


=for stopwords Ryde Math-NumSeq ie

=head1 NAME

Math::NumSeq::TwinPrimes -- twin primes

=head1 SYNOPSIS

 use Math::NumSeq::TwinPrimes;
 my $seq = Math::NumSeq::TwinPrimes->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The twin primes 3, 5, 11, 19, 29, etc, where both P and P+2 are primes.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::TwinPrimes-E<gt>new ()>

=item C<$seq = Math::NumSeq::TwinPrimes-E<gt>new (pairs =E<gt> 'second')>

Create and return a new sequence object.  The optional C<pairs> parameter (a
string) controls which of each twin-prime pair of values is returned

    "first"      the first of each pair, 3,5,11,17 etc
    "second"     the second of each pair 5,7,13,19 etc
    "both"       both values 3,5,7,11,13,17,19 etc
    "average"    the average of the pair, 4,6,12,8 etc

"both" is without repetition, so for example 5 belongs to the pair 3,5 and
5,7, but is returned in the sequence just once.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a twin prime of the given C<pairs> type.  For
example with "second" C<pred()> returns true when C<$value> is the second of
a pair, ie. C<$value-2> is also a prime.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Primes>,
L<Math::NumSeq::SophieGermainPrimes>

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
