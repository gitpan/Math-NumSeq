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

package Math::NumSeq::HarshadNumbers;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 4;

use Math::NumSeq;
use Math::NumSeq::Base::IteratePred;
@ISA = ('Math::NumSeq::Base::IteratePred',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Devel::Comments;

# use constant name => Math::NumSeq::__('Harshad Numbers');
use constant description => Math::NumSeq::__('Harshad numbers (sometimes called Niven numbers), divisible by the sum of their digits.');
use constant values_min => 1;
use constant i_start => 1;
use constant characteristic_monotonic => 1;

use Math::NumSeq::Base::Digits;
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;

my @oeis_anum;

$oeis_anum[2]  = 'A049445';  # binary 1s divide N
# OEIS-Catalogue: A049445 radix=2

$oeis_anum[10] = 'A005349';  # decimal sum digits divide N
# OEIS-Catalogue: A005349

sub oeis_anum {
  my ($class_or_self) = @_;
  my $radix = (ref $class_or_self
               ? $class_or_self->{'radix'}
               : $class_or_self->parameter_default('radix'));
  return $oeis_anum[$radix];
}

sub pred {
  my ($self, $value) = @_;
  ### HarshadNumbers pred(): $value
  if ($value <= 0) {
    return 0;
  }
  my $radix = $self->{'radix'};
  my $sum = 0;
  my $v = $value;
  while ($v) {
    $sum += ($v % $radix);
    $v = int($v/$radix);
  }
  return ! ($value % $sum);
}
# sub ith {
#   my ($self, $i) = @_;
#   return ...
# }

1;
__END__

=for stopwords Ryde Math-NumSeq harshad ie

=head1 NAME

Math::NumSeq::HarshadNumbers -- harshad or Niven numbers

=head1 SYNOPSIS

 use Math::NumSeq::HarshadNumbers;
 my $seq = Math::NumSeq::HarshadNumbers->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The harshad numbers, sometimes called Niven numbers, being integers which
are divisible by the sum of their digits, being 1 to 10, then 12, 18, 20,
21, etc.  For example 18 is a harshad number because 18 is divisible by its
digit sum 1+8=9.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::HarshadNumbers-E<gt>new ()>

=item C<$seq = Math::NumSeq::HarshadNumbers-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.

The optional C<radix> parameter (default 10, decimal) sets the base to use
for the digits.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is a harshad number, ie. is divisible by the sum of
its digits.

=back

=head1 SEE ALSO

L<Math::NumSeq>

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
