# Copyright 2012 Kevin Ryde

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


package Math::NumSeq::LuckyNumbers;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 56;

use Math::NumSeq 7; # v.7 for _is_infinite()
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Lucky Numbers');
use constant description => Math::NumSeq::__('Sieved out multiples according to the sequence itself.');
use constant values_min => 1;
use constant i_start => 1;
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;

# cf A145649 - 0,1 characteristic of Lucky numbers
#    A050505 - complement, the non-Lucky numbers
#
#    A007951 - ternary sieve, dropping 3rd, 6th, 9th, etc
#    1,2,_,4,5,_,7,8,_,10,11,_,12,13,_,14,15,_
#                              ^9th
#    1,2,4,5,7,8,10,11,14,16,17,19,20,22,23,25,28,29,31,32,34,35,37,38,41,     

use constant oeis_anum => 'A000959';

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'value'} = -1;
  $self->{'count'} = [ 3 ];
  $self->{'remaining'}  = [ 3 ];
}

# ENHANCE-ME: Defer pushing each value only the count array until needed.
# Might keep array size down to i/log(i) instead of i.
#
sub next {
  my ($self) = @_;
  ### LuckyNumbers next(): "i=$self->{'i'}"
  ### count: $self->{'count'}
  ### remaining: $self->{'remaining'}
  ### value: $self->{'value'}

  my $count = $self->{'count'};
  my $remaining = $self->{'remaining'};
  my $value = $self->{'value'};

 OUTER: for (;;) {
    $value += 2;
    ### $value
    foreach my $i (0 .. $#$remaining) {
      if (--$remaining->[$i] <= 0) {
        ### exclude at: "i=$i  count=$self->{'count'}->[$i]"
        $remaining->[$i] = $self->{'count'}->[$i];
        next OUTER;
      }
    }
    $self->{'value'} = $value;
    if ($value > 3) {
      push @$count, $value;
      push @$remaining, $value - $self->{'i'};
    }
    return ($self->{'i'}++,
            $value);
  }
}

# i~=value/log(value)
#
use Math::NumSeq::Primes;
*value_to_i_estimate = \&Math::NumSeq::Primes::value_to_i_estimate;

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::LuckyNumbers -- sieved out multiples by the sequence itself

=head1 SYNOPSIS

 use Math::NumSeq::LuckyNumbers;
 my $seq = Math::NumSeq::LuckyNumbers->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is the so-called "Lucky" numbers obtained by sieving out multiples
taken from the sequence itself

    1, 3, 7, 9, 13, 15, 21, 25, 31, 33, 37, 43, 49, 51, 63, 67, ...

The sieve starts with the odd numbers

    1,3,5,7,9,11,13,15,17,19,21,23,25,...

Then sieve[2]=3 from the sequence means remove every third number, counting
from the start, so remove 5,11,17, etc to leave

    1,3,7,9,13,15,19,21,25,...

Then the next value sieve[3]=7 means remove every seventh number, so 19 etc,
to leave

    1,3,7,9,13,15,21,25,...

Then sieve[4]=9 means remove every ninth from what remains, and so on.  In
each case the removals count from the start of the values which remain at
that stage.

It can be shown the values grow at roughly the same rate as the primes, i =~
value/log(value).

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::LuckyNumbers-E<gt>new ()>

Create and return a new sequence object.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::ReRound>,
L<Math::NumSeq::ReReplace>

=head1 HOME PAGE

http://user42.tuxfamily.org/math-numseq/index.html

=head1 LICENSE

Copyright 2012 Kevin Ryde

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
