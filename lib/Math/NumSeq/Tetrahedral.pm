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


package Math::NumSeq::Tetrahedral;
use 5.004;
use strict;

use vars '$VERSION','@ISA';
$VERSION = 17;
use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

use Math::NumSeq::Cubes;
*_cbrt_floor = \&Math::NumSeq::Cubes::_cbrt_floor;

# uncomment this to run the ### lines
#use Devel::Comments;

# use constant name => Math::NumSeq::__('Tetrahedral');
use constant description => Math::NumSeq::__('The tetrahedral numbers 0, 1, 4, 10, 20, 35, 56, 84, 120, etc, i*(i+1)*(i+2)/6.');
use constant characteristic_monotonic => 2;
use constant oeis_anum => 'A000292'; # tetrahedrals

sub rewind {
  my ($self) = @_;

  # ENHANCE-ME: cbrt() inverse to set i from requested $lo
  my $i = 0;
  while ($self->ith($i) < $self->{'lo'}) {
    $i++;
  }
  $self->{'i'} = $i;
}
sub ith {
  my ($self, $i) = @_;
  return $i*($i+1)*($i+2)/6;
}

# ENHANCE-ME: cubic equation root formula ?
# ENHANCE-ME: when value big enough only try cbrt+1 and cbrt+2 ?
sub pred {
  my ($self, $value) = @_;
  ### Tetrahedral pred(): $value
  my $i = _cbrt_floor($value);
  for (;;) {
    my $tet = $i*($i+1)*($i+2)/6;
    ### $i
    ### $tet
    return 1 if $value == $tet;
    return 0 unless $tet < $value;
    $i += 1;
  }
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Tetrahedral -- tetrahedral numbers i*(i+1)*(i+2)/6

=head1 SYNOPSIS

 use Math::NumSeq::Tetrahedral;
 my $seq = Math::NumSeq::Tetrahedral->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The tetrahedral numbers, 0, 1, 4, 10, 20, 35, 56, etc, i*(i+1)*(i+2)/6.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Tetrahedral-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i*($i+1)*($i+2)/6>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> has the form i*(i+1)*(i+2)/6 for some positive
integer i.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Cubes>

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
