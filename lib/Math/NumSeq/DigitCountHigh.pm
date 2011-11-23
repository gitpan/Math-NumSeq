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

package Math::NumSeq::DigitCountHigh;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 17;

use Math::NumSeq 7; # v.7 for _is_infinite()
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Devel::Comments;


use constant description => Math::NumSeq::__('Count of how many of a given digit at the high end of a number, in a given radix.');
use constant values_min => 0;
use constant characteristic_monotonic => 0;
use constant characteristic_count => 1;

use Math::NumSeq::DigitCount 4;
*parameter_info_array = \&Math::NumSeq::DigitCount::parameter_info_array;

# cf
# 
my @oeis_anum;

$oeis_anum[2]->[1] = 'A090996'; # leading 1 bits
# OEIS-Catalogue: A090996 radix=2

# OEIS-Other: A000004 radix=2 digit=0
# OEIS-Other: A000004 radix=3 digit=0
# OEIS-Other: A000004 radix=10 digit=0

sub oeis_anum {
  my ($self) = @_;
  my $radix = $self->{'radix'};
  my $digit = $self->{'digit'};
  if ($digit == -1) {
    $digit = $radix-1;
  } elsif ($digit >= $radix || $digit == 0) {
    return 'A000004'; # all zeros, 
  }
  return $oeis_anum[$radix]->[$digit];
}

sub ith {
  my ($self, $i) = @_;
  $i = abs($i);
  if (_is_infinite($i)) {
    return $i;  # don't loop forever if $i is +infinity
  }

  my $radix = $self->{'radix'};
  my $digit = $self->{'digit'};
  if ($digit == -1) { $digit = $radix - 1; }

  my $count = 0;
    while ($i) {
      if (($i % $radix) == $digit) {
        $count++;
      } else {
        $count = 0;
      }
      $i = int($i/$radix);
    }
  return $count;
}

sub pred {
  my ($self, $value) = @_;
  return ($value >= 0);
}

1;
__END__

# & and >> no good for floats
  # if ($radix == 2) {
  #   while ($i) {
  #     if (($i & 1) == $digit) {
  #       $count++;
  #     } else {
  #       $count = 0;
  #     }
  #     $i >>= 1;
  #   }
  # } else {
  # }

=for stopwords Ryde Math-NumSeq radix

=head1 NAME

Math::NumSeq::DigitCountHigh -- count of given high digits

=head1 SYNOPSIS

 use Math::NumSeq::DigitCountHigh;
 my $seq = Math::NumSeq::DigitCountHigh->new (radix => 10,
                                              digit => 9);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The count of how many of a given digit are at the high end of C<$i> when
written out in a given radix.  The default is to count how many high 9s in
decimal.  For example i=9599 has value 1 as there's one consecutive 9 at the
high end.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::DigitCountLow-E<gt>new (radix =E<gt> $r, digit =E<gt> $d)>

Create and return a new sequence object.

C<digit> can be -1 to mean digit radix-1, the highest digit in the radix.

=item C<$value = $seq-E<gt>ith($i)>

Return how many of the given C<digit> is in C<$i> written in C<radix>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> might occur as a digit count, which means simply
C<$valueE<gt>=0>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitCount>,
L<Math::NumSeq::DigitCountLow>

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