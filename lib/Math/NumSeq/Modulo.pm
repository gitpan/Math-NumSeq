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

package Math::NumSeq::Modulo;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 17;

use Math::NumSeq;
use Math::NumSeq::Base::IterateIth;
@ISA = ('Math::NumSeq::Base::IterateIth',
        'Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;

use constant name => Math::NumSeq::__('Modulo');
use constant description => Math::NumSeq::__('Remainder to a given modulus.');
use constant characteristic_smaller => 1;
sub characteristic_modulus {
  my ($self) = @_;
  return $self->{'modulus'};
}
use constant characteristic_monotonic => 0;
use constant parameter_info_array =>
  [ { name        => 'modulus',
      type        => 'integer',
      display     => Math::NumSeq::__('Modulus'),
      default     => 13,
      minimum     => 1,
      width       => 3,
      description => Math::NumSeq::__('Modulus.'),
    } ];

use constant values_min => 0;
sub values_max {
  my ($self) = @_;
  return abs($self->{'modulus'}) - 1;
}

my @oeis_anum = (undef,  # 0
                 'A000004',  # mod 1, 0,0,0,0,etc all zeros
                 # OEIS-Other: A000004 modulus=1

                 'A000035',  # 2, 0,1,0,1,0,1,etc
                 # OEIS-Catalogue: A000035 modulus=2
                 'A010872',  # 3
                 # OEIS-Catalogue: A010872 modulus=3
                 'A010873',  # 4
                 # OEIS-Catalogue: A010873 modulus=4
                 'A010874',  # 5
                 # OEIS-Catalogue: A010874 modulus=5
                 'A010875',  # 6
                 # OEIS-Catalogue: A010875 modulus=6
                 'A010876',  # 7
                 # OEIS-Catalogue: A010876 modulus=7
                 'A010877',  # 8
                 # OEIS-Catalogue: A010877 modulus=8
                 'A010878',  # 9
                 # OEIS-Catalogue: A010878 modulus=9
                 'A010879',  # 10
                 # OEIS-Catalogue: A010879 modulus=10
                 'A010880',  # 11
                 # OEIS-Catalogue: A010880 modulus=11
                 'A010881',  # 12
                 # OEIS-Catalogue: A010881 modulus=12
                 undef,  # 13
                 undef,  # 14
                 undef,  # 15
                 'A130909',  # 16
                 # OEIS-Catalogue: A130909 modulus=16
                );
sub oeis_anum {
  my ($self) = @_;
  my $modulus;
  return (($modulus = $self->{'modulus'}) > 0
          && $modulus == int($modulus)
          && $oeis_anum[$modulus]);
}

sub ith {
  my ($self, $i) = @_;
  return ($i % $self->{'modulus'});
}

sub pred {
  my ($self, $value) = @_;
  return ($value >= 0 && $value < $self->{'modulus'} && $value == int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Modulo -- remainders modulo of a given number

=head1 SYNOPSIS

 use Math::NumSeq::Modulo;
 my $seq = Math::NumSeq::Modulo->new (modulus => 123);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

A simple sequence of remainders to a given modulus of a given number, for
example modulus 5 gives 0, 1, 2, 3, 4, 0, 1, 2, 3, 4, etc.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Modulo-E<gt>new (modulus =E<gt> $number)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i % $modulus>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> occurs as a remainder, so 0 E<lt>= C<$value> E<lt>=
modulus-1.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Multiples>

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