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

package Math::NumSeq::All;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 20;
use Math::NumSeq;
@ISA = ('Math::NumSeq');

# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('All Integers');
use constant description => Math::NumSeq::__('All integers 0,1,2,3,etc.');
use constant characteristic_monotonic => 2;

# experimental i_start to get natural numbers ... probably not very important
# OEIS-Catalogue: A000027 i_start=1
# OEIS-Catalogue: A001477
my %oeis_anum = (0 => 'A001477',  # non-negatives,  starting 0
                 1 => 'A000027'); # natural numbers starting 1
sub oeis_anum {
  my ($self) = @_;
  my $i_start = $self->i_start;
  return ($i_start == 0   ? 'A001477'
          : $i_start == 1 ? 'A000027'
          : undef);
}
sub values_min {
  my ($self) = @_;
  return $self->i_start;
}

sub rewind {
  my ($self) = @_;
  $self->{'i'} = $self->i_start;
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, $i);
}

sub ith {
  my ($self, $i) = @_;
  return $i;
}

sub pred {
  my ($self, $value) = @_;
  return ($value == int($value));
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::All -- all integers

=head1 SYNOPSIS

 use Math::NumSeq::All;
 my $seq = Math::NumSeq::All->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The non-negative integers 0,1,2,3,4, etc.

As a module this is trivial, but it helps put all integers into things using
NumSeq.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::All-E<gt>new ()>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is an integer.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Even>,
L<Math::NumSeq::Odd>

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
