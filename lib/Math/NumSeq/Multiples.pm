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

package Math::NumSeq::Multiples;
use 5.004;
use strict;
use POSIX 'ceil';

use vars '$VERSION', '@ISA';
$VERSION = 14;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Devel::Comments;


use constant name => Math::NumSeq::__('Multiples of a given K');
use constant description => Math::NumSeq::__('The multiples K, 2*K, 3*K, 4*K, etc of a given number.');
use constant values_min => 0;
sub characteristic_monotonic {
  my ($self) = @_;
  # strictly monotonic if multiples of 1 or more
  return 1 + ($self->{'multiples'} >= 1);
}
use constant parameter_info_array =>
  [ { name => 'multiples',
      type => 'float',
      width => 10,
      decimals => 4,
      page_increment => 10,
      step_increment => 1,
      minimum => 0,
      default => 29,
      description => Math::NumSeq::__('Display multiples of this number.  For example 6 means show 6,12,18,24,30,etc.'),
    },
  ];

# cf A017173 9n+1
my %oeis_anum = (1 => 'A001477',  # 1,  integers 0,1,2,...
                 2 => 'A005843',  # 2 even 0,2,4,...

                 3018 => 'A086746', # multiples of 3018, starting from 1
                 # OEIS-Catalogue: A086746 multiples=3018 i_start=1
                );
sub oeis_anum {
  my ($self) = @_;
  return ($oeis_anum{$self->{'multiples'}});

  # ($multiples = $self->{'multiples'}) > 0
  #           && $multiples == int($multiples)
  #           &&
}

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, $i * $self->{'multiples'});
}
sub ith {
  my ($self, $i) = @_;
  return $i * $self->{'multiples'};
}
sub pred {
  my ($self, $value) = @_;
  return ($value == int($value)
          && ($value % $self->{'multiples'}) == 0);
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Multiples -- multiples of a given number

=head1 SYNOPSIS

 use Math::NumSeq::Multiples;
 my $seq = Math::NumSeq::Multiples->new (multiples => 123);
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

A simple sequence of multiples of a given number, for example multiples of 5
gives 0, 5, 10, 15, 20, etc.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Multiples-E<gt>new (multiples =E<gt> $number)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$multiples * $i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is an integer multiple of the given C<$multiples>.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Modulo>

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
