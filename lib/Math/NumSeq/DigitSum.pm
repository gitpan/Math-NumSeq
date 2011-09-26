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

package Math::NumSeq::DigitSum;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 6;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

use constant name => Math::NumSeq::__('Digit Sum');
use constant description => Math::NumSeq::__('Sum of the digits in the given radix.  For binary this is how many 1 bits.');
use constant values_min => 0;
use constant characteristic_monotonic => 0;
use constant characteristic_smaller => 1;

use Math::NumSeq::Base::Digits;
*parameter_info_array = \&Math::NumSeq::Base::Digits::parameter_info_array;


my @oeis = (undef,
            undef,
            'A000120', # 2 binary, number of 1s, cf DigitCount

            'A053735', # 3 ternary
            # OEIS-Catalogue: A053735 radix=3

            'A053737', # 4
            # OEIS-Catalogue: A053737 radix=4

            'A053824', # 5
            # OEIS-Catalogue: A053824 radix=5

            'A053827', # 6
            # OEIS-Catalogue: A053827 radix=6

            'A053828', # 7
            # OEIS-Catalogue: A053828 radix=7

            'A053829', # 8
            # OEIS-Catalogue: A053829 radix=8

            'A053830', # 9
            # OEIS-Catalogue: A053830 radix=9

            'A007953', # 10 decimal
            # OEIS-Catalogue: A007953 radix=10

            'A053831', # 11
            # OEIS-Catalogue: A053831 radix=11

            'A053832', # 12
            # OEIS-Catalogue: A053832 radix=12

            'A053833', # 13
            # OEIS-Catalogue: A053833 radix=13

            'A053834', # 14
            # OEIS-Catalogue: A053834 radix=14

            'A053835', # 15
            # OEIS-Catalogue: A053835 radix=15

            'A053836', # 16
            # OEIS-Catalogue: A053836 radix=16
           );
sub oeis_anum {
  my ($class_or_self) = @_;
  my $radix = (ref $class_or_self
               ? $class_or_self->{'radix'}
               : $class_or_self->parameter_default('radix'));
  return $oeis[$radix];
}


# uncomment this to run the ### lines
#use Smart::Comments;

# ENHANCE-ME:
# next() is +1 mod m, except when xx09 wraps to xx10 which is +2,
# or when x099 to x100 then +3, etc extra is how many low 9s
#
# sub next {
#   my ($self) = @_;
#   my $radix = $self->{'radix'};
#   my $sum = $self->{'sum'} + 1;
#   if (++$self->{'digits'}->[0] >= $radix) {
#     $self->{'digits'}->[0] = 0;
#     my $i = 1;
#     for (;;) {
#       $sum++;
#       if (++$self->{'digits'}->[$i] < $radix) {
#         last;
#       }
#     }
#   }
#   return ($self->{'i'}++, ($self->{'sum'} = ($sum % $radix)));
# }
  
sub ith {
  my ($self, $i) = @_;
  my $radix = $self->{'radix'};
  my $sum = 0;
  while ($i) {
    $sum += ($i % $radix);
    $i = int($i/$radix)
  }
  return $sum;
}

sub pred {
  my ($self, $value) = @_;
  return ($value == int($value)
          && $value >= 0);
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::DigitSum -- sum of digits

=head1 SYNOPSIS

 use Math::NumSeq::DigitSum;
 my $seq = Math::NumSeq::DigitSum->new (radix => 10);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sum of digits in each i, so 0,1,...,9,1,2,..., etc.  For example at
i=123 the value is 1+2+3=6.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::DigitSum-E<gt>new ()>

=item C<$seq = Math::NumSeq::DigitSum-E<gt>new (radix =E<gt> $r)>

Create and return a new sequence object.  The default radix is 10,
ie. decimal, or a C<radix> parameter can be given.

=item C<$value = $seq-E<gt>ith($i)>

Return the sum of the digits of C<$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs as the sum of digits, which means simply
C<$value E<gt>= 0>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::DigitLength>,
L<Math::NumSeq::DigitProduct>,
L<Math::NumSeq::DigitSumModulo>

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
