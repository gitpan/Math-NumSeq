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

package Math::NumSeq::LiouvilleFunction;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 48;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

use Math::NumSeq::PrimeFactorCount;

# uncomment this to run the ### lines
#use Devel::Comments;


# use constant name => Math::NumSeq::__('Liouville Function');
use constant description => Math::NumSeq::__('The Liouville function, being 1 for an even number of prime factors or -1 for an odd number.');
use constant characteristic_pn1 => 1;
use constant characteristic_increasing => 0;
use constant characteristic_integer => 1;
use constant values_min => -1;
use constant values_max => 1;
use constant i_start => 1;

# cf A026424 - the -1 positions, odd number of primes
#    A028260 - the 1 positions, even number of primes
#
use constant oeis_anum => 'A008836'; # liouville 1,-1


# each 2-bit vec() value is
#    0 unset
#    1 (unused)
#    2 even count of factors
#    3 odd count of factors

my @transform = (0, 0, 1, -1);

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'multiplicity'} = 'repeated'; # for PrimeFactorCount ith()
  $self->{'prime_type'} = 'all';        # for PrimeFactorCount ith()
  _restart_sieve ($self, 500);
}
sub _restart_sieve {
  my ($self, $hi) = @_;
  ### _restart_sieve() ...
  $self->{'hi'} = $hi;
  $self->{'string'} = "\0" x (($hi+1)/4);  # 4 of 2 bits each
  vec($self->{'string'}, 0,2) = 1;  # N=0 ...
  vec($self->{'string'}, 1,2) = 2;  # N=1 treated as even
}

sub next {
  my ($self) = @_;

  my $i = $self->{'i'}++;
  my $hi = $self->{'hi'};
  if ($i <= 1) {
    if ($i <= 0) {
      return ($i, 0);
    }
    else {
      return ($i, 1);
    }
  }

  my $start = $i;
  if ($i > $hi) {
    _restart_sieve ($self, $hi *= 2);
    $start = 2;
  }
  my $sref = \$self->{'string'};

  my $ret;
  foreach my $i ($start .. $i) {
    $ret = vec($$sref, $i,2);
    if ($ret == 0) {
      ### prime: $i
      $ret = 3; # odd

      # existing squares $v==1 left alone, others toggle 2=odd,3=even

      for (my $power = $i; $power <= $hi; $power *= $i) {
        for (my $j = $power; $j <= $hi; $j += $power) {
          ### p: "$j ".vec($$sref, $j,2)
          vec($$sref, $j,2) = (vec($$sref, $j,2) ^ 1) | 2;
          ### set: vec($$sref, $j,2)
        }
      }

      # print "applied: $i\n";
      # for (my $j = 0; $j < $hi; $j++) {
      #   printf "  %2d %2d\n", $j, vec($$sref,$j,2);
      # }
    }
  }
  ### ret: "$i, $ret -> ".$transform[$ret]
  return ($i, $transform[$ret]);
}

sub ith {
  my ($self, $i) = @_;
  ### LiouvilleFunction ith(): $i

  my $count = $self->Math::NumSeq::PrimeFactorCount::ith($i);
  return (defined $count ? ($count & 1 ? -1 : 1)
          : undef);
}

sub pred {
  my ($self, $value) = @_;
  return ($value == 1 || $value == -1);
}

1;
__END__

=for stopwords Math-NumSeq Ryde Liouville ie

=head1 NAME

Math::NumSeq::LiouvilleFunction -- Liouville function sequence

=head1 SYNOPSIS

 use Math::NumSeq::LiouvilleFunction;
 my $seq = Math::NumSeq::LiouvilleFunction->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Liouville function, 1, -1, -1, 0, -1, 1, etc, being

    1   if i has an even number of prime factors
    -1  if i has an odd number of prime factors

The sequence starts from i=1 which is taken to be no prime factors,
ie. zero, which is even, hence Liouville function 1.  Then i=2 and i=3 are
-1 since they have one prime factor (they're primes), and i=4 is value 1
because it's 2*2 which is an even number of prime factors (two 2s).

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::LiouvilleFunction-E<gt>new ()>

Create and return a new sequence object.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the Liouville function of C<$i>, being 1 or -1 according to the
number of prime factors in C<$i>.

This calculation requires factorizing C<$i> and in the current code a hard
limit of 2**32 is placed on C<$i>, in the interests of not going into a
near-infinite loop.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which simply means 1 or -1.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::MobiusFunction>,
L<Math::NumSeq::PrimeFactorCount>

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
