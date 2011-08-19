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

package Math::NumSeq::Odd;
use 5.004;
use strict;

use Math::NumSeq;
use base 'Math::NumSeq::Even';

use vars '$VERSION';
$VERSION = 3;

# use constant name => Math::NumSeq::__('Odd Integers');
use constant description => Math::NumSeq::__('The odd integers 1, 3, 5, 7, 9, etc.');
use constant values_min => 1;
use constant characteristic_monotonic => 2;
use constant oeis_anum => 'A005408'; # odd 1,3,5,...

# uncomment this to run the ### lines
#use Smart::Comments;

sub rewind {
  my ($self) = @_;
  $self->{'i'} = int ($self->{'lo'} / 2);
}
sub next {
  my ($self) = @_;
  my $i = $self->{'i'}++;
  return ($i, 2*$i+1);
}
sub ith {
  my ($self, $i) = @_;
  return 2*$i+1; # $self->{'lo'} + 2*$i;
}
sub pred {
  my ($class_or_self, $value) = @_;
  ### Odd pred(): $value
  return ($value == int($value)
          && ($value % 2));
}

# sub new {
#   my ($class, %self) = @_;
#   if (defined $self{'lo'}) {
#     $self{'lo'} = ceil($self{'lo'});     # next integer
#     $self{'lo'} += ! ($self{'lo'} & 1);  # next odd, if not already odd
#   } else {
#     $self{'lo'} = 1;
#   }
#   my $self = bless \%self, $class;
#   $self->rewind;
#   return $self;
# }

1;
__END__

=for stopwords Ryde Math-NumSeq

=head1 NAME

Math::NumSeq::Odd -- odd integers

=head1 SYNOPSIS

 use Math::NumSeq::Odd;
 my $seq = Math::NumSeq::Odd->new;
 my ($i, $value) = $seq->next;

=head1 DESCRIPTION

The sequence of odd integers 1, 3, 5, 7, etc.

=head1 FUNCTIONS

=over 4

=item C<$seq = Math::NumSeq::Odd-E<gt>new (key=E<gt>value,...)>

Create and return a new sequence object.

=item C<$value = $seq-E<gt>ith($i)>

Return C<2*$i + 1>.

=item C<$bool = $seq-E<gt>pred($value)>

Return true if C<$value> is odd.

=back

=head1 SEE ALSO

L<Math::NumSeq>,
L<Math::NumSeq::Even>

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
