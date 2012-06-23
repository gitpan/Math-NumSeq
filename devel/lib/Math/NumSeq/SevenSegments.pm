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

package Math::NumSeq::SevenSegments;
use 5.004;
use strict;
use List::Util 'sum';

use vars '$VERSION', '@ISA';
$VERSION = 45;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Repdigits;
*_digit_split_lowtohigh = \&Math::NumSeq::Repdigits::_digit_split_lowtohigh;

# uncomment this to run the ### lines
#use Smart::Comments;


# use constant name => Math::NumSeq::__('...');
use constant description => Math::NumSeq::__('Length of i written out in words.');
use constant default_i_start => 1;
use constant characteristic_smaller => 1;
use constant characteristic_integer => 1;
use constant characteristic_count => 1;
use constant values_min => 2;

#------------------------------------------------------------------------------

use constant oeis_anum => 'A006942';

#------------------------------------------------------------------------------

my @digit_segments = (6,   # 0
                      2,   # 1
                      5,   # 2
                      5,   # 3
                      4,   # 4
                      5,   # 5
                      6,   # 6
                      3,   # 7
                      7,   # 8
                      6,   # 9
                     );

sub ith {
  my ($self, $i) = @_;
  ### SevenSegments ith(): "$i"

  if (_is_infinite($i)) {
    return undef;
  }
  return sum (map {$digit_segments[$_]} _digit_split_lowtohigh($i,10));
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::SevenSegments -- count of segments to display in 7-segment LED 

=head1 SYNOPSIS

 use Math::NumSeq::SevenSegments;
 my $seq = Math::NumSeq::SevenSegments->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

This is how many segments are lit to display i in 7-segment LEDs

    starting i=0
    2, 5, 5, 4, 5, 6, 3, 7, 6, 8, 4, 7, 7, 6, 7, 8, 5, 9, 8, 11, ...

     ---                 ---       ---           
    |   |         |         |         |     |   |
                         ---       ---       --- 
    |   |         |     |             |         |
     ---                 ---       ---           

     ---       ---       ---       ---       --- 
    |         |             |     |   |     |   |
     ---       ---                 ---       --- 
        |     |   |         |     |   |         |
     ---       ---                 ---       --- 

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::SevenSegments-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the number of segments to display C<$i> in 7-segment LEDs.

=item C<$i = $seq-E<gt>i_start ()>

Return 0, the first term in the sequence being at i=0.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitLength>,
L<Math::NumSeq::AlphabeticalLength>

L<Tk::SevenSegmentDisplay>

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
