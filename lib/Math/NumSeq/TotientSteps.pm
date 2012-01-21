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

package Math::NumSeq::TotientSteps;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 30;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Totient;
*_totient_by_sieve = \&Math::NumSeq::Totient::_totient_by_sieve;

# uncomment this to run the ### lines
#use Devel::Comments;


use constant description => Math::NumSeq::__('Number of repeated applications of the totient function to reach 1.');
use constant characteristic_count => 1;
use constant characteristic_increasing => 0;
use constant values_min => 0; # at i=1
use constant i_start => 1;
use constant oeis_anum => 'A003434';

sub ith {
  my ($self, $i) = @_;
  ### TotientSteps ith(): $i

  if (_is_infinite($i)) {
    return $i;
  }

  my $count = 0;
  for (;;) {
    if ($i <= 1) {
      return $count;
    }
    $i = _totient_by_sieve($self,$i);
    $count++;
  }
}

sub pred {
  my ($self, $value) = @_;
  return ($value==int($value) && $value >= 1);
}

1;
__END__

=for stopwords Ryde Math-NumSeq totient totients

=head1 NAME

Math::NumSeq::TotientSteps -- count of repeated totients to reach 1

=head1 SYNOPSIS

 use Math::NumSeq::TotientSteps;
 my $seq = Math::NumSeq::TotientSteps->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

How many repeated applications of the totient function to reach 1, so 0, 1,
2, 2, 3, 2, etc.  For example i=5 goes 5- E<gt> 4 -E<gt> 2 -E<gt> 1 so 3
steps.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::TotientSteps-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the count totient of steps to run i down to 1.

=item C<$value = $seq-E<gt>pred($value)>

Return true if C<$value> occurs in the sequence, which simply means a count
C<$value E<gt>= 1>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Totient>,
L<Math::NumSeq::TotientPerfect>,
L<Math::NumSeq::TotientStepsSum>

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
