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

package Math::NumSeq::TotientStepsSum;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 32;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

use Math::NumSeq::Totient 13;
*_totient_by_sieve = \&Math::NumSeq::Totient::_totient_by_sieve;

# uncomment this to run the ### lines
#use Devel::Comments;


use constant description => Math::NumSeq::__('Sum of totients when repeatedly applying until reach 1.');
use constant characteristic_increasing => 0;
use constant characteristic_integer => 1;
use constant i_start => 1;
use constant parameter_info_array =>
  [ { name        => 'including_self',
      type        => 'boolean',
      display     => Math::NumSeq::__('Incl Self'),
      default     => 1,
      description => Math::NumSeq::__('Whether to include N itself in the sum.'),
    },
  ];
sub values_min {
  my ($self) = @_;
  return ($self->{'including_self'} ? 1 : 0);
}


# OEIS-Catalogue: A053478 including_self=1
# OEIS-Catalogue: A092693 including_self=0
sub oeis_anum {
  my ($self) = @_;
  return ($self->{'including_self'} ? 'A053478' : 'A092693');
}

sub ith {
  my ($self, $i) = @_;

  if (_is_infinite($i)) {
    return $i;
  }

  my $sum = ($self->{'including_self'} ? $i : $i*0);
  while ($i > 1) {
    $sum += ($i = _totient_by_sieve($self,$i));
  }
  return $sum;
}

1;
__END__

=for stopwords Ryde Math-NumSeq totient totients

=head1 NAME

Math::NumSeq::TotientStepsSum -- sum of repeated totients to reach 1

=head1 SYNOPSIS

 use Math::NumSeq::TotientStepsSum;
 my $seq = Math::NumSeq::TotientStepsSum->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sum of the totients on repeatedly applying the totient function to
reach 1.  For example i=5 applying the totient function goes 5- E<gt> 4
-E<gt> 2 -E<gt> 1 so total value=5+4+2+1=12.

The default is to include the initial i value itself in the sum, with
C<including_self =E<gt> 0> it's excluded, in which case i=5 has
value=4+2+1=7.

See L<Math::NumSeq::TotientPerfect> for starting i values which have a sum
equal to i itself.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::TotientStepsSum-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return the totient steps sum running i down to 1.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Totient>,
L<Math::NumSeq::TotientSteps>

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

# Local variables:
# compile-command: "math-image --values=TotientStepsSumSum"
# End:
