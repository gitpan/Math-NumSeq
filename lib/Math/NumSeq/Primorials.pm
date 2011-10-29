# Copyright2011 Kevin Ryde

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

package Math::NumSeq::Primorials;
use 5.004;
use strict;
use Math::Prime::XS;

use vars '$VERSION', '@ISA';
$VERSION = 14;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# use constant name => Math::NumSeq::__('Primorials');
use constant description => Math::NumSeq::__('The primorials 1, 2, 6, 30, 210, etc, 2*3*5*7*...Prime(n).');
use constant characteristic_monotonic => 2;
use constant values_min => 1;

# cf A034386 product of primes p <= i, so repeating 1, 2, 6, 6, 30, 30,
#
use constant oeis_anum => 'A002110'; # starting at 1

# uncomment this to run the ### lines
#use Devel::Comments;

use constant 1.02;  # for leading underscore
use constant _UV_LIMIT => do {
  my $u = ~0 >> 1;
  my $limit = 1;
  for my $p (Math::Prime::XS::sieve_primes(100)) {
    ### $p
    if ($u < $p) {
      ### _UV_LIMIT stop before prime: "p=$p"
      last;
    }
    $u -= ($u % $p);
    $u /= $p;
    $limit *= $p;
  }
  $limit
};
### _UV_LIMIT: _UV_LIMIT()

sub rewind {
  my ($self) = @_;
  ### Primorials rewind()
  $self->{'prime'} = 1;
  $self->{'i'} = 0;
  $self->{'f'} = 1;
}
sub next {
  my ($self) = @_;
  ### Primorials next() ...

  if (my $i = $self->{'i'}++) {
    my $f = $self->{'f'};
    if ($f >= _UV_LIMIT && ! ref $f) {
      $self->{'f'} = Math::NumSeq::_bigint()->new($f);
    }
    my $prime;
    do {
      $prime = $self->{'prime'}++;
    } until (Math::Prime::XS::is_prime($prime));
    return ($i, $self->{'f'} *= $prime);

  } else {
    return (0, 1);
  }
}

sub ith {
  my ($self, $i) = @_;
  ### Primorials ith(): $i
  if (_is_infinite($i)) {
    return $i;
  }
  my $f = 1;
  my $prime = 1;
  while ($i-- > 0) {
    if ($f >= _UV_LIMIT && ! ref $f) {
      $f = Math::NumSeq::_bigint()->new($f);
    }
    until (Math::Prime::XS::is_prime(++$prime)) {}
    $f *= $prime;
  }
  return $f;
}

sub pred {
  my ($self, $value) = @_;
  ### Primorials pred()
  my $prime = 2;
  for (;;) {
    if ($value <= 1) {
      return ($value == 1);
    }
    if (($value % $prime) == 0) {
      $value /= $prime;
      if (($value % $prime) == 0) {
        return 0;  # doubled prime factor
      }
    } else {
      return 0;  # not divisible by this prime
    }
    until (Math::Prime::XS::is_prime(++$prime)) {}
  }
}

1;
__END__

=for stopwords Ryde Math-NumSeq primorials

=head1 NAME

Math::NumSeq::Primorials -- primorials 2*3*...*p[i]

=head1 SYNOPSIS

 use Math::NumSeq::Primorials;
 my $seq = Math::NumSeq::Primorials->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of primorials, 1, 2, 6, 30, 210, etc, being the product of the
first i many primes, 2*3*5*...*p[i].

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Primorials-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<2*3*5*...*p[$i]>.  For C<$i==0> this is considered an empty product
and the return is 1.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is equal to C<2*3*5*...*p[i]> for number of the
primes.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Factorials>

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
