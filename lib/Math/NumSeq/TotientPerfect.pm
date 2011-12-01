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

package Math::NumSeq::TotientPerfect;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 20;
use Math::NumSeq;
use Math::NumSeq::Base::IteratePred;
@ISA = ('Math::NumSeq::Base::IteratePred',
        'Math::NumSeq');

use Math::NumSeq::Totient;
*_totient_by_sieve = \&Math::NumSeq::Totient::_totient_by_sieve;

# uncomment this to run the ### lines
#use Devel::Comments;

use constant description => Math::NumSeq::__('Numbers for which the sum of repeated applications of the totient function equals N.  Eg. 9 because phi(9)=6, phi(6)=2, phi(2)=1 and their sum 6+2+1 = 9.');
use constant characteristic_monotonic => 2;
use constant values_min => 3;
use constant i_start => 1;
use constant oeis_anum => 'A082897';

sub pred {
  my ($self, $value) = @_;
  if ($value < values_min
      || ($value % 2) == 0) {  # even numbers not perfect
    return 0;
  }
  my $sum = my $p = _totient_by_sieve($self,$value);
  for (;;) {
    if ($p <= 1) {
      return ($sum == $value);
    }
    $sum += ($p = _totient_by_sieve($self,$p));
    if ($sum > $value) {
      return 0;
    }
  }
  return ($value >= 1);
}

1;
__END__

=for stopwords Ryde Math-NumSeq totient totients

=head1 NAME

Math::NumSeq::TotientPerfect -- sum of repeated totients is N itself

=head1 SYNOPSIS

 use Math::NumSeq::TotientPerfect;
 my $seq = Math::NumSeq::TotientPerfect->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

Numbers for which the sum of repeated totients until reaching 1 gives the
starting n itself.  For example totient(15)=8, totient(8)=4, totient(4)=2
and totient(1)=1.  Adding them up 8+4+2+1=15 so 15 is a perfect totient.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::TotientPerfect-E<gt>new ()>

Create and return a new sequence object.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a perfect totient.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Totient>,
L<Math::NumSeq::TotientSteps>

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
