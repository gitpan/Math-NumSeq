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

package Math::NumSeq::SophieGermainPrimes;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 34;

use Math::NumSeq::Primes;
@ISA = ('Math::NumSeq::Primes');

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Sophie Germain Primes');
use constant description => Math::NumSeq::__('Sophie Germain primes 3,5,7,11,23,29, being primes P where 2*P+1 is also prime (those latter being the "safe" primes).');
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;
use constant values_min => 2; # at i=0 2*2+1=5

# cf. A007700 for n,2n+1,4n+3 all primes - or something?
#
use constant oeis_anum => 'A005384';

sub rewind {
  my ($self) = @_;
  $self->SUPER::rewind;
  $self->{'sophie_aseq'} = Math::NumSeq::Primes->new;
  $self->{'sophie_i'} = 0;
}

sub next {
  my ($self) = @_;

  my $aseq = $self->{'sophie_aseq'};
  my $ahead = 0;
  for (;;) {
    (undef, my $prime) = $self->SUPER::next
      or return;

    my $target = 2*$prime+1;
    while ($ahead < $target) {
      (undef, $ahead) = $aseq->next
        or return;
    }
    if ($ahead == $target) {
      return (++$self->{'sophie_i'}, $prime);
    }
  }
}

sub pred {
  my ($self, $value) = @_;
  return ($self->SUPER::pred ($value)
          && $self->SUPER::pred (2*$value + 1));
}

1;
__END__


# use List::Util 'max';
# sub new {
#   my ($class, %options) = @_;
#   my $lo = $options{'lo'} || 0;
#   my $hi = $options{'hi'};
#   my $safe_primes = $options{'safe_primes'};
#   $lo = max (0, $lo);
# 
#   ### SophieGermainPrimes: "array $lo to ".(2*$hi+1)
#   require Math::NumSeq::Primes;
#   my @array = Math::NumSeq::Primes::_primes_list ($lo, 2*$hi+1);
# 
#   my $to = 0;
#   my $p = 0;
#   for (my $i = 0; $i < @array; $i++) {
#     my $prime = $array[$i];
#     last if $prime > $hi;
# 
#     my $target = 2*$prime+1;
#     for (;;) {
#       if ($p <= $#array) {
#         if ($array[$p] < $target) {
#           $p++;
#           next;
#         }
#         if ($array[$p] == $target) {
#           $array[$to++] = ($safe_primes ? 2*$prime+1 : $prime);
#           $p++;
#         }
#       }
#       last;
#     }
#   }
#   $#array = $to - 1;
#   return $class->SUPER::new (%options,
#                              array => \@array,
#                              i     => 0);
# }

=for stopwords Ryde Math-NumSeq Germain

=head1 NAME

Math::NumSeq::SophieGermainPrimes -- Sophie Germain primes p and 2*p+1 prime

=head1 SYNOPSIS

 use Math::NumSeq::SophieGermainPrimes;
 my $seq = Math::NumSeq::SophieGermainPrimes->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The primes 2, 3, 5, 11, 23, etc, where both P and 2*P+1 are prime.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::SophieGermainPrimes-E<gt>new ()>

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Sophie Germain prime, meaning both C<$value>
and C<2*$value+1> are prime.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Primes>,
L<Math::NumSeq::TwinPrimes>

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
