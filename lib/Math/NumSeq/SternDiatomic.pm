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


# Edsgar Dijkstra
#    http://www.cs.utexas.edu/users/EWD/ewd05xx/EWD570.PDF
#    http://www.cs.utexas.edu/users/EWD/ewd05xx/EWD578.PDF
#
# from 1858
#

package Math::NumSeq::SternDiatomic;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 36;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Smart::Comments;

use constant description => Math::NumSeq::__('Stern\'s diatomic sequence.');
use constant i_start => 0;
use constant values_min => 0;
use constant characteristic_smaller => 1;
use constant characteristic_increasing => 0;
use constant characteristic_integer => 1;

# cf A126606 - this stern diatomic is A126606(i+1)/2
#    A049455 - another variation ...
#    A049456 - with the 1s doubled up ...
#    A174980 - type ([0,1],1) ...
#
use constant oeis_anum => 'A002487';

sub ith {
  my ($self, $i) = @_;
  ### SternDiatomic ith(): "$i"

  if ($i <= 0) {
    return 0;
  }
  if (_is_infinite($i)) {  # don't loop forever if $value is +/-infinity
    return $i;
  }

  my $b = ($i * 0); # inherit bignum 0
  my $a = $b + 1;   # inherit bignum 1

  while ($i) {
    if ($i % 2) {
      $b += $a;
    } else {
      $a += $b;
    }
    $i = int($i/2);
  }

  ### result: "$b"
  return $b;
}

sub pred {
  my ($self, $value) = @_;
  ### SternDiatomic pred(): $value
  return ($value >= 0 && $value == int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq radix Moritz

=head1 NAME

Math::NumSeq::SternDiatomic -- Stern's diatomic sequence

=head1 SYNOPSIS

 use Math::NumSeq::SternDiatomic;
 my $seq = Math::NumSeq::SternDiatomic->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

Moritz Stern's diatomic sequence 0,1,1,2,1,3,2,3,etc.  It's constructed by
successive levels as D(2*i)=D(i) and D(2*i+1)=D(i+1), so effectively the
sequence is extended by interleaving the previous level with sums of
adjacent terms,

   1,            i=0
   1,2,          i=1,2
   1,3,2,3,      i=3,4,5,6

The last row is a copy of 1,2 interleaving the sums 1+2 and 2+1.  For the
latter it's the end 2 at i=2 and then the 1 at the start of the next row
i=3.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for behaviour common to all sequence classes.

=over 4

=item C<$seq = Math::NumSeq::SternDiatomic-E<gt>new ()>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which means simply
C<$value>=0>.

=back

=head1 SEE ALSO

L<Math::NumSeq>

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
