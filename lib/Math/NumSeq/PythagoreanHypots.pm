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

package Math::NumSeq::PythagoreanHypots;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 34;

use Math::NumSeq 7; # v.7 for _is_infinite()
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Primes;
use Math::Prime::XS 0.23 'is_prime'; # version 0.23 fix for 1928099

# uncomment this to run the ### lines
#use Smart::Comments;


use constant description => Math::NumSeq::__('The hypotenuses of Pythagorean triples, ie. integers z for which there\'s some x>=1,y>=1 satisfying x^2+y^2=z^2.  Primitives hypotenuses are those z where x,y have no common factor.');
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;
use constant values_min => 5;
use constant i_start => 1;

use constant parameter_info_array =>
  [ {
     name        => 'pythagorean_type',
     type        => 'enum',
     default     => 'all',
     choices     => ['all','primitive'],
    },
  ];

# cf A002144 - primes 4n+1, the primitive elements of hypots x!=y
#              -1 is a quadratic residue ...
#    A002365 - the "y" of prime "c" ??
#    A002366 - the "x" of prime "c" ??
#    A046083 - the "a" smaller number, ordered by "c"
#    A046084 - the "b" second number, ordered by "c"
#
#    A008846 - primitives, x,y no common factor
#    A004613 - all prime factors are 4n+1, is 1 then primitive hypots
#
#    A009000 hypots with repetitions
#    A009001
#    A009002
#    A009012 - "b" second number, ordered by "b", with repetitions
#
my %oeis_anum = (all       => 'A009003',  # distinct x!=y and x,y>0
                 primitive => 'A008846',
                );
# OEIS-Catalogue: A009003
# OEIS-Catalogue: A008846 pythagorean_type=primitive
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum{$self->{'pythagorean_type'}};
}

sub rewind {
  my ($self) = @_;
  $self->{'array'} = [];
  $self->{'i'} = $self->i_start;
  $self->{'hi'} = 1;
}

sub next {
  my ($self) = @_;
  my $array = $self->{'array'};
  for (;;) {
    if (defined (my $value = shift @$array)) {
      return ($self->{'i'}++,
              $value);
    }
    my $lo = $self->{'hi'} + 1;
    $self->{'hi'} = my $hi = $lo + 1000;
    @$array = _hypots_block ($self, $lo, $hi);
  }
}

sub _hypots_block {
  my ($self, $lo, $hi) = @_;

  if ($self->{'pythagorean_type'} eq 'primitive') {
    return grep {$self->pred($_)} $lo .. $hi;

  } else {
    my %hypots;
    foreach my $p (grep {($_ & 3)==1}
                   Math::NumSeq::Primes::_primes_list(2, $hi)) {
      @hypots{map {$_*$p}
                (int(($lo+$p-1)/$p) .. int($hi/$p))
              } = ();
    }
    return sort {$a<=>$b} keys %hypots;
  }
}

sub pred {
  my ($self, $value) = @_;
  ### pred: $value

  if ($value < 5
      || _is_infinite($value)
      || $value != int($value)) {
    return 0;
  }

  my $pythagorean_type = $self->{'pythagorean_type'};
  ### $pythagorean_type

  unless ($value % 2) {
    ### even ...
    if ($pythagorean_type ne 'all') {
      ### primitive and prime never even ...
      return 0;
    }
    do {
      $value /= 2;
    } until ($value % 2);
  }
  unless ($value <= 0xFFFF_FFFF) {
    return undef;
  }

  my $limit = int(sqrt($value));

  for (my $p = 3; $p <= $limit; $p += 2) {
    if (($value % $p) == 0) {
      if (($p & 3) == 1) {
        ### found 4k+1 prime: $p
        if ($pythagorean_type eq 'all') {
          return 1;
        }
      } else {
        ### found 4k+3 prime: $p
        if ($pythagorean_type eq 'primitive') {
          return 0;
        }
      }

      do {
        $value /= $p;
      } while (($value % $p) == 0);

      $limit = int(sqrt($value));  # new smaller limit
      ### divide out prime: "$p new limit $limit"
    }
  }

  # $value now 1 or prime
  if ($pythagorean_type eq 'primitive') {
    # all, check this isn't a 4k+3 prime
    return ($value % 4) != 3;
  } else {
    # all, last chance to see a 4k+1 prime
    return ($value > 1
            && ($value % 4) == 1);
  }
}

1;
__END__

=for stopwords Ryde Math-NumSeq ie

=head1 NAME

Math::NumSeq::PythagoreanHypots -- hypotenuses of Pythagorean triples

=head1 SYNOPSIS

 use Math::NumSeq::PythagoreanHypots;
 my $seq = Math::NumSeq::PythagoreanHypots->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of integers occurring as the hypotenuse of a Pythagorean
triple, ie. the z in x^2+y^2=z^2.

    5, 10, 13, 15, 17, 20, ...

For example 13 is in the sequence because it occurs as 1^2+12^2 = 13^2.

It can be shown that this is all integers which have at least one prime
factor of the form 4k+1.

=head2 Primitive Triples

For any triple x,y,z a multiple k*x,k*y,k*z is also a triple.  The primitive
triples are those where x,y have no common factor.  Option
C<pythagorean_type =E<gt> "primitive"> restricts to those hypots occuring in
primitive triples

    5, 13, 17, 25, 29, 37, ...

It can be shown these are integers comprised only of prime factors 4k+1.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::PythagoreanHypots-E<gt>new ()>

=item C<$seq = Math::NumSeq::PythagoreanHypots-E<gt>new (pythagorean_type =E<gt> $str)>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs as a hypotenuse in a Pythagorean triple.

This calculation requires checking the prime factors of C<$value>.  In the
current code a hard limit of 2**32 is placed on C<$value> in the interests
of not going into a near-infinite loop.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Cubes>

L<Math::PlanePath::PythagoreanTree>

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
