# Copyright 2011 Kevin Ryde

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

package Math::NumSeq::SqrtEngel;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 20;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

use Math::NumSeq::Squares;

# uncomment this to run the ### lines
#use Smart::Comments;


use constant description => Math::NumSeq::__('Engel expansion for a square root.');
use constant characteristic_monotonic => 1;
use constant i_start => 1;

use Math::NumSeq::SqrtDigits;
use constant parameter_info_array =>
  [
   Math::NumSeq::SqrtDigits->parameter_info_hash->{'sqrt'},
  ];

use constant values_min => 1;
sub values_max {
  my ($self) = @_;
  return ($self->Math::NumSeq::Squares::pred($self->{'sqrt'})
          ? 1
          : undef);
}

# cf A028259 of phi=(sqrt(5)+1)/2 golden ratio
#    A068388 of sqrt(3/2)
#    A059178 cube root 2
#    A059179 cube root 3
#
my @oeis_anum = (undef,     # 0
                 undef,     # 1
                 'A028254', # 2
                 # OEIS-Catalogue: A028254
                 'A028257', # 3
                 # OEIS-Catalogue: A028257 sqrt=3
                 undef,     # 4
                 'A059176', # 5
                 # OEIS-Catalogue: A059176 sqrt=5
                 undef,     # 6
                 'A161368', # 7
                 # OEIS-Catalogue: A161368 sqrt=7
                 undef,     # 8
                 undef,     # 9
                 'A059177', # 10
                 # OEIS-Catalogue: A059177 sqrt=10
                );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'sqrt'}];
}

# a/b + 1/(b*v) = sqrt(s)
# a + 1/v = b*sqrt(s)
# 1/v = b*sqrt(s) - a
# v = 1 / (b*sqrt(s) - a)
#   = (b*sqrt(s) + a) / (b*sqrt(s) - a)*(b*sqrt(s) + a)
#   = (b*sqrt(s) + a) / (b^2*s - a^2)
#   = (sqrt(s*b^2) + a) / (s*b^2 - a^2)
# round up v
#   sqrt(sb2) never an integer
#   bigint sqrt rounds down so +1 to round up
#   division add den-1 to round up
#   so add 1+den-1=den means
# v = floor( (floor(sqrt(s*b^2)) + a) / (s*b^2 - a^2) ) + 1
#
# a/b + 1/bv < sqrt(s)
# a + 1/v < b*sqrt(s)
# a^2 + 2a/v + 1/v^2 < s*b^2
# a^2*v^2 + 2a*v + 1 < s*b^2*v^2
#
# a/b < sqrt(s)
# a < b*sqrt(s)
# a^2 < s*b^2
#
sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;

  my $sqrt = $self->{'sqrt'};
  if ($sqrt <= 0) {
    $self->{'a'} = 0;
  } else {
    my $root = sqrt($sqrt);
    if ($root == int($root)) {
      # perfect square
      $self->{'perfect_square'} = 1;
      $self->{'a'} = $root;
    } else {
      # start 0/1 a=0,b=1, so sb2=s*b^2=s
      $self->{'a'} = Math::NumSeq::_bigint()->new(0);
      $self->{'sb2'} = Math::NumSeq::_bigint()->new($sqrt);
    }
  }
}
sub next {
  my ($self) = @_;
  ### SqrtEngel next() ...

  my $a = $self->{'a'};
  my $value;
  if ($self->{'perfect_square'}) {
    if ($a) {
      $value = 1;
      $self->{'a'} -= 1;
    } else {
      # perfect square no more terms
      return;
    }
  } else {
    ### a: "$self->{'a'}"
    ### sb2: "$self->{'sb2'}"
    ### b: "".sqrt($self->{'sb2'} / $self->{'sqrt'})
    ### assert: $self->{'a'} * $self->{'a'} <= $self->{'sb2'}
    ### num: (sqrt($self->{'sb2'}) + $self->{'a'}).''
    ### den: ($self->{'sb2'} - $self->{'a'}**2).''

    # always "+ 1" to round up because sqrt() is not an integer so the numerator is not divisible by the denominator
    #
    $value = (sqrt($self->{'sb2'}) + $a) / ($self->{'sb2'} - $a*$a) + 1;
    $self->{'a'} = $a*$value + 1;
    $self->{'sb2'} *= $value * $value;

    ### new value: "$value"
    ### assert: $self->{'a'} * $self->{'a'} <= $self->{'sb2'}

    if ($value <= ~0) {
      $value = $value->numify;
    }
  }

  return ($self->{'i'}++, $value);
}

#  ### assert: $self->{'a'} ** 2 * $value ** 2 + 2 * $self->{'a'} * $value + 1 < $self->{'sb2'} * $value ** 2


# a/b + 1/bv + 1/bvw < sqrt(s)
# 1/bvw < sqrt(s) - a/b - 1/bv
# 1/w < bv*sqrt(s) - bv*a/b - bv/bv
# 1/w < bv*sqrt(s) - v*a - 1
# 1/w < v*(b*sqrt(s) - a) - 1
#
# 1/bv + 1/bvw
#   = 1/bv + 1/bvw + 1/bw - 1/bw
#   = 1/bw + 1/bvw + (1/bv - 1/bw)
#   = 1/bw + 1/bvw + w/bvw - v/bvw
#   = 1/bw + (1+w-v)/bvw
#

1;
__END__

=for stopwords Ryde Math-NumSeq radicand BigInt radix Engel

=head1 NAME

Math::NumSeq::SqrtEngel -- Engel expansion of a square root

=head1 SYNOPSIS

 use Math::NumSeq::SqrtEngel;
 my $seq = Math::NumSeq::SqrtEngel->new (sqrt => 2);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is terms in the Engel expansion of a square root.  It approaches the
root by a series

              1         1              1
   sqrt(s) = ---- + --------- + -------------- + ...
             a[1]   a[1]*a[2]   a[1]*a[2]*a[3]

The sequence values are each successive a[i].  For example sqrt(2)

              1     1      1        1          1
   sqrt(2) = --- + --- + ----- + ------- + ---------- + ...
              1    1*3   1*3*5   1*3*5*5   1*3*5*5*16

is

    1, 3, 5, 5, 16, etc

Each new 1/prod term is the biggest which keeps the total below sqrt(s),
which means each a[i] is the smallest possible.

For a perfect square the expansion is a trivial 1s sequence adding up to the
root.  This is unlikely to be interesting but it works.

    1/1+1/1+...+1/1 = sqrt(perfect square)


=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::SqrtEngel-E<gt>new (sqrt =E<gt> $s)>

Create and return a new sequence object giving the Engel expansion terms of
C<sqrt($s)>.

=back

=head1 BUGS

The current code requires C<Math::BigInt> C<sqrt()>, which may mean BigInt
1.60 or higher (which comes with Perl 5.8.0).

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::SqrtDigits>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011 Kevin Ryde

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
