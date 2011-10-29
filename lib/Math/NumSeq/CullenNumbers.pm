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

package Math::NumSeq::CullenNumbers;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 14;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');
*_is_infinite = \&Math::NumSeq::_is_infinite;

# uncomment this to run the ### lines
#use Devel::Comments;


# use constant name => Math::NumSeq::__('Cullen Numbers');
use constant description => Math::NumSeq::__('Cullen numbers n*2^n+1.');
use constant values_min => 1;
use constant characteristic_monotonic => 1;
use constant oeis_anum => 'A002064';

sub ith {
  my ($self, $i) = @_;
  return $i * 2**$i + 1;
}
sub pred {
  my ($self, $value) = @_;
  ### CullenNumbers pred(): $value

  unless ($value >= 1
          && ($value & 1)
          && $value == int($value)
          && ! _is_infinite($value)) {
    return 0;
  }

  my $exp = 0;
  $value -= 1;  # now seeking $value == $exp * 2**$exp
  for (;;) {
    if ($value <= $exp || $value & 1) {
      return ($value == $exp);
    }
    $value >>= 1;
    $exp++;
  }
}

1;
__END__

=for stopwords Ryde Cullen Math-NumSeq ie

=head1 NAME

Math::NumSeq::CullenNumbers -- Cullen numbers i*2^i+1

=head1 SYNOPSIS

 use Math::NumSeq::CullenNumbers;
 my $seq = Math::NumSeq::CullenNumbers->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Cullen numbers 1, 3, 9, 25, etc, i*2^i+1.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::CullenNumbers-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i * 2**$i + 1>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Cullen number, ie. is equal to i*2^i+1 for
some i.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::WoodallNumbers>

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
