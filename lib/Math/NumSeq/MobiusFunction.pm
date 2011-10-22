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

package Math::NumSeq::MobiusFunction;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 13;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Devel::Comments;


# use constant name => Math::NumSeq::__('Mobius Function');
use constant description => Math::NumSeq::__('The Mobius function, being 1 for an even number of prime factors, -1 for an odd number, or 0 if any repeated factors (ie. not square-free).');
use constant characteristic_pn1 => 1;
use constant characteristic_monotonic => 0;
use constant values_min => -1;
use constant values_max => 1;

# cf A030059 the -1 positions, odd number of distinct primes
#    A030229 the 1 positions, even number of distinct primes
#    A013929 the 0 positions, square factor, ie. non-square-frees
#    A005117 the square frees, mobius -1 or +1
#
use constant oeis_anum => 'A008683'; # mobius -1,0,1


# each 2-bit vec() value is
#    0 unset
#    1 square factor
#    2 even count of factors
#    3 odd count of factors

my @transform = (0, 0, 1, -1);

sub rewind {
  my ($self) = @_;
  $self->{'i'} = 1;
  _restart_sieve ($self, 500);

  # my $lo = $options{'lo'} || 0;
  # while ($self->{'i'} < $lo) {
  #   $self->next;
  # }
}
sub _restart_sieve {
  my ($self, $hi) = @_;
  ### _restart_sieve() ...
  $self->{'hi'} = $hi;
  $self->{'string'} = "\0" x (($hi+1)/4);  # 4 of 2 bits each
  vec($self->{'string'}, 0,2) = 1;  # N=0 treated as square
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
      for (my $j = $i; $j <= $hi; $j += $i) {
        ### p: "$j ".vec($$sref, $j,2)
        if ((my $v = vec($$sref, $j,2)) != 1) {
          vec($$sref, $j,2) = ($v ^ 1) | 2;
          ### set: vec($$sref, $j,2)
        }
      }

      # squares set to $v==1
      my $step = $i * $i;
      for (my $j = $step; $j <= $hi; $j += $step) {
        vec($$sref, $j,2) = 1;
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
  ### MobiusFunction ith(): $i
  if ($i < 0 || $i > 0xFFFF_FFFF) {
    return undef;
  }
  my $ret = 0;

  if (($i % 2) == 0) {
    $i /= 2;
    if (($i % 2) == 0) {
      return 0;  # square factor
    }
    $ret = 1;
  }

  my $limit = int(sqrt($i));
  my $p = 3;
  while ($p <= $limit) {
    if (($i % $p) == 0) {
      $i /= $p;
      if (($i % $p) == 0) {
        return 0;  # square factor
      }
      $limit = int(sqrt($i));  # new smaller limit
      $ret ^= 1;
      ### factor: "$p new ret $ret new limit $limit"
    }
    $p += 2;
  }
  if ($i != 1) {
    $ret ^= 1;
  }
  return 1-2*$ret;
}

sub pred {
  my ($self, $value) = @_;
  return ($value == 0 || $value == 1 || $value == -1);
}

1;
__END__

=for stopwords Ryde Mobius ie

=head1 NAME

Math::NumSeq::MobiusFunction -- Mobius function sequence

=head1 SYNOPSIS

 use Math::NumSeq::MobiusFunction;
 my $seq = Math::NumSeq::MobiusFunction->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of the Mobius function, 1, -1, -1, 0, -1, 1, etc,

    1   if i has an even number of distinct prime factors
    -1  if i has an odd number of distinct prime factors
    0   if i has a repeated prime factor

The sequence starts from i=1 and it's reckoned as no prime factors, ie. 0
factors, which is considered even, hence Mobius function 1.  Then i=2 and
i=3 are value -1 since they have one prime factor (they're primes), and i=4
is value 0 because it's 2*2 which is a repeated prime 2.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::MobiusFunction-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the Mobius function of C<$i>, being 1, 0 or -1 according to the prime
factors of C<$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is 1, 0 or -1.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::LiouvilleFunction>,
L<Math::NumSeq::PrimeFactorCount>

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
