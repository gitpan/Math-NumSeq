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

package Math::NumSeq::PowerPart;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 53;
use Math::NumSeq 7; # v.7 for _is_infinite()
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::Factor::XS 'prime_factors';

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Powered Part');
use constant description => Math::NumSeq::__('Largest square etc dividing i.');
use constant characteristic_non_decreasing => 0;
use constant characteristic_increasing => 0;
use constant characteristic_integer => 1;
use constant characteristic_smaller => 1;
use constant values_min => 1;
use constant i_start => 1;

use constant parameter_info_array =>
  [
   { name    => 'power',
     type    => 'integer',
     default => '2',
     minimum => 2,
     width   => 2,
     # description => Math::NumSeq::__(''),
   },
  ];

# cf A008833 - largest square dividing n
#    A008834 - largest cube dividing n
#    A008835 - largest 4th power dividing n
#
my @oeis_anum
  = (
     # OEIS-Catalogue array begin
     undef,
     undef,
     'A000188',  #         # 2 sqrt of largest square dividing n
     'A053150',  # power=3 # 3 cbrt of largest cube dividing n
     'A053164',  # power=4 # 4th root of largest 4th power dividing n
     # OEIS-Catalogue array end
    );
sub oeis_anum {
  my ($self) = @_;
  return $oeis_anum[$self->{'power'}];
}

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  _restart_sieve ($self, 20);
}

# ENHANCE-ME: When growing the sieve keep the small primes and apply them to
# an array of just a new lo to hi region.
#
sub _restart_sieve {
  my ($self, $hi) = @_;
  ### _restart_sieve() ...
  $self->{'hi'} = $hi = int($hi);
  my $array = $self->{'array'} = [];
  $#$array = $hi;
  $array->[1] = 1;
}

sub next {
  my ($self) = @_;

  my $i = my $target = $self->{'i'}++;
  my $power = $self->{'power'};
  if ($power < 2) {
    return $i;
  }

  if ($i > $self->{'hi'}) {
    _restart_sieve ($self, $self->{'hi'} * 1.5);
    $i = 2;
  }

  my $hi = $self->{'hi'};
  my $aref = $self->{'array'};

  my $ret;
  for ( ; $i <= $target; $i++) {
    $ret = $aref->[$i];
    if (! defined $ret) {
      ### prime: $i

      # composites marked
      for (my $j = 2*$i; $j <= $hi; $j += $i) {
        ### composite: $j
        $aref->[$j] ||= 1;
      }

      # p^power multiplied in
      my $pow = $i ** $power;
      for (my $step = $pow; $step <= $hi; $step *= $pow) {
        ### $step
        for (my $j = $step; $j <= $hi; $j += $step) {
          ### divide: "j=$j value $aref->[$j] by $pow"
          $aref->[$j] *= $i;
        }
      }
    }
  }
  return ($target, $ret||1);
}

sub ith {
  my ($self, $i) = @_;
  ### PowerPart ith(): $i

  $i = abs($i);
  my $power = $self->{'power'};
  if ($power < 2) {
    return $i;
  }
  unless ($i >= 0 && $i <= 0xFFFF_FFFF) {
    return undef;
  }
  my $prev = 0;
  my $count = 0;
  my $ret = 1;
  foreach my $p (prime_factors($i)) {
    ### $p
    if ($p == $prev) {
      ### same ...
      ### $count
      if (++$count >= $power) {
        ### incorporate ...
        $ret *= $p;
        $count -= $power;
      }
    } else {
      ### different ...
      $count = 1;
      $prev = $p;
    }
  }
  return $ret;
}

# if (0) { # ... eval '; 1') {
#   ### use prime_factors() ...
#   eval "\n#line ".(__LINE__+1)." \"".__FILE__."\"\n" . <<'HERE';
# HERE
# } else {
#   ### $@
#   ### use plain perl ...
#   eval "\n#line ".(__LINE__+1)." \"".__FILE__."\"\n" . <<'HERE';
# 
# sub ith {
#   my ($self, $i) = @_;
#   ### PowerPart ith(): $i
#   $i = abs($i);
#   my $power = $self->{'power'};
#   if ($power < 2) {
#     return $i;
#   }
#   if ($i > 0xFFFF_FFFF) {
#     return undef;
#   }
#   if (_is_infinite($i)) { # nan
#     return $i;
#   }
#   if (abs($i) < 4) {
#     return 1;
#   }
# 
#   my $ret = 1;
# 
#   {
#     my $pow = 2 ** $power;
#     while (($i % $pow) == 0) {
#       ### $pow
#       $i /= $pow;
#       $ret *= 2;
#     }
#     while (($i % 2) == 0) {
#       $i /= 2;
#     }
#   }
# 
#   for (my $p = 3; ; $p += 2) {
#     my $pow = $p ** $power;
#     last if $pow > abs($i);
#     while (($i % $pow) == 0) {
#       ### $pow
#       $i /= $pow;
#       $ret *= $p;
#     }
#     while (($i % $p) == 0) {
#       $i /= $p;
#     }
#   }
# 
#   ### $ret
#   return $ret;
# }
# 
# HERE
# }

sub pred {
  my ($self, $value) = @_;
  return ($value == int($value) && $value >= 1);
}

1;
__END__

=for stopwords Ryde Math-NumSeq sqrt ie MobiusFunction PowerPart

=head1 NAME

Math::NumSeq::PowerPart -- largest square root etc divisor

=head1 SYNOPSIS

 use Math::NumSeq::PowerPart;
 my $seq = Math::NumSeq::PowerPart->new (power => 2);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This sequence is the largest integer whose square is a divisor of i,

    starting i=1
    1, 1, 1, 2, 1, 1, 1, 2, 3, ...

For example at i=27 the value is 3 since 3^2=9 is the largest square which
is a divisor of 27.  Notice the sequence value is the root, ie. 3, of the
divisor, not the square 9 etc.

When i has no square divisor, ie. is square-free, the value is 1.  Compare
the MobiusFunction where value 1 or -1 means square-free.  And conversely
MobiusFunction is 0 when there's a square factor, and PowerPart value here
is S<E<gt> 1> in that case.

=head2 Power Option

The C<power> parameter selects what power divisor to seek.  For example
C<power=E<gt>3> finds the largest cube dividing i and the sequence values
are the cube roots.

    power=>3
    1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, ...

For example i=24 the value is 2, since 2^3=8 is the largest cube which
divides 24.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::PowerPart-E<gt>new ()>

=item C<$seq = Math::NumSeq::PowerPart-E<gt>new (power =E<gt> $integer)>

Create and return a new sequence object.

=back

=head2 Random Access

=over

=item C<$value = $seq-E<gt>ith($i)>

Return the largest perfect square, cube, etc root dividing C<$i>.

The current code relies on factorizing C<$i> and a hard limit of 2**32 is
placed on C<$i> in the interests of not going into a near-infinite loop.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which is simply any integer
C<$value E<gt>= 1>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::MobiusFunction>,
L<Math::NumSeq::Powerful>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2011, 2012 Kevin Ryde

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
