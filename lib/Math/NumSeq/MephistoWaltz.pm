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

package Math::NumSeq::MephistoWaltz;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 42;
use Math::NumSeq;
@ISA = ('Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('Mephisto Waltz');
use constant description => Math::NumSeq::__('Mephisto waltz sequence.');
use constant i_start => 0;
use constant values_min => 0;
use constant values_max => 1;
use constant characteristic_integer => 1;

# cf A189658 - positions of 0
#    A189659 - positions of 1
#    A189660 - cumulative 0/1
#
use constant oeis_anum => 'A064990';  # mephisto waltz 0/1 values

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
  $self->{'value'} = 1;
  $self->{'low'} = -1;
  $self->{'digits'} = [];
}

my @table = (0,0,1, 0,0,1, 1,1,0,
             0,0,1, 0,0,1, 1,1,0,
             1,1,0, 1,1,0, 0,0,1);
my @delta = (map {$table[$_]^$table[($_+26)%27]} 0 .. 26);

sub next {
  my ($self) = @_;
  ### MephistoWaltz next(): $self->{'i'}
  ### at: "low=$self->{'low'}  value=$self->{'value'}"

  my $low;
  if (($low = ++$self->{'low'}) >= 27) {
    $low = $self->{'low'} = 0;
    my $i = 0;
    for (;;) {
      my $digit = ++$self->{'digits'}->[$i];
      ### carry to digit: $digit
      if ($digit >= 27) {
        $self->{'digits'}->[$i++] = 0;
        $self->{'value'} ^= 1;
      } else {
        $self->{'value'} ^= $delta[$digit];
        last;
      }
    }
  }
  ### apply: "low=$low delta=$delta[$low]"
  return ($self->{'i'}++,
          ($self->{'value'} ^= $delta[$low]));
}

sub ith {
  my ($self, $i) = @_;
  ### ith(): $i

  if (_is_infinite($i)) {
    return $i;
  }
  my $ret = 0;
  while ($i) {
    $ret ^= $table[$i % 27];
    $i = int($i/27);
  }
  return $ret;
}

sub pred {
  my ($self, $value) = @_;
  return ($value == 0 || $value == 1);
}

1;
__END__

=for stopwords Ryde Math-NumSeq Mephisto MephistoWaltz

=head1 NAME

Math::NumSeq::MephistoWaltz -- Mephisto waltz sequence

=head1 SYNOPSIS

 use Math::NumSeq::MephistoWaltz;
 my $seq = Math::NumSeq::MephistoWaltz->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Mephisto waltz sequence 0,0,1, 0,0,1, 1,1,0, etc, being the mod 2 count
of ternary digit 2s in i.  i=0 has no 2s so 0 and similarly i=1.  Then i=2
has one 2 so 1.

The sequence can also be expressed as starting with 0 and repeatedly
expanding

    0 -> 0,0,1
    1 -> 1,1,0

So

    0
    0,0,1
    0,0,1, 0,0,1, 1,1,0,
    0,0,1, 0,0,1, 1,1,0, 0,0,1, 0,0,1, 1,1,0, 1,1,0, 1,1,0, 0,0,1

    |                 |  |     copy        |  |     inverse     |
    +-----------------+  +-----------------+  +-----------------+

The effect of the expansion is keep the initial third the same, append a
copy of it, and an inverse of it 0 changed to 1 and 1 changed to 0.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::MephistoWaltz-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the C<$i>'th MephistoWaltz value, being the count mod 2 of the
ternary digit 2s in C<$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which simply means 0 or 1.

=back

=head1 FORMULAS

The calculation can be made in a power-of-3 base like 9, 27, 81, etc instead
of just 3.  For example in base 9 digits 2, 5, 6, 7 have a one (mod 2)
ternary 2.  These base 9 digits correspond to the 1s in the initial sequence
0,0,1, 0,0,1, 1,1,0 shown above.

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitSumModulo>

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
