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

package Math::NumSeq::Even;
use 5.004;
use strict;

use vars '$VERSION', '@ISA';
$VERSION = 13;
use Math::NumSeq;
@ISA = ('Math::NumSeq');


# uncomment this to run the ### lines
#use Smart::Comments;

# use constant name => Math::NumSeq::__('Even Integers');
use constant description => Math::NumSeq::__('The even integers 0, 2, 4, 6, 8, 10, etc.');
use constant values_min => 0;
use constant characteristic_monotonic => 1;
use constant oeis_anum => 'A005843'; # even 0,2,4

sub rewind {
  my ($self) = @_;
  $self->{'i'} = int (($self->{'lo'}+1) / 2);
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, 2*$i);
}
sub ith {
  my ($self, $i) = @_;
  return 2*$i; # $self->{'lo'} + 2*$i;
}
sub pred {
  my ($self, $value) = @_;
  ### Even pred(): $value
  return ($value == int($value)
          && ($value % 2) == 0);
}

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Even -- even integers

=head1 SYNOPSIS

 use Math::NumSeq::Even;
 my $seq = Math::NumSeq::Even->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The even integers 0,2,4,6,8, etc.

=head1 FUNCTIONS

See L<Math::NumSeq/FUNCTIONS> for the behaviour common to all path classes.

=over 4

=item C<$seq = Math::NumSeq::Even-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<2*$i>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is even.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Odd>,
L<Math::NumSeq::All>

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
