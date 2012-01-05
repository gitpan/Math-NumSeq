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

package Math::NumSeq::WoodallNumbers;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 27;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Devel::Comments;

# use constant name => Math::NumSeq::__('Woodall Numbers');
use constant description => Math::NumSeq::__('Woodall numbers n*2^n-1.');
use constant characteristic_increasing => 1;
use constant characteristic_integer => 1;
use constant values_min => 1;
use constant i_start => 1; # from 1*2^1-1==1

# cf A002234 - Woodall primes
#    A050918 - n for the Woodall primes
#    A056821 - totient(woodall)
use constant oeis_anum => 'A003261';

sub ith {
  my ($self, $i) = @_;
  return $i * 2**$i - 1;
}

sub pred {
  my ($self, $value) = @_;
  ### WoodallNumbers pred(): $value
  {
    my $int = int($value);
    if ($value != $int) { return 0; }
    $value = $int;
  }
  ($value >= 1 && $value & 1) or return 0;
  my $exp = 0;
  $value += 1;  # now seeking $value == $exp * 2**$exp
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

=for stopwords Ryde Math-NumSeq Woodall ie

=head1 NAME

Math::NumSeq::WoodallNumbers -- Woodall numbers i*2^i-1

=head1 SYNOPSIS

 use Math::NumSeq::WoodallNumbers;
 my $seq = Math::NumSeq::WoodallNumbers->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The Woodall numbers 1, 7, 23, 63, etc, i*2^i-1 starting from i=1.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::WoodallNumbers-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i * 2**$i - 1>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a Woodall number, ie. is equal to i*2^i-1 for
some i.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::CullenNumbers>,
L<Math::NumSeq::ProthNumbers>

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
